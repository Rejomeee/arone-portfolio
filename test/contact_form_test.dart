import 'package:flutter_my_portfolio/constant/data.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_my_portfolio/screens/sections/get_in_touch.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(Data.initialize);
  Future<void> openForm(WidgetTester tester, EmailSender sender) async {
    tester.view.physicalSize = const Size(900, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GetInTouchSection(emailSender: sender),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fillForm(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), 'Alex');
    await tester.enterText(find.byType(TextField).at(1), 'alex@example.com');
    await tester.enterText(
      find.byType(TextField).at(3),
      'Let’s build a mobile app.',
    );
    await tester.pump();
  }

  testWidgets(
    'optional subject allows sending, duplicate sends are blocked, success clears fields',
    (tester) async {
      var requests = 0;
      final response = Completer<http.Response>();
      await openForm(tester, (name, email, message, subject) {
        requests++;
        expect(subject, isEmpty);
        return response.future;
      });
      await fillForm(tester);
      await tester.tap(find.text('Send message'));
      await tester.pump();
      expect(find.text('Sending…'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(requests, 1);
      response.complete(http.Response('OK', 200));
      await tester.pumpAndSettle();
      expect(
        find.text('Thanks for reaching out. Your message has been sent.'),
        findsOneWidget,
      );
      expect(find.text('Let’s build a mobile app.'), findsNothing);
    },
  );

  testWidgets('timeout preserves the draft and allows retry', (tester) async {
    var requests = 0;
    await openForm(tester, (name, email, message, subject) async {
      requests++;
      if (requests == 1) throw TimeoutException('Timed out');
      return http.Response('OK', 200);
    });
    await fillForm(tester);
    await tester.tap(find.text('Send message'));
    await tester.pumpAndSettle();
    expect(find.textContaining('The request timed out.'), findsOneWidget);
    expect(find.text('Let’s build a mobile app.'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(requests, 2);
    expect(
      find.text('Thanks for reaching out. Your message has been sent.'),
      findsOneWidget,
    );
  });

  testWidgets('whitespace-only fields do not send a message', (tester) async {
    var requests = 0;
    await openForm(tester, (name, email, message, subject) async {
      requests++;
      return http.Response('OK', 200);
    });
    await fillForm(tester);
    await tester.enterText(find.byType(TextField).at(0), '   ');
    await tester.enterText(find.byType(TextField).at(3), '  \n  ');
    await tester.tap(find.text('Send message'));
    await tester.pumpAndSettle();
    expect(requests, 0);
    expect(find.text('This field is required'), findsNWidgets(2));
  });
}
