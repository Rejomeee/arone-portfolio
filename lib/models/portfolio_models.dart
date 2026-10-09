import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailRow {
  const DetailRow({required this.label, required this.value});

  final String label;
  final String value;
}

class PortfolioRole {
  const PortfolioRole({required this.details, required this.tools});

  final List<DetailRow> details;
  final List<String> tools;

  DetailRow get headline => details.first;
}

class PortfolioExperience {
  const PortfolioExperience({required this.company, required this.roles});

  final String company;
  final List<PortfolioRole> roles;
}

class PortfolioProject {
  const PortfolioProject({
    required this.title,
    required this.summary,
    required this.features,
    required this.tools,
  });

  final String title;
  final String summary;
  final List<String> features;
  final List<String> tools;
}

class SocialLink {
  const SocialLink({
    required this.label,
    required this.url,
    required this.icon,
  });

  final String label;
  final String url;
  final FaIconData icon;
}
