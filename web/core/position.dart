import 'package:web/web.dart';

class Position {
  late final DOMRect _rect;
  late num target = 0;

  Position(this._rect): target = _rect.right;

  DOMRect get rect {
    return _rect;
  }

  num calculateWidth() => _rect.width + target - _rect.right;

  num calculateHeight() => _rect.height + target - _rect.bottom;
}
