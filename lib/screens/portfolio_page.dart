import 'package:flutter/material.dart';
import '../constant/style.dart';
import '../utils/section_navigation.dart';
import 'mobile_view.dart';
import 'web_view.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({
    super.key,
    this.initialSection = '',
    this.syncFragment = true,
  });
  final String initialSection;
  final bool syncFragment;
  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  bool? _wideLayout;
  late final _navigation = SectionNavigation(
    initialSection: widget.initialSection,
    syncFragment: widget.syncFragment,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _navigation.openInitialSection();
    });
  }

  @override
  void dispose() {
    _navigation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _navigation,
    builder: (context, _) => LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= kWideLayoutWidth;
        if (_wideLayout != null && _wideLayout != wide) {
          final section = _navigation.selected;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _navigation.scrollTo(section, reduceMotion: true);
          });
        }
        _wideLayout = wide;
        if (wide) {
          return WebView(constraints: constraints, navigation: _navigation);
        }
        return MobileView(constraints: constraints, navigation: _navigation);
      },
    ),
  );
}
