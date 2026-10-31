import 'package:flutter/material.dart';
import '../../constant/data.dart';
import '../../constant/style.dart';
import '../../models/portfolio_models.dart';
import '../../widgets/section_header.dart';
import '../../widgets/tool_chips.dart';

class ProjectSection extends StatelessWidget {
  const ProjectSection({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionHeader(title: 'Selected projects'),
      const SizedBox(height: 12),
      Text(Data.projectsIntro, style: kTextBody),
      for (var i = 0; i < Data.projects.length; i++)
        _ProjectCard(project: Data.projects[i], index: i),
    ],
  );
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.index});
  final PortfolioProject project;
  final int index;
  static const _visuals = [
    (
      Icons.apartment_rounded,
      'PROJECT COORDINATION',
      'Plan. Connect. Build.',
      Color(0xFFEEF2FF),
    ),
    (
      Icons.local_shipping_outlined,
      'DELIVERY & BOOKING',
      'From booking to delivery.',
      Color(0xFFF0FDFA),
    ),
    (
      Icons.forum_outlined,
      'SOCIAL & MESSAGING',
      'Keep the conversation going.',
      Color(0xFFFFF7ED),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final visual = _visuals[index % _visuals.length];
    return Container(
      margin: const EdgeInsets.only(top: 24),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Editorial cover, not a screenshot or representation of the shipped UI.
          ExcludeSemantics(
            child: Container(
              color: visual.$4,
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.coverLabel,
                          style: kTextCaption.copyWith(
                            letterSpacing: 1,
                            color: kMainColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(project.coverHeadline, style: kTitle),
                        const SizedBox(height: 16),
                        Text(
                          '0${index + 1} / SELECTED WORK',
                          style: kTextCaption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 64,
                    height: 80,
                    decoration: BoxDecoration(
                      color: kColorWhite.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kCardBorder),
                    ),
                    child: Icon(visual.$1, size: 32, color: kMainColor),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.title, style: kTitle),
                const SizedBox(height: 12),
                Text(
                  project.overview,
                  style: kTextBody.copyWith(color: kTextColorGrey),
                ),
                const SizedBox(height: 20),
                Text(
                  'MY CONTRIBUTION',
                  style: kTextCaption.copyWith(
                    letterSpacing: 0.8,
                    color: kMainColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.summary,
                  style: kTextBody.copyWith(color: kTextColorGrey),
                ),
                const SizedBox(height: 18),
                ToolChips(tools: project.tools),
                const SizedBox(height: 14),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 12),
                    title: const Text('Explore features', style: kTextSub2),
                    children: [
                      for (final feature in project.features)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: kMainColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(feature, style: kTextSub)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
