import '../../core/excel_component.dart';
import '../../core/dom.dart';

class Excel {
  late final Dom $el;
  late final List<ExcelComponent> components;

  Excel(String selector, {List<ExcelComponent>? components}) {
    $el = Dom.select(selector);
    this.components = components ?? [];
  }

  Dom getRoot() {
    Dom $root = Dom.create('div', 'excel');

    for (ExcelComponent component in components) {
      $root.append(component.getRootWithHTML());
    }

    return $root;
  }

  void render() {
    $el.append(getRoot());

    for (ExcelComponent component in components) {
      component.init();
    }
  }

  void destroy() {
    for (ExcelComponent component in components) {
      component.destroy();
    }
  }
}
