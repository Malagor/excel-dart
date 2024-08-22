import '../../core/dom.dart';

abstract class Selection {
  void select(Dom $el);
  void selectGroup(Iterable<Dom> $els);

  Dom get current;
}

class TableSelection extends Selection {
  static String selectedClass = 'selected';

  final List<Dom> _$elements = [];
  Dom? _$current;

  @override
  void select(Dom $el) {
    if (_$current?.dataId == $el.dataId) {
      return;
    }

    _clear();
    _$elements.add($el);
    _$current = $el;
    _addSelectedClass();
    _$current!.focus();
  }

  @override
  void selectGroup(Iterable<Dom> $els) {
    _clear();
    _$elements.addAll($els);
    _addSelectedClass();
  }

  @override
  Dom get current {
    return _$current!;
  }

  void _addSelectedClass() {
    for (Dom $el in _$elements) {
      $el.addClass(TableSelection.selectedClass);
    }
  }

  void _clear() {
    for (Dom $el in _$elements) {
      $el.removeClass(TableSelection.selectedClass);
    }
    _$elements.clear();
  }
}
