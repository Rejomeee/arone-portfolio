import 'package:flutter/material.dart';
import 'package:flutter_my_portfolio/components/navigation_tab.dart';
import 'package:flutter_my_portfolio/components/soc_icon.dart';
import 'package:flutter_my_portfolio/components/white_container.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive/rive.dart';

import 'sections/about_me_section.dart';
import 'sections/expand_my_skills_section.dart';
import 'sections/experience_section.dart';
import 'sections/get_in_touch.dart';
import 'sections/introduction_section.dart';
import 'sections/left_container_section.dart';
import 'sections/project_section.dart';
import 'sections/tab_bar.dart';
import 'dart:js' as js;

class MobileView extends StatefulWidget {
  MobileView({Key? key, this.constraints}) : super(key: key);
  final BoxConstraints? constraints;

  static const TOP_PADDING_SIZE = 32.0;
  static const PAGE_PADDING_SIZE = 18.0;

  static const MAIN_COLOR = Color(0xff5A72EA);
  static const SUB_COLOR = Color(0xffFF5A59);

  static const MIN_TABLET_SIZE = 1080;

  static const VERTICAL_PAGE_PADDING = 54.0;
  static const HORIZONTAL_PAGE_PADDING = 48.0;

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  final PAGE_CONTENT_PADDING = const EdgeInsets.symmetric(
    vertical: MobileView.VERTICAL_PAGE_PADDING,
    horizontal: MobileView.HORIZONTAL_PAGE_PADDING,
  );

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
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.of(context).pop();
    }
  }

  // this variable determnines whether the back-to-top button is shown or not
  bool _showBackToTopButton = false;

  // scroll controller
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 400) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        // child: Text('hehe'),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            const RiveAnimation.asset(
              'assets/animations/clouds_bg.riv',
              fit: BoxFit.fill,
            ),
            _buildListDetail(false),
          ],
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: Drawer(
          child: _buildNavigation(false),
        ),
      ),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            ),
    );
  }

  Widget _buildNavigation(bool forTablet) {
    return Padding(
      padding:
          EdgeInsets.only(top: forTablet ? MobileView.TOP_PADDING_SIZE : 0),
      child: LeftContainerSection(
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
                    js.context.callMethod('open', [Data.FACEBOOK_URL]);
                  },
                  icon: FontAwesomeIcons.facebookF,
                ),
                // SocIcon(
                //   onTap: () {},
                //   icon: FontAwesomeIcons.twitter,
                // ),
                SocIcon(
                  onTap: () {
                    js.context.callMethod('open', [Data.LINKEDIN_URL]);
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
    );
  }

  Widget _buildListDetail(bool forTablet) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Visibility(visible: !forTablet, child: AppTabBar()),
          IntroductionSection(
            key: keys[0],
            constraints: widget.constraints,
          ),
          const SizedBox(
            height: 15,
          ),
          WhiteContainer(
            child: AboutMeSection(
              key: keys[1],
              title: 'About me',
            ),
            constraints: widget.constraints,
          ),
          const SizedBox(
            height: 15,
          ),
          WhiteContainer(
            child: ExperienceSection(
              key: keys[2],
              title: 'Experiences',
            ),
            constraints: widget.constraints,
          ),
          const SizedBox(
            height: 15,
          ),
          WhiteContainer(
            child: ProjectSection(
              key: keys[3],
              title: 'Projects',
            ),
            constraints: widget.constraints,
          ),
          const SizedBox(
            height: 15,
          ),
          WhiteContainer(
            child: ExpandMySkillsSection(
              key: keys[4],
              title: 'Expand my skills',
            ),
            constraints: widget.constraints,
          ),
          const SizedBox(
            height: 15,
          ),
          WhiteContainer(
            child: GetInTouchSection(
              key: keys[5],
              title: 'Get in touch',
            ),
            constraints: widget.constraints,
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
