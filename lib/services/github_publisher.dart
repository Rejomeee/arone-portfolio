import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/portfolio_content.dart';

class GitHubPublishException implements Exception {
  const GitHubPublishException(this.message, {this.forgetToken = false});
  final String message;
  final bool forgetToken;
  @override
  String toString() => message;
}

class GitHubPublishResult {
  const GitHubPublishResult({required this.commitUrl});
  final String commitUrl;
}

class GitHubPublisher {
  GitHubPublisher({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  static int _metadataRequest = 0;
  static const repository = 'Rejomeee/arone-portfolio';
  static const branch = 'master';
  static const contentPath = 'content/portfolio.json';

  Future<GitHubPublishResult> publish(
    String token,
    PortfolioContent content,
  ) async {
    if (token.trim().isEmpty) {
      throw const GitHubPublishException(
        'Enter a GitHub token to publish.',
        forgetToken: true,
      );
    }
    // Validate even when called outside the editor. Credentials are sent only
    // to GitHub's fixed API origin and are never included in the file/commit.
    final encoded = PortfolioContent.fromJson(content.toJson()).encode();
    final uri = Uri.https(
      'api.github.com',
      '/repos/$repository/contents/$contentPath',
    );
    final headers = {
      'Accept': 'application/vnd.github+json',
      'Authorization': 'Bearer ${token.trim()}',
      'X-GitHub-Api-Version': '2022-11-28',
    };
    final current = await _client
        .get(
          // A cached 404 after creation, or an old SHA after an update, makes
          // the next PUT fail. Use a new URL for every metadata lookup. Do not
          // add Cache-Control headers: GitHub's browser CORS policy excludes them.
          uri.replace(
            queryParameters: {
              'ref': branch,
              'v':
                  '${DateTime.now().microsecondsSinceEpoch}-${_metadataRequest++}',
            },
          ),
          headers: headers,
        )
        .timeout(const Duration(seconds: 15));
    String? sha;
    if (current.statusCode == 200) {
      final metadata = _object(current);
      if (metadata['type'] != 'file' ||
          metadata['sha'] is! String ||
          (metadata['sha'] as String).isEmpty) {
        throw const GitHubPublishException(
          'GitHub returned an unexpected file response. Nothing was published.',
        );
      }
      sha = metadata['sha'] as String;
    } else if (current.statusCode != 404) {
      _reject(current);
    }
    final response = await _client
        .put(
          uri,
          headers: {...headers, 'Content-Type': 'application/json'},
          body: jsonEncode({
            'message': 'Update portfolio content from Ekko',
            'branch': branch,
            'content': base64Encode(utf8.encode(encoded)),
            'sha': ?sha,
          }),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200 && response.statusCode != 201) {
      _reject(response);
    }
    final result = _object(response);
    final commit = result['commit'];
    if (commit is! Map ||
        commit['sha'] is! String ||
        (commit['sha'] as String).isEmpty) {
      throw const GitHubPublishException(
        'GitHub accepted the request, but the commit could not be confirmed. Check the repository before publishing again.',
      );
    }
    return GitHubPublishResult(
      commitUrl:
          'https://github.com/$repository/commit/${Uri.encodeComponent(commit['sha'] as String)}',
    );
  }

  Map<String, dynamic> _object(http.Response response) {
    try {
      final value = jsonDecode(utf8.decode(response.bodyBytes));
      if (value is Map<String, dynamic>) return value;
    } catch (_) {
      /* Never display response bodies or credentials in errors. */
    }
    throw const GitHubPublishException(
      'GitHub returned an unreadable response. Check the repository before publishing again.',
    );
  }

  Never _reject(http.Response response) {
    final status = response.statusCode;
    var detail = '';
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is Map) {
        detail = '${body['message'] ?? ''} ${jsonEncode(body['errors'] ?? [])}'
            .toLowerCase();
      }
    } catch (_) {
      // Classify known errors without displaying arbitrary response bodies.
    }
    if ([403, 409, 422].contains(status) &&
        [
          'protected branch',
          'repository rule',
          'push declined',
          'through a pull request',
        ].any(detail.contains)) {
      throw GitHubPublishException(
        'GitHub branch rules blocked direct publishing (HTTP $status). Your draft is still here; use a pull request for this repository.',
      );
    }
    switch (status) {
      case 401:
        throw const GitHubPublishException(
          'GitHub did not accept that token. Publish again with a valid token.',
          forgetToken: true,
        );
      case 403:
        if (response.headers['x-ratelimit-remaining'] == '0' ||
            detail.contains('rate limit')) {
          throw const GitHubPublishException(
            'GitHub’s rate limit was reached (HTTP 403). Wait before retrying. Your draft is still here.',
          );
        }
        throw const GitHubPublishException(
          'GitHub denied access (HTTP 403). Check this token’s repository access and Contents read/write permission.',
        );
      case 404:
        throw const GitHubPublishException(
          'The repository or master branch is not accessible with this token (HTTP 404).',
        );
      case 409:
        throw const GitHubPublishException(
          'GitHub reported a file-version conflict (HTTP 409). Your draft is still here. Publish again to read the latest version; no overwrite was retried automatically.',
        );
      case 422:
        if (detail.contains('sha')) {
          throw const GitHubPublishException(
            'GitHub rejected the file version (HTTP 422). Your draft is still here. Try Publish again to read the latest version.',
          );
        }
        throw const GitHubPublishException(
          'GitHub could not validate this update (HTTP 422). Your draft is still here. Check the repository’s publishing requirements.',
        );
      default:
        throw GitHubPublishException(
          'Publishing could not be confirmed (HTTP $status). Check GitHub before retrying. Your draft is still here.',
        );
    }
  }

  void close() => _client.close();
}

Future<GitHubPublishResult> publishPortfolioToGitHub(
  String token,
  PortfolioContent content,
) async {
  final publisher = GitHubPublisher();
  try {
    return await publisher.publish(token, content);
  } finally {
    publisher.close();
  }
}
