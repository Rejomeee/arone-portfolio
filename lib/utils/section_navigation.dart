import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'section_fragment.dart';

class SectionNavigation extends ChangeNotifier {
  static const slugs = ['home', 'about', 'projects', 'experience', 'contact'];
  final controller = ScrollController();
  final keys = List<GlobalKey>.generate(slugs.length, (_) => GlobalKey());
  final bool syncFragment;
  int selected = 0;
  String? _initialSection;
  bool _navigating = false;
  bool _disposed = false;
  bool _lastShowBackToTop = false;
  int _navigationRequest = 0;
  late final void Function() _removeFragmentListener;

  SectionNavigation({String? initialSection, this.syncFragment = true})
    : _initialSection = initialSection {
    controller.addListener(_trackSection);
    _removeFragmentListener = syncFragment
        ? listenToSectionFragment(openInitialSection)
        : () {};
  }

  bool get showBackToTop => controller.hasClients && controller.offset >= 400;

  void openInitialSection() {
    final index = slugs.indexOf(
      (_initialSection ?? readSectionFragment()).replaceFirst(
        RegExp(r'^interests$'),
        'about',
      ),
    );
    _initialSection = null;
    if (index >= 0) scrollTo(index, reduceMotion: true);
  }

  double? _offsetFor(int index) {
    final object = keys[index].currentContext?.findRenderObject();
    if (object == null || !object.attached) return null;
    return RenderAbstractViewport.of(
      object,
    ).getOffsetToReveal(object, 0).offset;
  }

  void _trackSection() {
    if (!controller.hasClients) return;
    var changed = showBackToTop != _lastShowBackToTop;
    _lastShowBackToTop = showBackToTop;
    if (!_navigating) {
      var index = 0;
      for (var i = 0; i < keys.length; i++) {
        final offset = _offsetFor(i);
        if (offset != null && controller.offset + 80 >= offset) index = i;
      }
      if (controller.position.maxScrollExtent > 0 &&
          controller.position.extentAfter < 2) {
        index = keys.length - 1;
      }
      if (index != selected) {
        changed = true;
        selected = index;
        if (syncFragment) writeSectionFragment(slugs[index]);
      }
    }
    if (changed) notifyListeners();
  }

  Future<void> scrollTo(int index, {bool reduceMotion = false}) async {
    final offset = index == 0 ? 0.0 : _offsetFor(index);
    if (offset == null || !controller.hasClients) return;
    final request = ++_navigationRequest;
    selected = index;
    if (syncFragment) writeSectionFragment(slugs[index]);
    _navigating = true;
    notifyListeners();
    final target = offset.clamp(0.0, controller.position.maxScrollExtent);
    if (reduceMotion) {
      controller.jumpTo(target);
    } else {
      await controller.animateTo(
        target,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
    }
    if (_disposed || request != _navigationRequest) return;
    _navigating = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _removeFragmentListener();
    controller.dispose();
    super.dispose();
  }
}
