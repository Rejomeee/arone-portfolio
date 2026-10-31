import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/models/portfolio_content.dart';
import 'package:flutter_my_portfolio/services/content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(Data.initialize);
  test('the bundled document round trips without losing content', () async {
    final source = jsonDecode(
      await rootBundle.loadString('content/portfolio.json'),
    );
    expect(jsonDecode(Data.content.encode()), source);
    final copy = Data.content.toJson();
    copy['profile']['name'] = 'Draft name';
    expect(Data.name, isNot('Draft name'));
  });
  test('unsafe resume links and malformed roles are rejected', () {
    final badLink = Data.content.toJson();
    badLink['profile']['cvUrl'] = 'javascript:alert(1)';
    expect(() => PortfolioContent.fromJson(badLink), throwsFormatException);
    final badRoles = Data.content.toJson();
    badRoles['experiences'][0]['roles'] = [];
    expect(() => PortfolioContent.fromJson(badRoles), throwsFormatException);
  });
  test('unfinished fields can be saved as drafts but cannot be exported', () {
    final draft = Data.content.toJson();
    draft['hero']['headline'] = '';
    expect(
      () => PortfolioContent.fromJson(draft, validate: false),
      returnsNormally,
    );
    expect(() => PortfolioContent.fromJson(draft), throwsFormatException);
  });
  test(
    'published JSON replaces bundled content and bypasses a stale request URL',
    () async {
      final edited = Data.content.toJson();
      edited['hero']['headline'] = 'Updated on GitHub';
      final repository = ContentRepository(
        client: MockClient((request) async {
          expect(request.url.queryParameters['v'], isNotEmpty);
          return http.Response(
            jsonEncode(edited),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
      final published = await repository.loadPublished();
      Data.apply(published);
      expect(Data.heroHeadline, 'Updated on GitHub');
      repository.close();
    },
  );
  test(
    'unavailable or corrupt published content never mutates current content',
    () async {
      final original = Data.content.encode();
      for (final response in [
        http.Response('not found', 404),
        http.Response('{broken}', 200),
        http.Response('{"schemaVersion":2}', 200),
      ]) {
        final repository = ContentRepository(
          client: MockClient((_) async => response),
        );
        await expectLater(repository.loadPublished(), throwsA(anything));
        expect(Data.content.encode(), original);
        repository.close();
      }
    },
  );
}
