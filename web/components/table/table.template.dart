final codes = (A: 'A'.codeUnitAt(0), Z: 'Z'.codeUnitAt(0));

String Function((int, String)) _createCell(num rowIndex) {
  return ((int, String) entity) => '''
    <div class="cell" data-col=${entity.$1} data-row="$rowIndex" contenteditable>${entity.$2}</div>
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
  final String resizer =
      index != null ? '<div class="row-resize" data-resize="row"></div>' : '';
  final String rowIndex = index == null ? '' : '${index - 1}';

  return '''
  <div class="row" data-type="resizable" data-row='$rowIndex'>
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

  String formatRow(num rowIndex) {
    final String cells =
        List.filled(columnsCount + 1, '').indexed.map(_createCell(rowIndex)).join('');

    return cells;
  }

  for (int i = 0; i < rowCount; i++) {
    rows.add(_createRow(index: i + 1, content: formatRow(i)));
  }

  return rows.join('');
}
