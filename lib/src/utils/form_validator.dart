import 'package:flutter/material.dart';
import 'package:location_tracker/src/utils/constants.dart';

class FormValidator {
  bool isValid = true;
  bool isObscure = true;
  TextEditingController controller;
  String validationMessage;
  FormType type;

  initialize(
      {@required TextEditingController controller, @required FormType type}) {
    this.controller = controller;
    this.type = type;
  }

  validate() {
    switch (type) {
      case FormType.name:
        isValid = controller.text.isNotEmpty;
        validationMessage = isValid ? null : "***required";
        break;
      case FormType.phone:
        // TODO: Handle this case.
        break;
      case FormType.username:
        isValid = controller.text.isNotEmpty;
        validationMessage = isValid ? null : "***required";
        break;
      case FormType.email:
        // TODO: Handle this case.
        break;
      case FormType.zip:
        isValid = controller.text.length == 5;
        break;
      case FormType.password:
        isValid = controller.text.length >= 6;
        validationMessage = isValid
            ? null
            : controller.text.isNotEmpty
                ? "password length should be at least 6 characters"
                : "password is required";
        break;
    }
  }

  void toggleObscure() {
    if (type == FormType.password) {
      isObscure = !isObscure;
    }
  }
}
