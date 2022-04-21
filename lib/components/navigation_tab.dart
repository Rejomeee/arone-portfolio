import 'package:flutter/material.dart';
import 'package:flutter_my_portfolio/constant/style.dart';

class NavigationTab extends StatelessWidget {
  const NavigationTab({
    Key? key,
    this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final String? title;
  final IconData? icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: kColorWhite,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '$title',
                style: kTextSub.copyWith(
                  color: kColorWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
