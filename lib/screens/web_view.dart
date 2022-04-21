import 'package:flutter/material.dart';
import 'package:flutter_my_portfolio/components/navigation_tab.dart';
import 'package:flutter_my_portfolio/components/soc_icon.dart';
import 'package:flutter_my_portfolio/components/white_container.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive/rive.dart';
import 'dart:js' as js;

import 'sections/about_me_section.dart';
import 'sections/expand_my_skills_section.dart';
import 'sections/experience_section.dart';
import 'sections/get_in_touch.dart';
import 'sections/introduction_section.dart';
import 'sections/left_container_section.dart';
import 'sections/project_section.dart';

class WebView extends StatelessWidget {
  const WebView({Key? key, this.constraints}) : super(key: key);

  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    final keys = [
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
    ];

    void scrollToIndex(int index) {
      Scrollable.ensureVisible(
        keys[index].currentContext!,
        duration: const Duration(milliseconds: 500),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: constraints?.maxHeight,
        decoration: const BoxDecoration(
          color: kBackgroundColor,
        ),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            const RiveAnimation.asset(
              'assets/animations/clouds_bg.riv',
              fit: BoxFit.fill,
            ),
            ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 4,
                      child: SizedBox(
                        width: constraints!.maxWidth * 0.5,
                      ),
                    ),
                    Flexible(
                      flex: 8,
                      child: SizedBox(
                        width: constraints!.maxWidth * 0.5,
                        child: Column(
                          children: [
                            IntroductionSection(
                              key: keys[0],
                              constraints: constraints,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            WhiteContainer(
                              child: AboutMeSection(
                                key: keys[1],
                                title: 'About me',
                              ),
                              constraints: constraints,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            WhiteContainer(
                              child: ExperienceSection(
                                key: keys[2],
                                title: 'Experiences',
                              ),
                              constraints: constraints,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            WhiteContainer(
                              child: ProjectSection(
                                key: keys[3],
                                title: 'Projects',
                              ),
                              constraints: constraints,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            WhiteContainer(
                              child: ExpandMySkillsSection(
                                key: keys[4],
                                title: 'Expand my skills',
                              ),
                              constraints: constraints,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            WhiteContainer(
                              child: GetInTouchSection(
                                key: keys[5],
                                title: 'Get in touch',
                              ),
                              constraints: constraints,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  flex: 4,
                  child: Column(
                    children: [
                      LeftContainerSection(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NavigationTab(
                              icon: Icons.home,
                              title: 'Home',
                              onTap: () {
                                scrollToIndex(0);
                              },
                            ),
                            NavigationTab(
                              icon: Icons.account_box,
                              title: 'About',
                              onTap: () {
                                scrollToIndex(1);
                              },
                            ),
                            NavigationTab(
                              icon: Icons.book,
                              title: 'Experience',
                              onTap: () {
                                scrollToIndex(2);
                              },
                            ),
                            NavigationTab(
                              icon: Icons.work,
                              title: 'Project',
                              onTap: () {
                                scrollToIndex(3);
                              },
                            ),
                            NavigationTab(
                              icon: Icons.star,
                              title: 'Interested',
                              onTap: () {
                                scrollToIndex(4);
                              },
                            ),
                            NavigationTab(
                              icon: Icons.contacts,
                              title: 'Contact',
                              onTap: () {
                                scrollToIndex(5);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Wrap(
                              spacing: 6,
                              children: [
                                SocIcon(
                                  onTap: () {
                                    js.context.callMethod(
                                        'open', [Data.FACEBOOK_URL]);
                                  },
                                  icon: FontAwesomeIcons.facebookF,
                                ),
                                // SocIcon(
                                //   onTap: () {},
                                //   icon: FontAwesomeIcons.twitter,
                                // ),
                                SocIcon(
                                  onTap: () {
                                    js.context.callMethod(
                                        'open', [Data.LINKEDIN_URL]);
                                  },
                                  icon: FontAwesomeIcons.linkedin,
                                ),
                                const SocIcon(
                                  onTap: null,
                                  //     () {
                                  //   js.context.callMethod('open',
                                  //       [Data.PORTFOLIO_URL]);
                                  // },
                                  icon: FontAwesomeIcons.globe,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 120,
                        width: 120,
                        child: RiveAnimation.asset(
                          'assets/animations/falling_charac.riv',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 35,
                ),
                const Expanded(
                  flex: 8,
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
