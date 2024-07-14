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

  Table() : super(Dom.create('div', Table.className), name: 'Table') {
    listeners
        .addAll({'mousedown': onMousedown.toJS, 'mouseup': onMouseup.toJS});
  }

  @override
  String toHTML() => createTable();

  void onMousedown(Event event) {
    print('onMousedown');
    Dom $resizer = Dom(event.target);

    if ($resizer.dataset.has('resize') == false) {
      return;
    }

    $currentParent = $resizer.closest('[data-type="resizable"]');

    if ($currentParent == null) {
      return;
    }

    parentPosition = $currentParent!.coords;
    document.onmousemove = onMousemove.toJS;
  }


void onMousemove(Event event) {
  parentPosition!.target = (event as MouseEvent).clientX;

  num newWidth = parentPosition!.calculateWidth();

  final String? colIndex = $currentParent?.dataset['col'] as String?;

  if (colIndex == null) {
    return;
  }

  _resizeColumns(colIndex, newWidth);
}

void onMouseup(Event event) {
  print('mouseup');

  document.onmousemove = null;
}

void _resizeColumns(String colIndex, num newWidth) {
  final nodeList = List.from(
      document.querySelectorAll('[data-col="$colIndex"]') as Iterable);

  for (final element in nodeList) {
    Dom(element).style(('width', '${newWidth}px'));
  }
}

void _resizeRow(int? rowIndex, num newHeight) {
  final nodeList = List.from(
      document.querySelectorAll('[data-row="$rowIndex"]') as Iterable);

  for (final element in nodeList) {
    Dom(element).style(('height', '${newHeight}px'));
  }
}}
