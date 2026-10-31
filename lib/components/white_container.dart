import 'package:flutter/material.dart';
import '../constant/style.dart';

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({super.key, required this.child, this.constraints});
  final Widget child;
  final BoxConstraints? constraints;
  @override
  Widget build(BuildContext context) {
    final wide = (constraints?.maxWidth ?? 800) >= 720;
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: EdgeInsets.all(wide ? 36 : 24),
      decoration: BoxDecoration(
        color: kColorWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kCardBorder),
      ),
      child: child,
    );
  }
}
