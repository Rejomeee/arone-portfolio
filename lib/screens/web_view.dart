import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../constant/style.dart';
import '../utils/section_navigation.dart';
import '../widgets/portfolio_sections.dart';
import '../widgets/profile_card.dart';
import '../widgets/cloud_background.dart';

class WebView extends StatelessWidget {
  const WebView({
    super.key,
    required this.constraints,
    required this.navigation,
  });
  final BoxConstraints constraints;
  final SectionNavigation navigation;
  @override
  Widget build(BuildContext context) {
    const inset = 24.0;
    const sidebar = 264.0;
    const gap = 32.0;
    final width = math.min(
      1240.0,
      math.max(0.0, constraints.maxWidth - inset * 2),
    );
    final horizontalInset = (constraints.maxWidth - width) / 2;
    return Scaffold(
      floatingActionButton: navigation.showBackToTop
          ? FloatingActionButton.small(
              tooltip: 'Back to top',
              backgroundColor: kMainColor,
              foregroundColor: kColorWhite,
              onPressed: () => navigation.scrollTo(
                0,
                reduceMotion: MediaQuery.disableAnimationsOf(context),
              ),
              child: const Icon(Icons.arrow_upward_rounded),
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const CloudBackground(),
          // The viewport spans the whole page, so the scrollbar belongs to the
          // browser edge rather than to the centered content column.
          Scrollbar(
            controller: navigation.controller,
            thumbVisibility: true,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                controller: navigation.controller,
                padding: EdgeInsets.fromLTRB(
                  horizontalInset + sidebar + gap,
                  inset,
                  horizontalInset,
                  inset,
                ),
                child: PortfolioSections(
                  navigation: navigation,
                  scrollable: false,
                  constraints: BoxConstraints(maxWidth: width - sidebar - gap),
                ),
              ),
            ),
          ),
          Positioned(
            left: horizontalInset,
            top: inset,
            bottom: inset,
            width: sidebar,
            child: Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent &&
                    navigation.controller.hasClients) {
                  // Wheel input over the fixed sidebar still scrolls the page.
                  // A short-window sidebar can consume its own scroll first.
                  GestureBinding.instance.pointerSignalResolver.register(
                    event,
                    (_) {
                      final position = navigation.controller.position;
                      navigation.controller.jumpTo(
                        (position.pixels + event.scrollDelta.dy).clamp(
                          position.minScrollExtent,
                          position.maxScrollExtent,
                        ),
                      );
                    },
                  );
                }
              },
              child: ProfileCard(
                selectedIndex: navigation.selected,
                onSectionSelected: (index) => navigation.scrollTo(
                  index,
                  reduceMotion: MediaQuery.disableAnimationsOf(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
