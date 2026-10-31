import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_my_portfolio/cms/cms_screen.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/models/portfolio_content.dart';
import 'package:flutter_my_portfolio/services/github_publisher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(Data.initialize);
  Future<void> openEditor(
    WidgetTester tester, {
    void Function(String)? onExport,
    Future<GitHubPublishResult> Function(String, PortfolioContent)? onPublish,
    Size size = const Size(1200, 1000),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: CmsScreen(
          exportJson: onExport ?? (_) {},
          publishContent:
              onPublish ??
              (_, _) async => const GitHubPublishResult(
                commitUrl:
                    'https://github.com/Rejomeee/arone-portfolio/commit/test',
              ),
          loadPublished: () async => Data.content,
        ),
      ),
    );
  }

  Future<void> unlock(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField), 'Password@1');
    await tester.pumpAndSettle();
  }

  testWidgets(
    'wrong passwords stay locked, the configured password opens the editor',
    (tester) async {
      await openEditor(tester);
      await tester.enterText(find.byType(TextField), 'incorrect');
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
      expect(find.textContaining('doesn’t match'), findsNothing);
      expect(find.text('Export JSON'), findsNothing);
      await unlock(tester);
      expect(find.text('Export JSON'), findsOneWidget);
      expect(find.text('Make it yours.'), findsOneWidget);
    },
  );
  testWidgets(
    'export contains edited content without changing the public view',
    (tester) async {
      String? exported;
      await openEditor(tester, onExport: (value) => exported = value);
      await unlock(tester);
      final originalName = Data.name;
      await tester.enterText(find.byType(TextFormField).first, 'Arone Updated');
      await tester.tap(find.text('Export JSON'));
      await tester.pumpAndSettle();
      expect(jsonDecode(exported!)['profile']['name'], 'Arone Updated');
      expect(Data.name, originalName);
    },
  );
  testWidgets('preview uses the draft and restores public content on exit', (
    tester,
  ) async {
    await openEditor(tester);
    await unlock(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Home'));
    await tester.pumpAndSettle();
    final original = Data.heroHeadline;
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'I build offline-first apps.',
    );
    await tester.tap(find.text('Preview'));
    await tester.pumpAndSettle();
    expect(find.text('I build offline-first apps.'), findsOneWidget);
    expect(Data.heroHeadline, 'I build offline-first apps.');
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(Data.heroHeadline, original);
    expect(find.text('Make it yours.'), findsOneWidget);
  });
  testWidgets(
    'empty required content blocks export with a useful field error',
    (tester) async {
      var exports = 0;
      await openEditor(tester, onExport: (_) => exports++);
      await unlock(tester);
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.tap(find.text('Export JSON'));
      await tester.pumpAndSettle();
      expect(exports, 0);
      expect(find.textContaining('profile.name'), findsOneWidget);
    },
  );
  testWidgets('the editor fits a narrow viewport', (tester) async {
    await openEditor(tester, size: const Size(390, 844));
    await unlock(tester);
    expect(tester.takeException(), isNull);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Projects'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('import replaces the draft only after explicit confirmation', (
    tester,
  ) async {
    String? exported;
    await openEditor(tester, onExport: (value) => exported = value);
    await unlock(tester);
    final imported = Data.content.toJson();
    imported['profile']['name'] = 'Imported profile';
    await tester.tap(find.text('Import JSON'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      ),
      jsonEncode(imported),
    );
    await tester.tap(find.text('Import', skipOffstage: false));
    await tester.pumpAndSettle();
    expect(find.text('Replace this draft?'), findsOneWidget);
    await tester.tap(find.text('Replace draft'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Export JSON'));
    await tester.pumpAndSettle();
    expect(jsonDecode(exported!)['profile']['name'], 'Imported profile');
  });

  testWidgets('reordering projects exports their new order', (tester) async {
    String? exported;
    await openEditor(tester, onExport: (value) => exported = value);
    await unlock(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Projects'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Move project down').first);
    await tester.tap(find.byTooltip('Move project down').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Export JSON'));
    await tester.tap(find.text('Export JSON'));
    await tester.pumpAndSettle();
    final projects = jsonDecode(exported!)['projects']['items'];
    expect(projects[0]['title'], 'Delivery App');
    expect(
      projects[1]['title'],
      'Project Management App for Construction Firm',
    );
  });
  testWidgets(
    'publish submits the validated draft and forgets the token on lock',
    (tester) async {
      var publishes = 0;
      await openEditor(
        tester,
        onPublish: (token, content) async {
          expect(token, 'test-only-token');
          expect(content.field('profile', 'name'), 'Published profile');
          publishes++;
          return const GitHubPublishResult(
            commitUrl:
                'https://github.com/Rejomeee/arone-portfolio/commit/test',
          );
        },
      );
      await unlock(tester);
      await tester.enterText(
        find.byType(TextFormField).first,
        'Published profile',
      );
      await tester.tap(find.text('Publish'));
      await tester.pumpAndSettle();
      expect(find.text('Publish to GitHub'), findsOneWidget);
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        'test-only-token',
      );
      await tester.pump();
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Publish'),
        ),
      );
      await tester.pumpAndSettle();
      expect(publishes, 1);
      expect(Data.name, 'Published profile');
      expect(find.textContaining('Published to GitHub.'), findsOneWidget);
      expect(find.text('Disconnect GitHub'), findsOneWidget);
      await tester.tap(find.text('Lock'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
      await unlock(tester);
      expect(find.text('Disconnect GitHub'), findsNothing);
    },
  );

  testWidgets(
    'failed publishing preserves the draft and displays the service error',
    (tester) async {
      await openEditor(
        tester,
        onPublish: (_, _) async =>
            throw const GitHubPublishException('GitHub denied access.'),
      );
      await unlock(tester);
      await tester.enterText(
        find.byType(TextFormField).first,
        'Unsaved profile',
      );
      await tester.tap(find.text('Publish'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        'test-only-token',
      );
      await tester.pump();
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Publish'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('GitHub denied access.'), findsOneWidget);
      expect(find.text('Unsaved profile'), findsOneWidget);
      expect(Data.name, isNot('Unsaved profile'));
    },
  );
}
