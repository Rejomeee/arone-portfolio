import 'dart:convert';

/// The versioned, portable document shared by the site and the local editor.
class PortfolioContent {
  PortfolioContent._(this._json);
  final Map<String, dynamic> _json;

  factory PortfolioContent.fromJson(Object? value, {bool validate = true}) {
    if (value is! Map<String, dynamic> || value['schemaVersion'] != 1) {
      throw const FormatException(
        'Use a portfolio JSON file with schemaVersion 1.',
      );
    }
    Never invalid(String path) => throw FormatException('Check $path.');
    Map<String, dynamic> object(Object? item, String path) {
      if (item is! Map<String, dynamic>) invalid(path);
      return item;
    }

    String text(
      Map<String, dynamic> map,
      String key,
      String path, {
      bool optional = false,
    }) {
      final item = map[key];
      if (item is! String ||
          item.length > 6000 ||
          (validate && !optional && item.trim().isEmpty)) {
        invalid('$path.$key');
      }
      return item;
    }

    List<dynamic> list(
      Object? item,
      String path, {
      int max = 40,
      bool required = false,
    }) {
      if (item is! List ||
          item.length > max ||
          (validate && required && item.isEmpty)) {
        invalid(path);
      }
      return item;
    }

    void strings(
      Object? item,
      String path, {
      int max = 40,
      bool required = false,
    }) {
      for (final entry in list(item, path, max: max, required: required)) {
        if (entry is! String ||
            entry.length > 6000 ||
            (validate && entry.trim().isEmpty)) {
          invalid(path);
        }
      }
    }

    final profile = object(value['profile'], 'profile');
    for (final key in [
      'webTitle',
      'name',
      'shortName',
      'role',
      'email',
      'location',
      'birthday',
      'phoneNumber',
      'cvUrl',
      'githubUrl',
      'linkedInUrl',
      'instagramUrl',
      'facebookUrl',
    ]) {
      final optional = [
        'birthday',
        'phoneNumber',
        'githubUrl',
        'linkedInUrl',
        'instagramUrl',
        'facebookUrl',
      ].contains(key);
      final item = text(profile, key, 'profile', optional: optional);
      if (validate && key.endsWith('Url') && item.isNotEmpty) {
        final uri = Uri.tryParse(item);
        if (uri == null ||
            !['https', 'http'].contains(uri.scheme) ||
            uri.host.isEmpty) {
          invalid('profile.$key (use an https:// URL)');
        }
      }
    }
    if (validate &&
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(profile['email'])) {
      invalid('profile.email');
    }
    final hero = object(value['hero'], 'hero');
    for (final key in ['eyebrow', 'headline', 'description']) {
      text(hero, key, 'hero');
    }
    strings(hero['specialties'], 'hero.specialties', max: 8);
    final about = object(value['about'], 'about');
    strings(about['paragraphs'], 'about.paragraphs', max: 20, required: true);
    text(about, 'educationTitle', 'about');
    text(about, 'educationDetail', 'about');
    final projects = object(value['projects'], 'projects');
    text(projects, 'intro', 'projects');
    for (final entry in list(projects['items'], 'projects.items', max: 20)) {
      final item = object(entry, 'project');
      for (final key in [
        'title',
        'overview',
        'summary',
        'coverLabel',
        'coverHeadline',
      ]) {
        text(item, key, 'project');
      }
      strings(item['features'], 'project.features');
      strings(item['tools'], 'project.tools');
    }
    for (final entry in list(value['experiences'], 'experiences', max: 20)) {
      final company = object(entry, 'experience');
      text(company, 'company', 'experience');
      for (final role in list(
        company['roles'],
        'experience.roles',
        max: 20,
        required: true,
      )) {
        final item = object(role, 'role');
        for (final key in ['title', 'period', 'description']) {
          text(item, key, 'role');
        }
        strings(item['tools'], 'role.tools');
      }
    }
    final contact = object(value['contact'], 'contact');
    text(contact, 'heading', 'contact');
    text(contact, 'description', 'contact');
    text(value, 'footer', 'portfolio');
    if (utf8.encode(jsonEncode(value)).length > 200000) {
      invalid('file size (maximum 200 KB)');
    }
    // A private deep copy prevents editor changes mutating the published view.
    return PortfolioContent._(
      jsonDecode(jsonEncode(value)) as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() =>
      jsonDecode(jsonEncode(_json)) as Map<String, dynamic>;
  String encode() => '${const JsonEncoder.withIndent('  ').convert(_json)}\n';
  Map<String, dynamic> section(String name) =>
      _json[name] as Map<String, dynamic>;
  String field(String sectionName, String name) =>
      section(sectionName)[name] as String;
  String get footer => _json['footer'] as String;
  List<dynamic> get experiences => _json['experiences'] as List<dynamic>;
}
