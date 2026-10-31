import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CloudBackground extends StatelessWidget {
  const CloudBackground({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return const SizedBox.expand();
    }
    return const Opacity(
      opacity: 0.24,
      child: IgnorePointer(
        child: RiveAnimation.asset(
          'assets/animations/clouds_bg.riv',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
