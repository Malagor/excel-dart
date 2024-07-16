import 'package:web/web.dart';

class Position {
  late final DOMRect _rect;
  num? target;

  Position(this._rect);

  num calculateWidth() => _rect.width + (target ?? _rect.right) - _rect.right;

  num calculateHeight() => _rect.height + (target ?? _rect.bottom) - _rect.bottom;

  num get deltaY {
    return (target ?? _rect.bottom) - _rect.bottom;
  }

  num get deltaX {
    return (target ?? _rect.right) - _rect.right;
  }

}
