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
  test(
    'create followed by repeated updates bypasses cached metadata with the same token',
    () async {
      final cache = <String, http.Response>{};
      final metadataUrls = <String>[];
      var version = 0;
      final publisher = GitHubPublisher(
        client: MockClient((request) async {
          expect(request.headers['Authorization'], 'Bearer test-only-token');
          if (request.method == 'GET') {
            metadataUrls.add(request.url.toString());
            // Model a browser/proxy retaining every response, including a 404.
            return cache.putIfAbsent(
              request.url.toString(),
              () => version == 0
                  ? http.Response('{"message":"Not Found"}', 404)
                  : http.Response(
                      jsonEncode({'type': 'file', 'sha': 'blob-$version'}),
                      200,
                    ),
            );
          }
          final body = jsonDecode(request.body);
          expect(body['sha'], version == 0 ? isNull : 'blob-$version');
          version++;
          return http.Response(
            jsonEncode({
              'commit': {'sha': 'commit-$version'},
            }),
            version == 1 ? 201 : 200,
          );
        }),
      );
      for (var i = 0; i < 3; i++) {
        await publisher.publish('test-only-token', Data.content);
      }
      expect(version, 3);
      expect(metadataUrls.toSet(), hasLength(3));
      publisher.close();
    },
  );

  test('missing-SHA validation is distinguished from branch rules', () async {
    for (final entry in {
      '{"message":"Invalid request. sha wasn’t supplied."}': 'file version',
      '{"message":"Changes must be made through a pull request."}':
          'branch rules',
      '{"message":"Validation Failed"}': 'validate this update',
    }.entries) {
      final publisher = GitHubPublisher(
        client: MockClient((request) async {
          if (request.method == 'GET') {
            return http.Response('{"type":"file","sha":"current"}', 200);
          }
          return http.Response.bytes(utf8.encode(entry.key), 422);
        }),
      );
      await expectLater(
        publisher.publish('test-only-token', Data.content),
        throwsA(
          isA<GitHubPublishException>()
              .having(
                (error) => error.message,
                'specific rejection',
                contains(entry.value),
              )
              .having((error) => error.message, 'status code', contains('422')),
        ),
      );
      publisher.close();
    }
  });
}
