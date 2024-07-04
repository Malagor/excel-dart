import 'dom_listener.dart';
import 'dom.dart';

class ExcelComponent extends DomListener {
  late String name;

  ExcelComponent(super.$root, {required this.name});

  void init() {
    initDOMListeners();
  }

  String toHTML() {
    return '';
  }

  Dom getRootWithHTML() {
    $root.html = toHTML();
    return $root;
  }

  void destroy() {
    removeDomListeners();
  }
}
