import 'package:flutter/material.dart';
import 'package:flutter_my_portfolio/constant/style.dart';

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({Key? key, this.child, this.constraints})
      : super(key: key);
  final BoxConstraints? constraints;

  final dynamic child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(
        vertical: 25,
        horizontal: constraints!.maxWidth >= 700 ? 70 : 30,
      ),
      decoration: const BoxDecoration(
        color: kColorWhite,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: child,
    );
  }
}
