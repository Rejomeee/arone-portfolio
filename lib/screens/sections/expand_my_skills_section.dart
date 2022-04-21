import 'package:flutter/cupertino.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';

class ExpandMySkillsSection extends StatelessWidget {
  final String? title;
  const ExpandMySkillsSection({Key? key, this.title}) : super(key: key);

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
          height: 10,
        ),
        const Text(
          "I'd like to expand my skills and knowledge in several fields:",
          style: kTextBody,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemCount: (Data.EXPAND_SKILLS as dynamic).length,
          itemBuilder: (context, index) => Wrap(
            children: [
              Text('- ${Data.EXPAND_SKILLS[index]}', style: kTextSub),
            ],
          ),
        )
      ],
    );
  }
}
