import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../components/navigation_tab.dart';
import '../constant/data.dart';
import '../constant/style.dart';
import 'social_links.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.onSectionSelected,
    this.fillHeight = false,
    this.rounded = true,
  });

  final ValueChanged<int> onSectionSelected;
  final bool fillHeight;
  final bool rounded;

  static const _sections = <(IconData, String)>[
    (Icons.home_rounded, 'Home'),
    (Icons.person_rounded, 'About'),
    (Icons.work_history_rounded, 'Experience'),
    (Icons.folder_special_rounded, 'Projects'),
    (Icons.auto_awesome_rounded, 'Interests'),
    (Icons.mail_rounded, 'Contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final navigation = Column(
      children: [
        for (var index = 0; index < _sections.length; index++)
          NavigationTab(
            icon: _sections[index].$1,
            title: _sections[index].$2,
            onTap: () => onSectionSelected(index),
          ),
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: kMainColor,
        borderRadius: BorderRadius.circular(rounded ? 20 : 0),
        boxShadow: rounded
            ? [
                BoxShadow(
                  color: kMainColor.withValues(alpha: 0.28),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: kColorWhite,
              backgroundImage: AssetImage(Data.avatar),
            ),
            const SizedBox(height: 16),
            Text(Data.name, style: kTitle.copyWith(color: kColorWhite)),
            const SizedBox(height: 4),
            Text(
              Data.role,
              style: kTextCaption.copyWith(color: kColorWhite),
            ),
            const SizedBox(height: 4),
            Text(
              Data.location,
              style: kTextCaption.copyWith(
                color: kColorWhite.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            if (fillHeight)
              Expanded(child: SingleChildScrollView(child: navigation))
            else
              navigation,
            const SizedBox(
              height: 108,
              width: 108,
              child: RiveAnimation.asset(
                'assets/animations/falling_charac.riv',
              ),
            ),
            const SocialLinks(),
          ],
        ),
      ),
    );
  }
}
