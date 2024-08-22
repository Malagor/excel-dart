import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math';

import '../../core/dom.dart';
import '../../core/types.dart';
import '../../excel.config.dart' as config;

CellId parseCellId(String idString) {
  var idList = idString.split(':').map((value) => int.parse(value));
  return (
    row: idList.first,
    col: idList.last,
  );
}

bool shouldResize(Dom target) {
  return target.data.hasProperty('resize'.toJS) as bool;
}

bool isCell(Dom target) {
  return target.data.hasProperty('type'.toJS) as bool;
}

String createSelectionSelectors(Dom $startEl, Dom $endEl) {
  var start = parseCellId($startEl.dataId!);
  var finish = parseCellId($endEl.dataId!);
  List<String> selector = [];

  for (int row = min(start.row, finish.row);
      row <= max(start.row, finish.row);
      row++) {
    for (int col = min(start.col, finish.col);
        col <= max(start.col, finish.col);
        col++) {
      selector.add('[data-id="$row:$col"]');
    }
  }
  return selector.join(',');
}

String nextSelector(String keyCode, CellId id) {
  int row = id.row;
  int col = id.col;

  switch (keyCode) {
    case 'ArrowUp':
      row = (row <= 0) ? 0 : row - 1;

    case 'ArrowDown' || 'Enter' || 'NumpadEnter':
      row = (row >= config.maxRowNumbers - 1) ? config.maxRowNumbers - 1 : row + 1;

    case 'ArrowLeft':
      col = (col <= 0) ? 0 : col - 1;

    case 'ArrowRight' || 'Tab':
      col = (col >= config.columnNumbers) ? config.columnNumbers : col + 1;
  }

  return '[data-id="$row:$col"]';
}
