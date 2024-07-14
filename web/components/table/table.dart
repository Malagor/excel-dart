import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

import '../../core/dom.dart';
import '../../core/excel_component.dart';
import '../../core/position.dart';
import 'table.template.dart';

class Table extends ExcelComponent {
  static const String className = 'excel__table';
  Position? parentPosition;
  Dom? $currentParent;
  StreamSubscription<MouseEvent>? mouseMoveStream;

  Table() : super(Dom.create('div', Table.className), name: 'Table') {
    listeners
        .addAll({'mousedown': _onMousedown.toJS, 'mouseup': _onMouseup.toJS});
  }

  @override
  String toHTML() => createTable();

  void _onMousedown(Event event) {
    Dom $resizer = Dom(event.target);
    String? resizeType = $resizer.dataset['resize'] as String?;

    if (resizeType == null) {
      return;
    }

    $currentParent = $resizer.closest('[data-type="resizable"]');

    if ($currentParent == null) {
      return;
    }

    parentPosition = $currentParent!.position;
    mouseMoveStream = $root.nativeElement.onMouseMove.listen(_onMousemove(resizeType));
  }

   _onMousemove(String type) {
    return (Event event) {
      final String? resizeEntityIndex =
          $currentParent?.dataset[type] as String?;

      if (resizeEntityIndex == null) {
        return;
      }

      switch (type) {
        case 'col':
          parentPosition!.target = (event as MouseEvent).pageX;
          _resizeColumns(resizeEntityIndex, parentPosition!.calculateWidth());
        case 'row':
          parentPosition!.target = (event as MouseEvent).pageY;
          _resizeRow(resizeEntityIndex, parentPosition!.calculateHeight());
        default:
          throw Exception('Resize type is wrong!');
      }
    };
  }

  void _onMouseup(Event event) {
    mouseMoveStream?.cancel();
  }

  void _resizeColumns(String colIndex, num newWidth) {
    final nodeList = List.from(
        document.querySelectorAll('[data-col="$colIndex"]') as Iterable);

    for (final element in nodeList) {
      Dom(element).style(('width', '${newWidth}px'));
    }
  }

  void _resizeRow(String rowIndex, num newHeight) {
    Dom(document.querySelector('.row[data-row="$rowIndex"]'))
        .style(('height', '${newHeight}px'));
  }
}
