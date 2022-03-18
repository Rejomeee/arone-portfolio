import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

import 'constant/bloc_providers.dart';
import 'cubit/flutter_bird/flutter_bird_cubit.dart';

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
  /* Animation Start */
  SMIInput<bool>? flutterBirdIsClicked;

  loadAnimations() async {
    Artboard? flutterBirdArtboard;

    await rootBundle.load('assets/animations/flutter_bird.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;

        final controller =
            StateMachineController.fromArtboard(artboard, 'birb');
        if (controller != null) {
          artboard.addController(controller);
          flutterBirdIsClicked = controller.findInput('dance');
          flutterBirdIsClicked?.value = true;
        }
        flutterBirdArtboard = artboard;
      },
    );

    context.read<FlutterBirdCubit>().animateFlutterBird(flutterBirdArtboard);
  }

  @override
  void initState() {
    super.initState();
    loadAnimations();
  }

  /* Animation End */
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrain) {
        return constrain.maxWidth >= MIN_TABLET_SIZE
                // ? _buildTabletBody(constrain.maxWidth)
                ? Scaffold(
                    body: Container(
                      height: constrain.maxHeight,
                      decoration: const BoxDecoration(
                        color: kBackgroundColor,
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                flex: 4,
                                child: leftContainer(),
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
                          ListView(
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
                                          introductionCard(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          whiteContainer(
                                              aboutMeCard('About me')),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          whiteContainer(
                                              experienceCard('Experiences')),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          whiteContainer(
                                              projectCard('Projects')),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          whiteContainer(expandMySkillsCard(
                                              'Expand my skills')),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
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

  Widget leftContainer() {
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
            NavigationTab(
              icon: Icons.home,
              title: 'Home',
              onTap: () {},
            ),
            NavigationTab(
              icon: Icons.account_box,
              title: 'About',
              onTap: () {},
            ),
            NavigationTab(
              icon: Icons.book,
              title: 'Resume',
              onTap: () {},
            ),
            NavigationTab(
              icon: Icons.work,
              title: 'Work',
              onTap: () {},
            ),
            NavigationTab(
              icon: Icons.contacts,
              title: 'Contacts',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
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

  Widget introductionCard() {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(
        vertical: 80,
        horizontal: 70,
      ),
      decoration: const BoxDecoration(
        color: MAIN_COLOR,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Hi! I'm Arone ",
                style: kHeadline1.copyWith(
                  color: kColorBlack,
                ),
              ),
              BlocBuilder<FlutterBirdCubit, FlutterBirdState>(
                builder: (context, flutterBirdState) {
                  return SizedBox(
                    width: 60,
                    height: 75,
                    // width: MediaQuery.of(context).size.width,
                    child: flutterBirdState is FlutterBirdMove
                        ? GestureDetector(
                            onTap: () {
                              flutterBirdIsClicked?.value =
                                  flutterBirdIsClicked?.value == false
                                      ? true
                                      : false;
                            },
                            child: Rive(
                                artboard:
                                    flutterBirdState.flutterBirdArtboard!),
                          )
                        : const SizedBox(),
                  );
                },
              ),
            ],
          ),
          Text(
            '“One of my most productive days was throwing away 1000 lines of code.”',
            style: kHeadline1.copyWith(
              color: kColorWhite,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '- Ken Thompson -',
              style: kTextBody3.copyWith(
                  color: kColorWhite, fontStyle: FontStyle.italic),
              textAlign: TextAlign.end,
            ),
          ),
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton.icon(
                style: raisedButtonStyle,
                icon: const Icon(Icons.download),
                onPressed: () {},
                label: const Text('Download'),
              ),
              OutlinedButton.icon(
                style: outlineButtonStyle,
                icon: const Icon(Icons.email),
                onPressed: () {},
                label: const Text('Hire me'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget aboutMeCard(title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  Widget experienceCard(title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  Widget projectCard(title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  Widget expandMySkillsCard(title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: kColorWhite,
    primary: kButtonColor,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );

  final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    primary: kColorWhite,
    side: const BorderSide(color: kColorWhite),
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );

  Widget _buildNavigation(bool forTablet) {
    return Padding(
      padding: EdgeInsets.only(top: forTablet ? TOP_PADDING_SIZE : 0),
      child: const Card(
        child: Text('haha'),
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
    return GestureDetector(
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
    );
  }
}
