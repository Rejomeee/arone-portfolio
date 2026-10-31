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
        .get(uri.replace(queryParameters: {'ref': branch}), headers: headers)
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
      _reject(current.statusCode);
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
      _reject(response.statusCode);
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

  Never _reject(int status) {
    switch (status) {
      case 401:
        throw const GitHubPublishException(
          'GitHub did not accept that token. Publish again with a valid token.',
          forgetToken: true,
        );
      case 403:
        throw const GitHubPublishException(
          'GitHub denied access. Check Contents read/write permission and branch rules. If rate limited, try again later.',
        );
      case 404:
        throw const GitHubPublishException(
          'The repository or master branch is not accessible with this token.',
        );
      case 409:
      case 422:
        throw const GitHubPublishException(
          'GitHub rejected the update. The file may have changed during publishing, or a branch rule may block it. Your draft is still here.',
        );
      default:
        throw const GitHubPublishException(
          'Publishing could not be confirmed. Check GitHub before retrying. Your draft is still here.',
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
