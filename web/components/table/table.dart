import '../../core/excel_component.dart';
import '../../core/dom.dart';
import 'table.template.dart';

class Table extends ExcelComponent {
  static const String className = 'excel__table';

  Table() : super(Dom.create('div', Table.className), name: 'Table');

  @override
  String toHTML() => createTable();
}
