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

  void addClass(String className) {
    nativeElement.classList.add(className);
  }

  void removeClass(String className) {
    nativeElement.classList.remove(className);
  }

  Dom? closest(String selectors) {
    return Dom(nativeElement.closest(selectors));
  }

  Iterable<Dom> findAll(String selectors) {
    return List.from(nativeElement.querySelectorAll(selectors) as Iterable)
        .map((node) => Dom(node));
  }

  Dom find(String selector) {
    return Dom(nativeElement.querySelector(selector));
  }

  DOMStringMap get data {
    return (nativeElement as HTMLElement).dataset;
  }

  Position get position {
    return Position(nativeElement.getBoundingClientRect());
  }

  void css(Map<String, dynamic> styles) {
    for (var style in styles.entries) {
      (nativeElement as HTMLElement)
          .attributeStyleMap
          .set(style.key, style.value);
    }
  }

  void on(String eventType, EventListener listener) {
    nativeElement.addEventListener(eventType, listener);
  }

  void off(String eventType, EventListener listener) {
    nativeElement.removeEventListener(eventType, listener);
  }
}
