import 'dart:async';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

import '../../core/dom.dart';
import '../../core/position.dart';

Set<StreamSubscription<Event>> mouseStreams = {};

void resizeTable(Dom $root, MouseEvent event) {
  Dom $resizer = Dom(event.target);
  String? typeOfResize = $resizer.data['resize'] as String?;

  if (typeOfResize == null) {
    return;
  }

  $resizer.addClass('clicked');

  Dom? $resizableParent = $resizer.closest('[data-type="resizable"]');

  if ($resizableParent == null) {
    return;
  }

  Position parentPosition = $resizableParent.position;

  final String? indexOfResizeEntity =
      $resizableParent.data[typeOfResize] as String?;

  if (indexOfResizeEntity == null) {
    throw Exception(
        'Information about the index of a row or a column could not be obtained.');
  }

  final Element body = document.querySelector('body')!;

  mouseStreams.add(body.onMouseMove.listen((event) {
    switch (typeOfResize) {
      case 'col':
        parentPosition.target = event.pageX;
        $resizer.css({'right': '${-(parentPosition.deltaX + 2)}px'});
      case 'row':
        parentPosition.target = event.pageY;
        $resizer.css({'bottom': '${-(parentPosition.deltaY + 2)}px'});
    }
  }));

  mouseStreams.add(body.onMouseUp.listen((event) {
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

    _resetResizer($resizer, typeOfResize);
    _unsubscribeStreams();
  }));
}

void _resizeColumn(Iterable<Dom> nodeList, num newSize) {
  for (final element in nodeList) {
    element.css({'width': '${newSize}px'});
  }
}

void _resizeRow(Dom $node, num newSize) {
  $node.css({'height': '${newSize}px'});
}

void _resetResizer(Dom $resizer, String typeOfResize) {
  final sizeProperty = typeOfResize == 'col' ? 'right' : 'bottom';

  $resizer.css({sizeProperty: '-2px'});
  $resizer.removeClass('clicked');
}

void _unsubscribeStreams() {
  for (final event in mouseStreams) {
    event.cancel();
  }
  mouseStreams.clear();
}
