import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_my_portfolio/constant/data.dart';
import 'package:flutter_my_portfolio/services/github_publisher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(Data.initialize);
  test(
    'updates only the JSON file using its current SHA and UTF-8 base64',
    () async {
      var writes = 0;
      final publisher = GitHubPublisher(
        client: MockClient((request) async {
          expect(request.url.host, 'api.github.com');
          expect(
            request.url.path,
            '/repos/Rejomeee/arone-portfolio/contents/content/portfolio.json',
          );
          expect(request.headers['Authorization'], 'Bearer test-only-token');
          if (request.method == 'GET') {
            expect(request.url.queryParameters['ref'], 'master');
            return http.Response(
              '{"type":"file","sha":"current-blob-sha"}',
              200,
            );
          }
          expect(request.method, 'PUT');
          writes++;
          final body = jsonDecode(request.body);
          expect(body['branch'], 'master');
          expect(body['sha'], 'current-blob-sha');
          expect(
            jsonDecode(utf8.decode(base64Decode(body['content']))),
            Data.content.toJson(),
          );
          expect(request.body.contains('test-only-token'), isFalse);
          return http.Response('{"commit":{"sha":"new-commit-sha"}}', 200);
        }),
      );
      final result = await publisher.publish(' test-only-token ', Data.content);
      expect(writes, 1);
      expect(result.commitUrl, endsWith('/commit/new-commit-sha'));
      publisher.close();
    },
  );
  test('creates the file when it does not exist yet', () async {
    final publisher = GitHubPublisher(
      client: MockClient((request) async {
        if (request.method == 'GET') return http.Response('{}', 404);
        expect(jsonDecode(request.body).containsKey('sha'), isFalse);
        return http.Response('{"commit":{"sha":"created"}}', 201);
      }),
    );
    await publisher.publish('test-only-token', Data.content);
    publisher.close();
  });
  test('rejected credentials never reach a write request', () async {
    var calls = 0;
    final publisher = GitHubPublisher(
      client: MockClient((request) async {
        calls++;
        return http.Response('{}', 401);
      }),
    );
    await expectLater(
      publisher.publish('test-only-token', Data.content),
      throwsA(
        isA<GitHubPublishException>().having(
          (e) => e.forgetToken,
          'forget token',
          isTrue,
        ),
      ),
    );
    expect(calls, 1);
    publisher.close();
  });
  test('conflicts are reported without an automatic overwrite retry', () async {
    var writes = 0;
    final publisher = GitHubPublisher(
      client: MockClient((request) async {
        if (request.method == 'GET') {
          return http.Response('{"type":"file","sha":"old"}', 200);
        }
        writes++;
        return http.Response('{}', 409);
      }),
    );
    await expectLater(
      publisher.publish('test-only-token', Data.content),
      throwsA(isA<GitHubPublishException>()),
    );
    expect(writes, 1);
    publisher.close();
  });
  test('blank tokens and malformed metadata cannot publish', () async {
    var calls = 0;
    final publisher = GitHubPublisher(
      client: MockClient((request) async {
        calls++;
        return http.Response('{"type":"dir"}', 200);
      }),
    );
    await expectLater(
      publisher.publish('', Data.content),
      throwsA(isA<GitHubPublishException>()),
    );
    expect(calls, 0);
    await expectLater(
      publisher.publish('test-only-token', Data.content),
      throwsA(isA<GitHubPublishException>()),
    );
    expect(calls, 1);
    publisher.close();
  });
}
