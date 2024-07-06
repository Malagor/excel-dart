import 'dart:html';

class AllowAll implements NodeValidator {
  @override
  bool allowsAttribute(Element element, String attributeName, String value) {
    return true;
  }

  @override
  bool allowsElement(Element element) {
    return true;
  }
}

final NodeValidatorBuilder htmlValidator = NodeValidatorBuilder.common()
  ..allowElement('div', attributes: ['role', 'contenteditable', 'tabindex', 'data-resize', 'data-type']);
