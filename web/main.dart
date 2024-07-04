import 'components/header/header.dart';
import 'components/excel/excel.dart';
import 'components/toolbar/toolbar.dart';
import 'components/formula/formula.dart';
import 'components/table/table.dart';

void main() {
  final Excel excel = Excel('#root', components: [
    Header(),
    Toolbar(),
    Formula(),
    Table(),
  ]);

  excel.render();
}
