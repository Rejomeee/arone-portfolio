import 'package:flutter/material.dart';

import '../constant/style.dart';

class NavigationTab extends StatelessWidget {
  const NavigationTab({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          hoverColor: kColorWhite.withValues(alpha: 0.14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Icon(icon, color: kColorWhite, size: 18),
                const SizedBox(width: 10),
                Text(title, style: kTextSub.copyWith(color: kColorWhite)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
