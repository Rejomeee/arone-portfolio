import 'package:flutter/material.dart';

import '../constant/data.dart';
import '../utils/open_link.dart';
import '../components/soc_icon.dart';

class SocialLinks extends StatelessWidget {
  const SocialLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final link in Data.socialLinks)
          SocIcon(
            tooltip: link.label,
            icon: link.icon,
            onTap: () => openLink(link.url),
          ),
      ],
    );
  }
}
