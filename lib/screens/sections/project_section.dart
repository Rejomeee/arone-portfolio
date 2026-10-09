import 'package:flutter/material.dart';

import '../../constant/data.dart';
import '../../constant/style.dart';
import '../../models/portfolio_models.dart';
import '../../widgets/section_header.dart';
import '../../widgets/tool_chips.dart';

class ProjectSection extends StatelessWidget {
  const ProjectSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Projects'),
        for (final project in Data.projects) _ProjectCard(project: project),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCardTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.title, style: kTextSub2.copyWith(color: kMainColor)),
          const SizedBox(height: 8),
          Text(
            project.summary,
            style: kTextBody.copyWith(color: kTextColorGrey),
          ),
          const SizedBox(height: 14),
          const Text('Features', style: kTextCaption),
          const SizedBox(height: 6),
          for (final feature in project.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  ', style: kTextSub),
                  Expanded(child: Text(feature, style: kTextSub)),
                ],
              ),
            ),
          const SizedBox(height: 12),
          const Text('Built with', style: kTextCaption),
          const SizedBox(height: 8),
          ToolChips(tools: project.tools),
        ],
      ),
    );
  }
}
