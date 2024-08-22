import 'dart:js_interop';

import 'package:web/web.dart';

import '../../core/dom.dart';
import '../../core/excel_component.dart';
import '../../core/event_list.dart';

class Formula extends ExcelComponent {
  static const String className = 'excel__formula';

  Dom? $input;

  Formula() : super(Dom.create('div', Formula.className), name: 'Formula') {
    listeners.addAll({'input': onInput.toJS, 'keydown': onKeyDown.toJS});
  }

  @override
  void init() {
    super.init();

    $on(EventList.tableSelect, setInputText);
    $on(EventList.tableInput, setInputText);
  }

  @override
  String toHTML() {
    return '''
      <div class="info">
				<span class="material-symbols-outlined">function</span>
			</div>
			<div data-type="input" class="input" contenteditable spellcheck="false"></div>
		''';
  }

  void onInput(Event event) {
    $emit(EventList.formulaInput, Dom(event.target).text);
  }

  void onKeyDown(KeyboardEvent event) {
    List<String> codes = ['Enter', 'NumpadEnter', 'Tab'];

    if (codes.contains(event.code)) {
      event.preventDefault();
      $emit(EventList.formulaDone);
    }
  }

  void setInputText(Dom $cell) {
    $input ??= $root.find('[data-type="input"]');
    $input?.text = $cell.text;
  }
}
