abstract class EventEmitter {
  void Function() subscribe(String eventName, Function listener, [bool once = false]);

  void emit(String eventName, [dynamic args]);
}

class EventSet {
  late Function listener;
  late bool once;

  EventSet(this.listener, [this.once = false]);
}

class ExcelEventEmitter implements EventEmitter {
  ExcelEventEmitter._internal();

  static final ExcelEventEmitter _instance = ExcelEventEmitter._internal();

  static ExcelEventEmitter get instance => _instance;

  Map<String, Set<EventSet>> eventMap = {};

  @override
  void Function() subscribe(String eventName, listener, [bool once = false]) {
    EventSet currentListener = EventSet(listener, once);

    eventMap.putIfAbsent(eventName, () => {}).add(currentListener);

    // un-subscriber
    return () {
      eventMap[eventName]?.remove(currentListener);
    };
  }

  @override
  void emit(String eventName, [dynamic args]) {
    if (eventMap[eventName] is! Set<EventSet>) {
      return;
    }

    for (EventSet currentListener in eventMap[eventName]!) {
      if (args != null) {
        currentListener.listener(args);
      } else {
        currentListener.listener();
      }

      if (currentListener.once) {
        eventMap[eventName]!.remove(currentListener);

        if (eventMap[eventName]!.isEmpty) {
          break;
        }
      }
    }
  }
}
