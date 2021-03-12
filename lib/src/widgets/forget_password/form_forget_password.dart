import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/utils/constants.dart';
import 'package:location_tracker/src/utils/form_validator.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:provider/provider.dart';

class ForgetPasswordForm extends StatefulWidget {
  @override
  _ForgetPasswordFormState createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  TextEditingController usernameController = TextEditingController();

  FormValidator usernameValidator = FormValidator();

  @override
  void initState() {
    usernameValidator.initialize(
        controller: usernameController, type: FormType.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyles.body(
                context: context,
                color: usernameValidator.isValid
                    ? themeProvider.textColor
                    : themeProvider.errorColor),
            cursorColor: usernameValidator.isValid
                ? themeProvider.accentColor
                : themeProvider.errorColor,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              if (!usernameValidator.isValid) {
                setState(() {
                  usernameValidator.validate();
                });
              }
            },
            decoration: InputDecoration(
              fillColor: themeProvider.secondaryColor,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(4)),
              prefixIcon: Icon(Icons.person,
                  color: usernameValidator.isValid
                      ? themeProvider.textColor
                      : themeProvider.errorColor),
              contentPadding: EdgeInsets.all(16),
              hintText: "username",
              hintStyle: TextStyles.body(
                  context: context,
                  color: usernameValidator.isValid
                      ? themeProvider.shadowColor
                      : themeProvider.errorColor.withOpacity(.25)),
              helperText: usernameValidator.validationMessage,
              helperStyle: TextStyles.caption(
                  context: context, color: themeProvider.errorColor),
            ),
          ),
          SizedBox(height: 24),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  usernameValidator.validate();
                });
                if (usernameValidator.isValid) {
                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
              child: Text(
                "Recover password".toUpperCase(),
                style:
                    TextStyles.subTitle(context: context, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
