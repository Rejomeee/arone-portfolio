import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'cms/cms_screen.dart';
import 'constant/data.dart';
import 'screens/portfolio_page.dart';
import 'services/content_repository.dart';
import 'theme/app_theme.dart';
import 'utils/section_fragment.dart';
export 'screens/portfolio_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialSection = readSectionFragment();
  final path = Uri.base.path.replaceFirst(RegExp(r'/$'), '');
  final showEditor = path.endsWith('/ekko') || initialSection == 'ekko';
  await Data.initialize();
  await RiveFile.initialize();
  runApp(MyApp(initialSection: initialSection, showEditor: showEditor));
  if (!showEditor) unawaited(_refreshPublishedContent());
}

Future<void> _refreshPublishedContent() async {
  final repository = ContentRepository();
  try {
    Data.apply(await repository.loadPublished());
  } catch (error) {
    debugPrint('Using bundled portfolio content: $error');
  } finally {
    repository.close();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.initialSection = '', this.showEditor = false});
  final String initialSection;
  final bool showEditor;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Data.changes,
    builder: (context, _) => MaterialApp(
      title: showEditor ? 'Ekko · Portfolio editor' : Data.webTitle,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/',
      home: showEditor
          ? const CmsScreen()
          : SelectionArea(
              child: PortfolioPage(
                key: ValueKey(Data.content),
                initialSection: readSectionFragment().isEmpty
                    ? initialSection
                    : readSectionFragment(),
              ),
            ),
    ),
  );
}
