import 'package:flutter/cupertino.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';

class ProjectSection extends StatelessWidget {
  final String? title;
  const ProjectSection({Key? key, this.title}) : super(key: key);

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
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemCount: (Data.PROJECTS as dynamic).length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Text(
                        '${(Data.PROJECTS[index]['type'] as dynamic)}: ',
                        style: kTextSub.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),
                    Flexible(
                      flex: 9,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${(Data.PROJECTS[index]['description'] as dynamic)}',
                          style:
                              kTextSub2.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 3,
                        child: Text(
                          'Features: ',
                          style: kTextSub.copyWith(fontStyle: FontStyle.italic),
                        )),
                    Flexible(
                      flex: 9,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 10),
                        shrinkWrap: true,
                        itemCount: (Data.PROJECTS[index]['features'] as dynamic)
                            .length,
                        itemBuilder: (context, featureIndex) => Wrap(
                          children: [
                            Text(
                                '- ${(Data.PROJECTS[index]['features'] as dynamic)[featureIndex]}',
                                style: kTextSub2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 3,
                        child: Text('Tools: ',
                            style: kTextSub.copyWith(
                                fontStyle: FontStyle.italic))),
                    Flexible(
                      flex: 9,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: ((Data.PROJECTS[index]['build_with']
                                  as dynamic) as List<String>)
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
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
