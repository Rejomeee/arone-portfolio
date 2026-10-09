import 'package:flutter/material.dart';

import '../components/white_container.dart';
import '../screens/sections/about_me_section.dart';
import '../screens/sections/expand_my_skills_section.dart';
import '../screens/sections/experience_section.dart';
import '../screens/sections/get_in_touch.dart';
import '../screens/sections/introduction_section.dart';
import '../screens/sections/project_section.dart';

class PortfolioSections extends StatelessWidget {
  const PortfolioSections({
    super.key,
    required this.constraints,
    required this.sectionKeys,
    this.controller,
    this.header,
    this.padding = EdgeInsets.zero,
  });

  final BoxConstraints constraints;
  final List<GlobalKey> sectionKeys;
  final ScrollController? controller;
  final Widget? header;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: padding,
      children: [
        ?header,
        IntroductionSection(
          key: sectionKeys[0],
          constraints: constraints,
        ),
        WhiteContainer(
          key: sectionKeys[1],
          constraints: constraints,
          child: const AboutMeSection(),
        ),
        WhiteContainer(
          key: sectionKeys[2],
          constraints: constraints,
          child: const ExperienceSection(),
        ),
        WhiteContainer(
          key: sectionKeys[3],
          constraints: constraints,
          child: const ProjectSection(),
        ),
        WhiteContainer(
          key: sectionKeys[4],
          constraints: constraints,
          child: const ExpandMySkillsSection(),
        ),
        WhiteContainer(
          key: sectionKeys[5],
          constraints: constraints,
          child: const GetInTouchSection(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
