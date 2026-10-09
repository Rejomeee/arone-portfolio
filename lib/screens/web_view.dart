import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constant/style.dart';
import '../widgets/cloud_background.dart';
import '../widgets/portfolio_sections.dart';
import '../widgets/profile_card.dart';

class WebView extends StatefulWidget {
  const WebView({super.key, required this.constraints});

  final BoxConstraints constraints;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final _scrollController = ScrollController();
  final _sectionKeys = List<GlobalKey>.generate(6, (_) => GlobalKey());
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset >= 400;
      if (show != _showBackToTop) {
        setState(() => _showBackToTop = show);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(int index) {
    final target = _sectionKeys[index].currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    const sidebarWidth = 300.0;
    const gap = 20.0;
    const inset = 16.0;
    final pageWidth = math.max(0.0, widget.constraints.maxWidth - inset * 2);
    final frameWidth = math.min(1180.0, pageWidth);
    final contentWidth = math.max(0.0, frameWidth - sidebarWidth - gap);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      floatingActionButton: _showBackToTop
          ? FloatingActionButton.small(
              tooltip: 'Back to top',
              backgroundColor: kMainColor,
              foregroundColor: kColorWhite,
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward_rounded),
            )
          : null,
      body: Stack(
        children: [
          const Positioned.fill(child: CloudBackground()),
          Padding(
            padding: const EdgeInsets.all(inset),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: frameWidth,
                height: math.max(0, widget.constraints.maxHeight - inset * 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: sidebarWidth,
                      child: ProfileCard(
                        fillHeight: true,
                        onSectionSelected: _scrollTo,
                      ),
                    ),
                    const SizedBox(width: gap),
                    Expanded(
                      child: PortfolioSections(
                        controller: _scrollController,
                        constraints: BoxConstraints(maxWidth: contentWidth),
                        sectionKeys: _sectionKeys,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
