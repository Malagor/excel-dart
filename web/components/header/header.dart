import '../../core/dom.dart';
import '../../core/excel_component.dart';

class Header extends ExcelComponent {
  static const String className = 'excel__header';

  Header() : super(Dom.create('div', Header.className), name: 'Header');

  @override
  String toHTML() {
    return '''
      <input type="text" class="input" value="New table2">
			<div class="button-wrapper">
				<div class="button" role="button" tabindex="0">
					<span class="material-symbols-outlined">logout</span>
				</div>
				<div class="button" role="button" tabindex="0">
					<span class="material-symbols-outlined">delete</span>
				</div>
			</div>
    ''';
  }
}
