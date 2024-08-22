import 'dom_listener.dart';
import 'dom.dart';
import 'event_emitter.dart';


class ExcelComponent extends DomListener {
  late String name;
  final EventEmitter emitter =  ExcelEventEmitter.instance;
  final List<Function> eventSubscribers = [];

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

  $emit(String eventName, [dynamic arg]) {
    emitter.emit(eventName, arg);
  }

  $on(String eventName, Function listener, [bool once = false]) {
    eventSubscribers.add(emitter.subscribe(eventName, listener, once));
  }

  void destroy() {
    removeDomListeners();
    for (Function unsubscriber in eventSubscribers) {
      unsubscriber();
    }
  }
}
