import 'dart:async';
import 'dart:html';

import '../../core/dom.dart';
import '../../core/excel_component.dart';
import 'table.template.dart';

class Table extends ExcelComponent {
  static const String className = 'excel__table';
  Dom? resizeElement;
  StreamSubscription<MouseEvent>? _mouseStreamSubscription;

  Table() : super(Dom.create('div', Table.className), name: 'Table') {
    listeners.addAll({'mousedown': onMousedown, 'mouseup': onMouseup});
  }

  @override
  String toHTML() => createTable();

  void onMousedown(Event event) {
    Dom $resizer = Dom(event.target);

    if ($resizer.dataset.containsKey('resize')) {
      print(($resizer.dataset['resize']));
      resizeElement = $resizer;

      Dom? $parent = $resizer.closest('[data-type="resizable"]');
      print($parent?.coords);

      _mouseStreamSubscription = document.onMouseMove.listen(onMousemove);
    }
  }

  void onMousemove(Event event) {
    num x = (event as MouseEvent).client.x;
    print('x: $x');
    // print(resizeElement?.borderEdge.left);
    // resizeElement?.borderEdge.left = x;

  }

  void onMouseup(Event event) {
    print('mouseup');
    _mouseStreamSubscription?.cancel();
  }
}
