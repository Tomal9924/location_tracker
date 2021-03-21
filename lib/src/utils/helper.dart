import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Helper {
  static String beautifyName(String title, String firstName, String lastName) {
    String fullName = title != null ? title.trim() : "";
    fullName =
        firstName != null ? "${fullName.trim()} ${firstName.trim()}" : fullName;
    fullName =
        lastName != null ? "${fullName.trim()} ${lastName.trim()}" : fullName;
    return fullName.trim();
  }

  static void alertValidationERROR({@required BuildContext context, @required String message}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.redAccent.shade200,
      duration: Duration(seconds: 2),
      boxShadows: [
        BoxShadow(
          color: Colors.redAccent.shade100,
          offset: Offset(0.0, 0.0),
          blurRadius: 1.0,
        )
      ],
      title: "Validation Error!",
      message: message,
    )..show(context);
  }
}
