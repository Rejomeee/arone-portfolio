import 'package:flutter/material.dart';
import 'package:flutter_my_portfolio/constant/style.dart';

class SocIcon extends StatelessWidget {
  const SocIcon({
    Key? key,
    this.onTap,
    this.icon,
    this.color,
  }) : super(key: key);

  final void Function()? onTap;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onTap == null
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            color: onTap == null ? kTextColorLightGreyLines : kColorWhite,
          ),
          child: Icon(
            icon,
            size: 16.0,
            color: onTap == null ? kTextColorGrey : color,
          ),
        ),
      ),
    );
  }
}
