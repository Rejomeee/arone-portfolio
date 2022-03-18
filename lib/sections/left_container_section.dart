import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';

import '../main.dart';

class LeftContainerSection extends StatelessWidget {
  final Widget? child;
  const LeftContainerSection({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MAIN_COLOR,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(Data.AVATAR),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              Data.NAME,
              style: kTitle.copyWith(color: kColorWhite),
            ),
            Text(
              Data.ROLE,
              style: kTextSub.copyWith(
                color: kTextColorLightGreyLines,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            child!,
          ],
        ),
      ),
    );
  }
}

