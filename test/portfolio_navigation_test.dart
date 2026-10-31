import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_my_portfolio/main.dart';
import 'package:flutter_my_portfolio/components/navigation_tab.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(Data.initialize);
  Future<void> openPortfolio(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: PortfolioPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('desktop navigation reaches distant sections and returns home', (
    tester,
  ) async {
    await openPortfolio(tester, const Size(1440, 900));
    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    final heading = find.text('Have a project in mind?');
    expect(tester.getTopLeft(heading).dy, inInclusiveRange(0, 900));
    expect(
      tester
          .widget<NavigationTab>(find.widgetWithText(NavigationTab, 'Contact'))
          .selected,
      isTrue,
    );
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(
      tester
          .getTopLeft(find.text('I build mobile experiences with Flutter.'))
          .dy,
      inInclusiveRange(0, 900),
    );
    await tester.tap(find.text('View projects'));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('Selected projects')).dy,
      inInclusiveRange(0, 900),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile header stays accessible and drawer reaches projects', (
    tester,
  ) async {
    await openPortfolio(tester, const Size(390, 844));
    await tester.tap(find.text('View projects'));
    await tester.pumpAndSettle();
    expect(
      find.byTooltip('Open navigation menu').hitTestable(),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contact'));
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('Have a project in mind?')).dy,
      inInclusiveRange(0, 844),
    );
    expect(find.text('Let’s talk').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow viewport and short desktop have no layout overflows', (
    tester,
  ) async {
    await openPortfolio(tester, const Size(320, 640));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Let’s talk'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.view.physicalSize = const Size(1280, 500);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.text('Have a project in mind?')).dy,
      inInclusiveRange(0, 500),
    );
    expect(
      tester
          .widget<NavigationTab>(find.widgetWithText(NavigationTab, 'Contact'))
          .selected,
      isTrue,
    );
  });
  testWidgets('an initial section opens directly after startup', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: PortfolioPage(initialSection: 'contact'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('Have a project in mind?')).dy,
      inInclusiveRange(0, 900),
    );
    expect(
      tester
          .widget<NavigationTab>(find.widgetWithText(NavigationTab, 'Contact'))
          .selected,
      isTrue,
    );
  });

  testWidgets('the page remains usable with enlarged text', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            disableAnimations: true,
            textScaler: TextScaler.linear(2),
          ),
          child: const PortfolioPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Let’s talk'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      find.byTooltip('Open navigation menu').hitTestable(),
      findsOneWidget,
    );
  });
}
