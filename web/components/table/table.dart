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
    $resizer = Dom(event.target);
    String? typeOfResize = $resizer.data['resize'] as String?;

    if (typeOfResize == null) {
      return;
    }

    $resizer.addClass('clicked');

    $resizableParent = $resizer.closest('[data-type="resizable"]');

    if ($resizableParent == null) {
      return;
    }

    parentPosition = $resizableParent!.position;

    final String? indexOfResizeEntity =
        $resizableParent?.data[typeOfResize] as String?;

    if (indexOfResizeEntity == null) {
      throw Exception(
          'Information about the index of a row or a column could not be obtained.');
    }

    final Element body = document.querySelector('body')!;
    mouseStreams
        .add(body.onMouseMove.listen(_getMouseMoveHandler(typeOfResize)));
    mouseStreams.add(body.onMouseUp
        .listen(_getMouseUpHandler(typeOfResize, indexOfResizeEntity)));
  }

  Null Function(MouseEvent event) _getMouseMoveHandler(String typeOfResize) {
    return (MouseEvent event) {
      switch (typeOfResize) {
        case 'col':
          parentPosition.target = event.pageX;
          $resizer.css({'right': '${-(parentPosition.deltaX + 2)}px'});
        case 'row':
          parentPosition.target = event.pageY;
          $resizer.css({'bottom': '${-(parentPosition.deltaY + 2)}px'});
      }
    };
  }

  Null Function(MouseEvent eventt) _getMouseUpHandler(
      String typeOfResize, String indexOfResizeEntity) {
    return (MouseEvent event) {
      _resizeEntity(typeOfResize, indexOfResizeEntity);
      _resetResizer(typeOfResize);
      _unsubscribeStreams();
    };
  }

  void _resizeEntity(String typeOfResize, String indexOfResizeEntity) {
    switch (typeOfResize) {
      case 'col':
        final Iterable<Dom> nodeList =
            $root.findAll('[data-col="$indexOfResizeEntity"]');
        if (nodeList.isEmpty) {
          return;
        }
        _resizeColumn(nodeList, parentPosition.calculateWidth());

      case 'row':
        final Dom $node = $root.find('.row[data-row="$indexOfResizeEntity"]');
        _resizeRow($node, parentPosition.calculateHeight());
    }
  }

  void _resizeColumn(Iterable<Dom> nodeList, num newSize) {
    for (final element in nodeList) {
      element.css({'width': '${newSize}px'});
    }
  }

  void _resizeRow(Dom $node, num newSize) {
    $node.css({'height': '${newSize}px'});
  }

  void _unsubscribeStreams() {
    for (final event in mouseStreams) {
      event.cancel();
    }
    mouseStreams.clear();
  }

  void _resetResizer(String typeOfResize) {
    final sizeProperty = typeOfResize == 'col' ? 'right' : 'bottom';

    $resizer.css({sizeProperty: '-2px'});
    $resizer.removeClass('clicked');
  }
}
