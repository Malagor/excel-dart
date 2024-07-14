import 'dart:js_interop';

import 'package:web/web.dart';

import 'position.dart';

class Dom {
  late final Element nativeElement;

  Dom(dynamic nativeElement) {
    if (nativeElement is Element) {
      this.nativeElement = nativeElement;
    } else {
      throw Exception('$nativeElement is not an Element');
    }
  }

  Dom.create(String element, [String? classes = '']) {
    nativeElement = document.createElement(element);
    nativeElement.className = classes ?? '';
  }

  Dom.select(String selector) {
    Element? el = document.querySelector(selector);
    if (el == null) {
      throw Exception('No element with selector $selector');
    } else {
      nativeElement = el;
    }
  }

  set html(String htmlString) {
    nativeElement.innerHTML = htmlString;
  }

  String get html {
    return nativeElement.outerHTML.trim();
  }

  void clear() {
    html = '';
  }

  void append(dynamic node) {
    Element innerNode;

    if (node is Dom) {
      innerNode = node.nativeElement;
    } else if (node is Element) {
      innerNode = node;
    } else {
      throw Exception('$node is neither an Element or a Dom instance');
    }

    nativeElement.append(innerNode);
  }

  set classes(String className) {
    nativeElement.className = className;
  }

  String get classes {
    return nativeElement.className;
  }

  Dom? closest(String selectors) {
    return Dom(nativeElement.closest(selectors));
  }

  DOMStringMap get dataset {
    return (nativeElement as HTMLElement).dataset;
  }

  Position get position {
    return Position(nativeElement.getBoundingClientRect());
  }

  void style((String, String) entity) {
    (nativeElement as HTMLElement)
        .attributeStyleMap
        .set(entity.$1, entity.$2.toJS);
  }

  void on(String eventType, EventListener listener) {
    nativeElement.addEventListener(eventType, listener);
  }

  void off(String eventType, EventListener listener) {
    nativeElement.removeEventListener(eventType, listener);
  }
}
