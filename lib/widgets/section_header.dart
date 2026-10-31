import 'package:flutter/material.dart';
import '../constant/style.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) =>
      Semantics(header: true, child: Text(title, style: kHeadline3));
}
