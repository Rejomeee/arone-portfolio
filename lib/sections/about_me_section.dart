import 'package:flutter/cupertino.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';
import 'dart:js' as js;

class AboutMeSection extends StatelessWidget {
  final String? title;
  const AboutMeSection({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text('$title', style: kHeadline3),
        Container(
          height: 8,
          width: 40,
          margin: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(color: kColorLavender),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'Yo,',
          style: kHeadline2,
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: Data.ABOUT_ME.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 20.0),
            child: Text(
              Data.ABOUT_ME[index],
              style: kTextSub.copyWith(color: kTextColorGrey),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        const Text(
          'Education',
          style: kHeadline3,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          Data.ABOUT_EDUCATION_SCHOOL,
          style: kTextSub2,
        ),
        const Text(
          Data.ABOUT_EDUCATION_SCHOOL_YEAR,
          style: kTextSub,
        ),
      ],
    );
  }
}
