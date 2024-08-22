import 'dart:js_interop';

import 'package:web/web.dart';

import '../../core/dom.dart';
import '../../core/event_list.dart';
import '../../core/excel_component.dart';
import '../../core/types.dart';
import 'table.functions.dart';
import 'table.resize.dart';
import 'table.template.dart';
import 'table_selection.dart' as table_selection;

class Table extends ExcelComponent {
  static const String className = 'excel__table';

  final table_selection.Selection _tableSelection =
      table_selection.TableSelection();

  Table() : super(Dom.create('div', Table.className), name: 'Table') {
    listeners
        .addAll({'mousedown': _onMousedown.toJS, 'keyup': _onKeyup.toJS});
  }

  @override
  String toHTML() => createTable();

  @override
  void init() {
    super.init();
    _selectCell($root.find('[data-id="0:0"]'));

    $on(EventList.formulaDone, () => _tableSelection.current.focus());
    $on(EventList.formulaInput, (str) => _tableSelection.current.text = str);
  }

  void _selectCell(Dom $cell) {
    _tableSelection.select($cell);
    $emit(EventList.tableSelect, $cell);
  }

  void _onMousedown(MouseEvent event) {
    Dom $target = Dom(event.target);

    if (isCell($target)) {
      if (event.shiftKey) {
        String selectors =
        createSelectionSelectors(_tableSelection.current, $target);

        _tableSelection.selectGroup($root.findAll(selectors));

        return;
      }

      _selectCell($target);

      return;
    }

    if (shouldResize($target)) {
      resizeTable($root, $target);
      return;
    }
  }

  void _onKeyup(KeyboardEvent event) {
    List<String> keyCodes = [
      'ArrowUp',
      'ArrowDown',
      'ArrowRight',
      'ArrowLeft',
      'Enter',
      'NumpadEnter',
      'Tab'
    ];

    if (keyCodes.contains(event.code) && !event.shiftKey) {
      event.preventDefault();
      final CellId currentCellId = _tableSelection.current.parsedId!;
      final Dom $next = $root.find(nextSelector(event.code, currentCellId));

      _selectCell($next);
    } else {
      $emit(EventList.tableInput, _tableSelection.current);
    }
  }
}
