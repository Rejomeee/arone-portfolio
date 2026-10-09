import 'package:flutter/material.dart';

import '../constant/data.dart';
import '../constant/style.dart';
import '../widgets/cloud_background.dart';
import '../widgets/portfolio_sections.dart';
import '../widgets/profile_card.dart';

class MobileView extends StatefulWidget {
  const MobileView({super.key, required this.constraints});

  final BoxConstraints constraints;

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kBackgroundColor,
      drawer: Drawer(
        backgroundColor: kMainColor,
        child: SafeArea(
          child: ProfileCard(
            fillHeight: true,
            rounded: false,
            onSectionSelected: (index) {
              Navigator.of(context).pop();
              _scrollTo(index);
            },
          ),
        ),
      ),
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
          Positioned.fill(
            child: PortfolioSections(
              controller: _scrollController,
              constraints: widget.constraints,
              sectionKeys: _sectionKeys,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              header: const _MobileHeader(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: kMainColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Open menu',
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded, color: kColorWhite),
          ),
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(Data.avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              Data.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: kTextSub2.copyWith(color: kColorWhite),
            ),
          ),
        ],
      ),
    );
  }
}
