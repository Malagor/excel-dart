import 'dart:html';

import '../../core/dom.dart';
import '../../core/excel_component.dart';

class Formula extends ExcelComponent {
  static const String className = 'excel__formula';

  Formula() : super(Dom.create('div', Formula.className), name: 'Formula') {
    listeners.addAll({'input': onInput});
  }

  @override
  String toHTML() {
    return '''
      <div class="info">
				<span class="material-symbols-outlined">function</span>
			</div>
			<div class="input" contenteditable spellcheck="false"></div>
		''';
  }

  void onInput(Event event) {
    final DivElement target = event.target as DivElement;

    print(target.innerText);
  }
}
