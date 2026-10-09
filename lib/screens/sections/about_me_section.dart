import 'package:flutter/material.dart';

import '../../constant/data.dart';
import '../../constant/style.dart';
import '../../utils/open_link.dart';
import '../../widgets/section_header.dart';

class AboutMeSection extends StatelessWidget {
  const AboutMeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'About me'),
        const SizedBox(height: 18),
        Text('Yo,', style: kHeadline2.copyWith(color: kMainColor)),
        const SizedBox(height: 12),
        for (final paragraph in Data.aboutMe) ...[
          Text(paragraph, style: kTextBody.copyWith(color: kTextColorGrey)),
          const SizedBox(height: 14),
        ],
        const SizedBox(height: 6),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final fact in Data.aboutFacts.entries)
              _FactTile(label: fact.key, value: fact.value),
          ],
        ),
        const SizedBox(height: 28),
        const Text('Education', style: kHeadline3),
        const SizedBox(height: 10),
        const Text(Data.educationTitle, style: kTextSub2),
        const SizedBox(height: 4),
        const Text(Data.educationDetail, style: kTextSub),
      ],
    );
  }
}

class _FactTile extends StatelessWidget {
  const _FactTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isEmail = label == 'Email';
    final valueStyle = isEmail
        ? kTextSub2.copyWith(color: kColorBlue)
        : kTextSub2;

    return Container(
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kCardTint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kTextCaption),
          const SizedBox(height: 4),
          if (isEmail)
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => openLink('mailto:$value'),
                child: Text(value, style: valueStyle),
              ),
            )
          else
            Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
