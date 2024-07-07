import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart';

import '../../core/dom.dart';
import '../../core/excel_component.dart';
import 'table.template.dart';

class Table extends ExcelComponent {
  static const String className = 'excel__table';
  Dom? resizeElement;
  StreamSubscription<MouseEvent>? _mouseStreamSubscription;

  Table() : super(Dom.create('div', Table.className), name: 'Table') {
    listeners.addAll({'mousedown': onMousedown.toJS, 'mouseup': onMouseup.toJS});
  }

  @override
  String toHTML() => createTable();

  void onMousedown(Event event) {
    Dom $resizer = Dom(event.target);

    if ($resizer.dataset.has('resize')) {
      print($resizer.dataset.getProperty('resize'.toJS));
      resizeElement = $resizer;

      Dom? $parent = $resizer.closest('[data-type="resizable"]');
      print($parent?.coords);

      document.onmousemove = onMousemove.toJS;
    }
  }

  void onMousemove(Event event) {
    num x = (event as MouseEvent).clientX;
    print('x: $x');
    // print(resizeElement?.borderEdge.left);
    // resizeElement?.borderEdge.left = x;

  }

  void onMouseup(Event event) {
    print('mouseup');
    document.onmousemove = null;
  }
}
