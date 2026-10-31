import 'package:flutter/material.dart';
import '../constant/style.dart';

class NavigationTab extends StatelessWidget {
  const NavigationTab({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.selected = false,
    this.compact = false,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;
  final bool compact;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: compact ? 1 : 3),
    child: Semantics(
      selected: selected,
      child: Material(
        color: selected ? kCardTint : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          focusColor: kMainColor.withValues(alpha: 0.15),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: compact ? 8 : 14,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? kMainColor : kTextColorGrey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: kTextSub.copyWith(
                      color: selected ? kMainColor : kTextColorGrey,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: kMainColor,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
