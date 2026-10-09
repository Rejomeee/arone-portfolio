import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/screens/sections/about_me_section.dart';
import 'package:flutter_my_portfolio/screens/sections/project_section.dart';

void main() {
  test('portfolio content is populated', () {
    expect(Data.name, isNotEmpty);
    expect(Data.experiences, isNotEmpty);
    expect(Data.projects, isNotEmpty);
    expect(Data.socialLinks, isNotEmpty);
  });

  testWidgets('about section shows the intro and education', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: AboutMeSection()),
        ),
      ),
    );

    expect(find.text('About me'), findsOneWidget);
    expect(find.text(Data.educationTitle), findsOneWidget);
    expect(find.textContaining('software engineer'), findsOneWidget);
  });

  testWidgets('projects section lists each project', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: ProjectSection()),
        ),
      ),
    );

    expect(find.text('Delivery App'), findsOneWidget);
    expect(find.text('Social Media App'), findsOneWidget);
    expect(
      find.text('Project Management App for Construction Firm'),
      findsOneWidget,
    );
  });
}
