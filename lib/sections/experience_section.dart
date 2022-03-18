import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';

class ExperienceSection extends StatelessWidget {
  final String? title;
  const ExperienceSection({Key? key, this.title}) : super(key: key);

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
        ListView.builder(
          padding: const EdgeInsets.only(top: 0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: Data.EXPERIENCES.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: index != 0 ? 20 : 0),
                const SizedBox(
                  height: 15,
                ),
                Text('${Data.EXPERIENCES[index]['title']}', style: kTitle),
                ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      ((Data.EXPERIENCES[index]['jobs'] as dynamic).length) ??
                          0,
                  itemBuilder: (context, jobsIndex) => Column(
                    children: [
                      jobsIndex != 0
                          ? const Divider(
                              color: kTextColorLightGreyLines, thickness: 2)
                          : const SizedBox(),
                      ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ((Data.EXPERIENCES[index]['jobs']
                                    as dynamic)[jobsIndex]['data']
                                .length) ??
                            0,
                        itemBuilder: (context, dataIndex) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  '${(Data.EXPERIENCES[index]['jobs'] as dynamic)[jobsIndex]['data'][dataIndex]['left_text']}: ',
                                  style: kTextSub,
                                ),
                              ),
                              Flexible(
                                flex: 9,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${(Data.EXPERIENCES[index]['jobs'] as dynamic)[jobsIndex]['data'][dataIndex]['right_text']}',
                                    style: kTextSub2.copyWith(
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                              flex: 3,
                              child: Text(
                                'Tools: ',
                                style: kTextSub,
                              )),
                          Flexible(
                            flex: 9,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: ((Data.EXPERIENCES[index]['jobs']
                                            as dynamic)[jobsIndex]['tools']
                                        as List<String>)
                                    .map((tool) => Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 5),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              color: kBadgeColorGreen),
                                          child: Text(
                                            tool,
                                            style: kTextSub2.copyWith(
                                                color: kColorWhite),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
