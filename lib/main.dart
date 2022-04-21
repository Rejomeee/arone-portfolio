import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/constant/style.dart';
import 'package:flutter_my_portfolio/screens/mobile_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

import 'constant/bloc_providers.dart';
import 'screens/sections/about_me_section.dart';
import 'screens/sections/expand_my_skills_section.dart';
import 'screens/sections/experience_section.dart';
import 'screens/sections/get_in_touch.dart';
import 'screens/sections/introduction_section.dart';
import 'screens/sections/left_container_section.dart';
import 'screens/sections/project_section.dart';
import 'dart:js' as js;

import 'screens/web_view.dart';

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
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrain) {
        return constrain.maxWidth >= MIN_TABLET_SIZE
            ? WebView(
                constraints: constrain,
              )
            : MobileView(
                constraints: constrain,
              );
      },
    );
  }
}
