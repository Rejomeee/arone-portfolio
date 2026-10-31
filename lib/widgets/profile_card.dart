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
    this.selectedIndex = 0,
    this.rounded = true,
  });
  final ValueChanged<int> onSectionSelected;
  final int selectedIndex;
  final bool rounded;
  static const _sections = <(IconData, String)>[
    (Icons.home_outlined, 'Home'),
    (Icons.person_outline_rounded, 'About'),
    (Icons.grid_view_rounded, 'Projects'),
    (Icons.work_outline_rounded, 'Experience'),
    (Icons.mail_outline_rounded, 'Contact'),
  ];
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: kColorWhite,
      borderRadius: BorderRadius.circular(rounded ? 16 : 0),
      border: Border.all(color: kCardBorder),
    ),
    child: LayoutBuilder(
      builder: (context, available) {
        final compact = available.maxHeight < 820;
        // Keep ordinary desktop heights fixed; allow access at small heights or
        // enlarged system text, where fitting every control is not possible.
        final needsScroll =
            available.maxHeight < 620 ||
            MediaQuery.textScalerOf(context).scale(15) > 19;
        final animated = !MediaQuery.disableAnimationsOf(context);
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: compact ? 28 : 36,
              backgroundColor: kCardTint,
              backgroundImage: const AssetImage(Data.avatar),
            ),
            SizedBox(height: compact ? 12 : 20),
            Text(Data.name, style: kTitle),
            SizedBox(height: compact ? 6 : 8),
            Text(Data.role, style: kTextSub),
            SizedBox(height: compact ? 6 : 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: kTextColorGrey,
                ),
                SizedBox(width: 4),
                Expanded(child: Text(Data.location, style: kTextCaption)),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: compact ? 12 : 20),
              child: const Divider(height: 1),
            ),
            for (var i = 0; i < _sections.length; i++)
              NavigationTab(
                icon: _sections[i].$1,
                title: _sections[i].$2,
                selected: selectedIndex == i,
                compact: compact,
                onTap: () => onSectionSelected(i),
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: compact ? 12 : 20),
              child: const Divider(height: 1),
            ),
            const Text('ELSEWHERE', style: kTextCaption),
            const SizedBox(height: 12),
            const SocialLinks(),
            if (animated)
              if (needsScroll)
                const SizedBox(height: 96, child: _FallingCharacter())
              else
                const Flexible(child: _FallingCharacter()),
          ],
        );
        final padding = EdgeInsets.all(compact ? 16 : 22);
        if (needsScroll) {
          return SingleChildScrollView(padding: padding, child: content);
        }
        return Padding(padding: padding, child: content);
      },
    ),
  );
}

class _FallingCharacter extends StatelessWidget {
  const _FallingCharacter();
  @override
  Widget build(BuildContext context) => const Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: EdgeInsets.only(top: 8),
      child: ExcludeSemantics(
        child: SizedBox(
          width: 108,
          height: 108,
          child: RiveAnimation.asset('assets/animations/falling_charac.riv'),
        ),
      ),
    ),
  );
}
