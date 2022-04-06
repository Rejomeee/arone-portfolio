import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';
import 'package:flutter_my_portfolio/sections/about_me_section.dart';
import 'package:flutter_my_portfolio/sections/expand_my_skills_section.dart';
import 'package:flutter_my_portfolio/sections/get_in_touch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

import 'constant/bloc_providers.dart';
import 'cubit/flutter_bird/flutter_bird_cubit.dart';
import 'sections/experience_section.dart';
import 'sections/introduction_section.dart';
import 'sections/left_container_section.dart';
import 'sections/project_section.dart';
import 'dart:js' as js;

void main() {
  runApp(const MyApp());
}

const TOP_PADDING_SIZE = 32.0;
const PAGE_PADDING_SIZE = 18.0;

const MAIN_COLOR = Color(0xff5A72EA);
const SUB_COLOR = Color(0xffFF5A59);

const MIN_TABLET_SIZE = 1080;

const VERTICAL_PAGE_PADDING = 54.0;
const HORIZONTAL_PAGE_PADDING = 48.0;

const PAGE_CONTENT_PADDING = const EdgeInsets.symmetric(
  vertical: VERTICAL_PAGE_PADDING,
  horizontal: HORIZONTAL_PAGE_PADDING,
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: multipleProviders,
      child: MaterialApp(
        title: Data.WEB_TITLE,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /* Animation End */
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrain) {
        return constrain.maxWidth >= MIN_TABLET_SIZE
                ? Scaffold(
                    key: _scaffoldKey,
                    body: Container(
                      height: constrain.maxHeight,
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
                            padding: const EdgeInsets.only(top: 20),
                            shrinkWrap: true,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: SizedBox(
                                      width: constrain.maxWidth * 0.5,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 8,
                                    child: SizedBox(
                                      width: constrain.maxWidth * 0.5,
                                      child: Column(
                                        children: [
                                          IntroductionSection(
                                            key: keys[0],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          whiteContainer(
                                            AboutMeSection(
                                              key: keys[1],
                                              title: 'About me',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          whiteContainer(
                                            ExperienceSection(
                                              key: keys[2],
                                              title: 'Experiences',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          whiteContainer(
                                            ProjectSection(
                                              key: keys[3],
                                              title: 'Projects',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          whiteContainer(
                                            ExpandMySkillsSection(
                                                key: keys[4],
                                                title: 'Expand my skills'),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          whiteContainer(
                                            GetInTouchSection(
                                                key: keys[5],
                                                title: 'Get in touch'),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      LeftContainerSection(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                        'open',
                                                        [Data.FACEBOOK_URL]);
                                                  },
                                                  icon: FontAwesomeIcons
                                                      .facebookF,
                                                ),
                                                // SocIcon(
                                                //   onTap: () {},
                                                //   icon: FontAwesomeIcons.twitter,
                                                // ),
                                                SocIcon(
                                                  onTap: () {
                                                    js.context.callMethod(
                                                        'open',
                                                        [Data.LINKEDIN_URL]);
                                                  },
                                                  icon:
                                                      FontAwesomeIcons.linkedin,
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
                          ),
                          Container(
                              width: double.infinity,
                              decoration:
                                  const BoxDecoration(color: Colors.yellow),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Please redirect to '),
                                  GestureDetector(
                                    onTap: () {
                                      js.context.callMethod('open', [
                                        'https://rejomeee.github.io/aronejerome.github.io/',
                                        "_self"
                                      ]);
                                    },
                                    child: const Text(
                                      'https://rejomeee.github.io/aronejerome.github.io/',
                                      style: TextStyle(color: kColorBlue),
                                    ),
                                  ),
                                  const Text('. this page will close soon.'),
                                ],
                              )),
                        ],
                      ),
                    ),
                  )
                : const Scaffold(
                    body: Center(
                        child: Text('Mobile view soon. Please use PC :D')))
            // : _buildPhoneBody()
            ;
      },
    );
  }

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
    // if (_scaffoldKey.currentState.isDrawerOpen) {
    //   Navigator.of(context).pop();
    // }
  }

  Widget whiteContainer(child) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 70,
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

  Widget _buildNavigation(bool forTablet) {
    return Padding(
      padding: EdgeInsets.only(top: forTablet ? TOP_PADDING_SIZE : 0),
      child: const Card(
        child: Text('haha'),
      ),
    );
  }
}

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

class NavigationTab extends StatelessWidget {
  const NavigationTab({
    Key? key,
    this.title,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final String? title;
  final IconData? icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: kColorWhite,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '$title',
                style: kTextSub.copyWith(
                  color: kColorWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
