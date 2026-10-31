import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/portfolio_content.dart';

class ContentRepository {
  ContentRepository({http.Client? client, this.url = publicContentUrl})
    : _client = client ?? http.Client();
  static const publicContentUrl = String.fromEnvironment(
    'PORTFOLIO_CONTENT_URL',
    defaultValue:
        'https://raw.githubusercontent.com/Rejomeee/arone-portfolio/master/content/portfolio.json',
  );
  final String url;
  final http.Client _client;
  Future<PortfolioContent> loadPublished() async {
    final uri = Uri.parse(url);
    if (!['https', 'http'].contains(uri.scheme) || uri.host.isEmpty) {
      throw const FormatException('Invalid content URL.');
    }
    final response = await _client
        .get(
          uri.replace(
            queryParameters: {
              ...uri.queryParameters,
              'v': DateTime.now().millisecondsSinceEpoch.toString(),
            },
          ),
        )
        .timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      throw StateError('The published JSON is not available yet.');
    }
    if (response.bodyBytes.length > 200000) {
      throw const FormatException('Content exceeds 200 KB.');
    }
    return PortfolioContent.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)),
    );
  }

  void close() => _client.close();
}

Future<PortfolioContent> loadPublishedPortfolio() async {
  final repository = ContentRepository();
  try {
    return await repository.loadPublished();
  } finally {
    repository.close();
  }
}
