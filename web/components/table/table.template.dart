final codes = (A: 'A'.codeUnitAt(0), Z: 'Z'.codeUnitAt(0));

String _createCell((int, String) entity) {
  return '''
    <div class="cell" data-col=${entity.$1} contenteditable>${entity.$2}</div>
  ''';
}

String _createColumn((int, String) entity) {
  return '''
    <div class="column" data-type="resizable" data-col='${entity.$1}'>
      ${entity.$2}
      <div class="col-resize" data-resize="col"></div>
    </div>
  ''';
}

String _toChar((int, String) entity) {
  return String.fromCharCode(codes.A + entity.$1);
}

String _createRow({int? index, String content = ''}) {
  final String resizer = index != null ? '<div class="row-resize" data-resize="row"></div>' : '';

  return '''
  <div class="row">
    <div class="row-info">
      ${index ?? ''}
     $resizer
    </div>
	  <div class="row-data">$content</div>
	</div>
  ''';
}

String createTable({int rowCount = 20}) {
  final int columnsCount = codes.Z - codes.A;
  final rows = [];

  final String cols = List.filled(columnsCount + 1, '')
      .indexed
      .map(_toChar)
      .indexed
      .map(_createColumn)
      .join('');

  rows.add(_createRow(content: cols));

  final String cells = List.filled(columnsCount + 1, '')
      .indexed
      .map(_createCell)
      .join('');

  for (int i = 0; i < rowCount; i++) {
    rows.add(_createRow(index: i + 1, content: cells));
  }

  return rows.join('');
}
