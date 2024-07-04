final codes = (A: 'A'.codeUnitAt(0), Z: 'Z'.codeUnitAt(0));

String _createCell([String content = '']) {
  return '''
    <div class="cell" contenteditable>$content</div>
  ''';
}

String _createColumn([String content = '']) {
  return '''
    <div class="column">$content</div>
  ''';
}

String _toChar((int, String) entity) {
  return String.fromCharCode(codes.A + entity.$1);
}

String _createRow({int? index, String content = ''}) {
  return '''
  <div class="row">
    <div class="row-info">${index ?? ''}</div>
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
      .map(_createColumn)
      .join('');

  rows.add(_createRow(content: cols));

  final String cells = List.filled(columnsCount + 1, '')
      .indexed
      .map((colIdx) => _createCell())
      .join('');

  for (int i = 0; i < rowCount; i++) {
    rows.add(_createRow(index: i + 1, content: cells));
  }

  return rows.join('');
}
