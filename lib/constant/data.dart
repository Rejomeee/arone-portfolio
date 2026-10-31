import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/portfolio_content.dart';
import '../models/portfolio_models.dart';

class Data {
  static const avatar = 'assets/images/ako.jpg';
  static final changes = ValueNotifier<PortfolioContent?>(null);
  static PortfolioContent get content =>
      changes.value ??
      (throw StateError('Load portfolio content before starting the app.'));
  static Future<void> initialize() async {
    apply(
      PortfolioContent.fromJson(
        jsonDecode(await rootBundle.loadString('content/portfolio.json')),
      ),
    );
  }

  static void apply(PortfolioContent value) => changes.value = value;
  static String _profile(String key) => content.field('profile', key);
  static String get webTitle => _profile('webTitle');
  static String get name => _profile('name');
  static String get shortName => _profile('shortName');
  static String get role => _profile('role');
  static String get phoneNumber => _profile('phoneNumber');
  static String get email => _profile('email');
  static String get location => _profile('location');
  static String get birthday => _profile('birthday');
  static String get cvUrl => _profile('cvUrl');
  static String get githubUrl => _profile('githubUrl');
  static String get linkedInUrl => _profile('linkedInUrl');
  static String get instagramUrl => _profile('instagramUrl');
  static String get facebookUrl => _profile('facebookUrl');
  static String get heroEyebrow => content.field('hero', 'eyebrow');
  static String get heroHeadline => content.field('hero', 'headline');
  static String get heroDescription => content.field('hero', 'description');
  static List<String> get specialties =>
      List<String>.from(content.section('hero')['specialties']);
  static List<String> get aboutMe =>
      List<String>.from(content.section('about')['paragraphs']);
  static String get educationTitle => content.field('about', 'educationTitle');
  static String get educationDetail =>
      content.field('about', 'educationDetail');
  static Map<String, String> get aboutFacts => {
    'Name': name,
    'Location': location,
    if (birthday.isNotEmpty) 'Birthday': birthday,
    'Email': email,
  };
  static String get projectsIntro => content.field('projects', 'intro');
  static String get contactHeading => content.field('contact', 'heading');
  static String get contactDescription =>
      content.field('contact', 'description');
  static String get footer => content.footer;
  static List<PortfolioProject> get projects => [
    for (final item in content.section('projects')['items'])
      PortfolioProject(
        title: item['title'],
        overview: item['overview'],
        summary: item['summary'],
        coverLabel: item['coverLabel'],
        coverHeadline: item['coverHeadline'],
        features: List<String>.from(item['features']),
        tools: List<String>.from(item['tools']),
      ),
  ];
  static List<PortfolioExperience> get experiences => [
    for (final company in content.experiences)
      PortfolioExperience(
        company: company['company'],
        roles: [
          for (final role in company['roles'])
            PortfolioRole(
              details: [
                DetailRow(label: role['period'], value: role['title']),
                DetailRow(label: 'Description', value: role['description']),
              ],
              tools: List<String>.from(role['tools']),
            ),
        ],
      ),
  ];
  static List<SocialLink> get socialLinks => [
    if (githubUrl.isNotEmpty)
      SocialLink(
        label: 'GitHub',
        url: githubUrl,
        icon: FontAwesomeIcons.github,
      ),
    if (linkedInUrl.isNotEmpty)
      SocialLink(
        label: 'LinkedIn',
        url: linkedInUrl,
        icon: FontAwesomeIcons.linkedinIn,
      ),
    if (instagramUrl.isNotEmpty)
      SocialLink(
        label: 'Instagram',
        url: instagramUrl,
        icon: FontAwesomeIcons.instagram,
      ),
    if (facebookUrl.isNotEmpty)
      SocialLink(
        label: 'Facebook',
        url: facebookUrl,
        icon: FontAwesomeIcons.facebookF,
      ),
  ];
}
