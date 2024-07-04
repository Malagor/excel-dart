import 'dart:html';

import 'dom.dart';

abstract class DomListener {
  final Dom $root;
  late final Map<String, EventListener> listeners = {};

  DomListener(this.$root);

  initDOMListeners() {
    for (final element in listeners.entries) {
      $root.on(element.key, element.value);
    }
  }

  removeDomListeners() {
    print('removeDomListeners');
    for (final element in listeners.entries) {
      $root.off(element.key, element.value);
    }
  }
}
