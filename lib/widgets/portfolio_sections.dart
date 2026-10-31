import 'package:flutter/material.dart';
import '../components/white_container.dart';
import '../constant/style.dart';
import '../constant/data.dart';
import '../screens/sections/about_me_section.dart';
import '../screens/sections/experience_section.dart';
import '../screens/sections/get_in_touch.dart';
import '../screens/sections/introduction_section.dart';
import '../screens/sections/project_section.dart';
import '../utils/section_navigation.dart';

class PortfolioSections extends StatelessWidget {
  const PortfolioSections({
    super.key,
    required this.constraints,
    required this.navigation,
    this.padding = EdgeInsets.zero,
    this.scrollable = true,
  });
  final BoxConstraints constraints;
  final SectionNavigation navigation;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  @override
  Widget build(BuildContext context) {
    // All sections stay mounted so every navigation target is available.
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntroductionSection(
          key: navigation.keys[0],
          constraints: constraints,
          onViewProjects: () => navigation.scrollTo(
            2,
            reduceMotion: MediaQuery.disableAnimationsOf(context),
          ),
        ),
        WhiteContainer(
          key: navigation.keys[1],
          constraints: constraints,
          child: const AboutMeSection(),
        ),
        WhiteContainer(
          key: navigation.keys[2],
          constraints: constraints,
          child: const ProjectSection(),
        ),
        WhiteContainer(
          key: navigation.keys[3],
          constraints: constraints,
          child: const ExperienceSection(),
        ),
        WhiteContainer(
          key: navigation.keys[4],
          constraints: constraints,
          child: const GetInTouchSection(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
          child: Text(
            Data.footer,
            textAlign: TextAlign.center,
            style: kTextCaption,
          ),
        ),
      ],
    );
    if (!scrollable) return Padding(padding: padding, child: content);
    return SingleChildScrollView(
      controller: navigation.controller,
      padding: padding,
      child: content,
    );
  }
}
