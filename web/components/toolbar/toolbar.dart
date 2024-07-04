import '../../core/dom.dart';
import '../../core/excel_component.dart';

class Toolbar extends ExcelComponent {
  static const String className = 'excel__toolbar';

  Toolbar() : super(Dom.create('div', Toolbar.className), name: 'Toolbar');

  @override
  String toHTML() {
    return '''
      <div class="group-button">
				<div class="button" role="button" tabindex="0">
					<span class="material-symbols-outlined">format_align_left</span>
				</div>
				<div class="button" role="button" tabindex="0">
					<span class="material-symbols-outlined">format_align_center</span>
				</div>
				<div class="button" role="button" tabindex="0">
					<span class="material-symbols-outlined">format_align_right</span>
				</div>
			</div>
			<div class="group-button">
				<div class="button" role="button" tabindex="0">
					<span class="material-symbols-outlined">format_bold</span>
				</div>
				<div class="button" role="button" tabindex="0">
					<span class="material-symbols-outlined">format_italic</span>
				</div>
				<div class="button" role="button" tabindex="0">
					<span class="material-symbols-outlined">format_underlined</span>
				</div>
			</div>
  ''';
  }
}
