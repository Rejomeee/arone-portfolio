import 'package:flutter/material.dart';

import '../../constant/data.dart';
import '../../constant/style.dart';
import '../../widgets/section_header.dart';

class ExpandMySkillsSection extends StatelessWidget {
  const ExpandMySkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'What I want to grow'),
        const SizedBox(height: 16),
        Text(
          "I'd like to expand my skills and knowledge in several fields:",
          style: kTextBody.copyWith(color: kTextColorGrey),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final skill in Data.skillsToGrow)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: kCardTint,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kCardBorder),
                ),
                child: Text(skill, style: kTextSub),
              ),
          ],
        ),
      ],
    );
  }
}
