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
        for (final paragraph in Data.aboutMe) ...[
          Text(paragraph, style: kTextBody.copyWith(color: kTextColorGrey)),
          const SizedBox(height: 14),
        ],
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, available) {
            final columns = available.maxWidth >= 560 ? 2 : 1;
            final width = (available.maxWidth - 12 * (columns - 1)) / columns;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final fact in Data.aboutFacts.entries)
                  SizedBox(
                    width: width,
                    child: _FactTile(label: fact.key, value: fact.value),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        const Text('Education', style: kHeadline3),
        const SizedBox(height: 10),
        Text(Data.educationTitle, style: kTextSub2),
        const SizedBox(height: 4),
        Text(Data.educationDetail, style: kTextSub),
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

    return Material(
      color: kCardTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: kCardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isEmail ? () => openLink('mailto:$value') : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: kTextCaption),
              const SizedBox(height: 4),
              Text(value, style: valueStyle),
            ],
          ),
        ),
      ),
    );
  }
}
