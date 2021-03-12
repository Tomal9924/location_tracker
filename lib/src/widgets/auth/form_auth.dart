import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/provider/provider_auth.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/routes/home_route.dart';
import 'package:location_tracker/src/utils/constants.dart';
import 'package:location_tracker/src/utils/form_validator.dart';
import 'package:location_tracker/src/utils/loading.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  TextEditingController usernameController =
      TextEditingController(text: "administrator");
  TextEditingController passwordController =
      TextEditingController(text: "RMRCloudTheNO1CM\$");

  FormValidator usernameValidator = FormValidator();
  FormValidator passwordValidator = FormValidator();

  @override
  void initState() {
    usernameValidator.initialize(
        controller: usernameController, type: FormType.username);
    passwordValidator.initialize(
        controller: passwordController, type: FormType.password);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

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
          SizedBox(
            height: 16,
          ),
          TextField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            style: TextStyles.body(
                context: context,
                color: passwordValidator.isValid
                    ? themeProvider.textColor
                    : themeProvider.errorColor),
            cursorColor: passwordValidator.isValid
                ? themeProvider.accentColor
                : themeProvider.errorColor,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              if (!passwordValidator.isValid) {
                setState(() {
                  passwordValidator.validate();
                });
              }
            },
            decoration: InputDecoration(
              fillColor: themeProvider.secondaryColor,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(4)),
              prefixIcon: Icon(Icons.lock,
                  color: passwordValidator.isValid
                      ? themeProvider.textColor
                      : themeProvider.errorColor),
              contentPadding: EdgeInsets.all(16),
              hintText: "password",
              hintStyle: TextStyles.body(
                  context: context,
                  color: passwordValidator.isValid
                      ? themeProvider.shadowColor
                      : themeProvider.errorColor.withOpacity(.25)),
              helperText: passwordValidator.validationMessage,
              helperStyle: TextStyles.caption(
                  context: context, color: themeProvider.errorColor),
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Icon(
                    passwordValidator.isObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: passwordValidator.isValid
                        ? themeProvider.textColor
                        : themeProvider.errorColor),
                onPressed: () {
                  setState(() {
                    passwordValidator.toggleObscure();
                  });
                },
              ),
            ),
            obscureText: passwordValidator.isObscure,
          ),
          SizedBox(height: 24),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 54,
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  usernameValidator.validate();
                  passwordValidator.validate();
                });
                if (usernameValidator.isValid && passwordValidator.isValid) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showDialog(
                      context: context, builder: (context) => LoadingAlert());

                  Response authResponse = await authProvider.authenticate(
                      usernameController.text, passwordController.text);
                  switch (authResponse.statusCode) {
                    case 200:
                      Response userResponse = await authProvider.userInfo();
                      Navigator.of(context).pop();
                      switch (userResponse.statusCode) {
                        case 200:
                          Navigator.of(context).pushReplacementNamed(
                              HomeRoute().route,
                              arguments: authProvider.user.guid);
                          break;
                        default:
                          print("Info: ${userResponse.statusCode}");
                          break;
                      }
                      break;
                    default:
                      print("Auth: ${authResponse.statusCode}");
                      Navigator.of(context).pop();
                      break;
                  }
                }
              },
              child: Text("Login".toUpperCase(),
                  style: TextStyles.subTitle(
                      context: context, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
