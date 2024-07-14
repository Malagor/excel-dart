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
  Dom? $resizableParent;
  StreamSubscription<MouseEvent>? mouseMoveStream;

  Table() : super(Dom.create('div', Table.className), name: 'Table') {
    listeners
        .addAll({'mousedown': _onMousedown.toJS, 'mouseup': _onMouseup.toJS});
  }

  @override
  String toHTML() => createTable();

  void _onMousedown(Event event) {
    Dom $resizer = Dom(event.target);
    String? typeOfResize = $resizer.data['resize'] as String?;

    if (typeOfResize == null) {
      return;
    }

    $resizableParent = $resizer.closest('[data-type="resizable"]');

    if ($resizableParent == null) {
      return;
    }

    parentPosition = $resizableParent!.position;

    final String? resizeEntityIndex =
        $resizableParent?.data[typeOfResize] as String?;

    if (resizeEntityIndex == null) {
      throw Exception(
          'Information about the index of a row or column could not be obtained.');
    }

    final nodeList = _getNodeList(typeOfResize, resizeEntityIndex);

    if (nodeList == null) {
      return;
    }

    mouseMoveStream = $root.nativeElement.onMouseMove
        .listen(_onMousemove(typeOfResize, resizeEntityIndex, nodeList));
  }

  _onMousemove(String type, String indexEntity, Iterable<Dom> nodeList) {
    return (Event event) {
      switch (type) {
        case 'col':
          parentPosition!.target = (event as MouseEvent).pageX;
          _resizeRowOrColumn('col', parentPosition!.calculateWidth(), nodeList);

        case 'row':
          parentPosition!.target = (event as MouseEvent).pageY;
          _resizeRowOrColumn(
              'row', parentPosition!.calculateHeight(), nodeList);

        default:
          throw Exception('Resize type is wrong!');
      }
    };
  }

  void _onMouseup(Event event) {
    mouseMoveStream?.cancel();
  }

  Iterable<Dom>? _getNodeList(String type, String indexEntity) {
    switch (type) {
      case 'col':
        return $root.children('[data-col="$indexEntity"]');
      case 'row':
        return $root.children('.row[data-row="$indexEntity"]');
      default:
        return null;
    }
  }

  void _resizeRowOrColumn(String type, num newSize, Iterable<Dom> nodeList) {
    final property = type == 'col' ? 'width' : 'height';

    for (final element in nodeList) {
      element.css({property: '${newSize}px'});
    }
  }
}
