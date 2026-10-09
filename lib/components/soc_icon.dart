import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant/style.dart';

class SocIcon extends StatelessWidget {
  const SocIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final FaIconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: kColorWhite,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: FaIcon(icon, size: 16, color: kMainColor),
          ),
        ),
      ),
    );
  }
}
