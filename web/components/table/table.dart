import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart';

import '../../core/dom.dart';
import '../../core/excel_component.dart';
import '../../core/position.dart';
import 'table.resize.dart';
import 'table.template.dart';

class Table extends ExcelComponent {
  static const String className = 'excel__table';
  late Position parentPosition;
  Dom? $resizableParent;
  late Dom $resizer;
  Set<StreamSubscription<Event>> mouseStreams = {};

  Table() : super(Dom.create('div', Table.className), name: 'Table') {
    listeners.addAll({'mousedown': _onMousedown.toJS});
  }

  @override
  String toHTML() => createTable();

  void _onMousedown(MouseEvent event) {
    resizeTable($root, event);
  }
}
