import 'package:flutter/material.dart';

import '../../constant/data.dart';
import '../../constant/style.dart';
import '../../models/portfolio_models.dart';
import '../../widgets/section_header.dart';
import '../../widgets/tool_chips.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Experience'),
        for (final experience in Data.experiences) ...[
          const SizedBox(height: 22),
          Text(experience.company, style: kTitle.copyWith(color: kMainColor)),
          for (final role in experience.roles) _RoleBlock(role: role),
        ],
      ],
    );
  }
}

class _RoleBlock extends StatelessWidget {
  const _RoleBlock({required this.role});

  final PortfolioRole role;

  @override
  Widget build(BuildContext context) {
    final details = role.details.skip(1);
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(role.headline.value, style: kTextSub2),
          const SizedBox(height: 2),
          Text(role.headline.label, style: kTextCaption),
          const SizedBox(height: 10),
          for (final row in details) ...[
            Text(row.label, style: kTextCaption),
            const SizedBox(height: 2),
            Text(row.value, style: kTextBody.copyWith(color: kTextColorGrey)),
            const SizedBox(height: 10),
          ],
          const Text('Tools', style: kTextCaption),
          const SizedBox(height: 8),
          ToolChips(tools: role.tools),
          const SizedBox(height: 8),
          const Divider(color: kTextColorLightGreyLines, height: 28),
        ],
      ),
    );
  }
}
