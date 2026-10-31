import 'package:flutter/widgets.dart';

class PortfolioPreviewScope extends InheritedWidget {
  const PortfolioPreviewScope({super.key, required super.child});
  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PortfolioPreviewScope>() !=
      null;
  @override
  bool updateShouldNotify(PortfolioPreviewScope oldWidget) => false;
}
