import 'dart:async';
import 'dart:js_interop';

const _draftKey = 'ekko.portfolio.draft.v1';
@JS('window.localStorage.getItem')
external JSString? _getItem(JSString key);
@JS('window.localStorage.setItem')
external void _setItem(JSString key, JSString value);
@JS('window.localStorage.removeItem')
external void _removeItem(JSString key);
@JS('Blob')
extension type _Blob._(JSObject _) implements JSObject {
  external factory _Blob(JSArray<JSAny?> parts, JSObject options);
}
@JS('URL.createObjectURL')
external JSString _createObjectURL(_Blob blob);
@JS('URL.revokeObjectURL')
external void _revokeObjectURL(JSString url);
@JS('document.createElement')
external JSObject _createElement(JSString tag);
extension type _Anchor(JSObject _) implements JSObject {
  external set href(JSString value);
  external set download(JSString value);
  external void click();
  external void remove();
}
@JS('document.body.appendChild')
external void _appendChild(JSObject element);

String? readLocalDraft() {
  try {
    return _getItem(_draftKey.toJS)?.toDart;
  } catch (_) {
    return null;
  }
}

bool writeLocalDraft(String value) {
  try {
    _setItem(_draftKey.toJS, value.toJS);
    return true;
  } catch (_) {
    return false;
  }
}

void clearLocalDraft() {
  try {
    _removeItem(_draftKey.toJS);
  } catch (_) {
    /* Storage may be unavailable. */
  }
}

void exportContentJson(String value) {
  final blob = _Blob(
    <JSAny?>[value.toJS].toJS,
    {'type': 'application/json;charset=utf-8'}.jsify()! as JSObject,
  );
  final url = _createObjectURL(blob);
  final anchor = _Anchor(_createElement('a'.toJS));
  anchor.href = url;
  anchor.download = 'portfolio.json'.toJS;
  _appendChild(anchor);
  anchor.click();
  anchor.remove();
  Timer(const Duration(seconds: 1), () => _revokeObjectURL(url));
}
