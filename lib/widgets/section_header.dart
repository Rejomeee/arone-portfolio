import 'package:flutter/material.dart';

import '../constant/style.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kHeadline3),
        Container(
          height: 4,
          width: 48,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: kColorLavender,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
