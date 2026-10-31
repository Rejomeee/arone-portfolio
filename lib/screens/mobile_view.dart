import 'package:flutter/material.dart';
import '../constant/data.dart';
import '../constant/style.dart';
import '../utils/section_navigation.dart';
import '../widgets/portfolio_sections.dart';
import '../widgets/profile_card.dart';
import '../widgets/cloud_background.dart';

class MobileView extends StatelessWidget {
  const MobileView({
    super.key,
    required this.constraints,
    required this.navigation,
  });
  final BoxConstraints constraints;
  final SectionNavigation navigation;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      titleSpacing: 0,
      title: LayoutBuilder(
        builder: (context, available) {
          if (available.maxWidth < 48) return const SizedBox.shrink();
          return Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(Data.avatar),
              ),
              if (available.maxWidth >= 140) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    Data.shortName,
                    style: kTextSub2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => navigation.scrollTo(
            4,
            reduceMotion: MediaQuery.disableAnimationsOf(context),
          ),
          child: const Text('Let’s talk'),
        ),
        const SizedBox(width: 8),
      ],
    ),
    drawer: Drawer(
      backgroundColor: kColorWhite,
      child: SafeArea(
        child: ProfileCard(
          rounded: false,
          selectedIndex: navigation.selected,
          onSectionSelected: (index) {
            Navigator.of(context).pop();
            navigation.scrollTo(
              index,
              reduceMotion: MediaQuery.disableAnimationsOf(context),
            );
          },
        ),
      ),
    ),
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
        PortfolioSections(
          navigation: navigation,
          constraints: constraints,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        ),
      ],
    ),
  );
}
