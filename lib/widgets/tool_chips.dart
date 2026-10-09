import 'package:flutter/material.dart';

import '../constant/style.dart';

class ToolChips extends StatelessWidget {
  const ToolChips({super.key, required this.tools});

  final List<String> tools;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tool in tools)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kBadgeColorGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tool,
              style: kTextCaption.copyWith(color: kColorWhite),
            ),
          ),
      ],
    );
  }
}
