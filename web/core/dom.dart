import 'dart:html';

import 'node_validator.dart' show htmlValidator;

class Dom {
  late final Element nativeElement;

  Dom(this.nativeElement);

  Dom.create(String element, [String? classes = '']) {
    nativeElement = Element.tag(element);
    nativeElement.className = classes ?? '';
  }

  Dom.select(String selector) {
    Element? el = querySelector(selector);
    if (el == null) {
      throw Exception('No element with selector $selector');
    } else {
      nativeElement = el;
    }
  }

  set html(String htmlString) {
    nativeElement.setInnerHtml(htmlString, validator: htmlValidator);
  }

  String get html {
    return nativeElement.outerHtml?.trim() ?? '';
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

  void on(String eventType, EventListener listener) {
    nativeElement.addEventListener(eventType, listener);
  }

  void off(String eventType, EventListener listener) {
    nativeElement.removeEventListener(eventType, listener);
  }
}
