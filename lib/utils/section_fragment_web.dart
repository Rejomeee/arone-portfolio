import 'dart:js_interop';

@JS('window.location.hash')
external JSString get _hash;
@JS('window.history.replaceState')
external void _replaceState(JSAny? data, JSString title, JSString url);
@JS('window.addEventListener')
external void _addEventListener(JSString type, JSFunction listener);
@JS('window.removeEventListener')
external void _removeEventListener(JSString type, JSFunction listener);

String readSectionFragment() => _hash.toDart.replaceFirst(RegExp(r'^#/?'), '');
void writeSectionFragment(String section) =>
    _replaceState(null, ''.toJS, '#$section'.toJS);
void Function() listenToSectionFragment(void Function() onChanged) {
  final listener = ((JSAny? event) => onChanged()).toJS;
  _addEventListener('hashchange'.toJS, listener);
  return () => _removeEventListener('hashchange'.toJS, listener);
}
