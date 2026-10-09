import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'constant/data.dart';
import 'constant/style.dart';
import 'screens/mobile_view.dart';
import 'screens/web_view.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RiveFile.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Data.webTitle,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const SelectionArea(child: PortfolioPage()),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= kWideLayoutWidth) {
          return WebView(constraints: constraints);
        }
        return MobileView(constraints: constraints);
      },
    );
  }
}
