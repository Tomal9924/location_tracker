import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:location_tracker/src/widgets/auth/form_auth.dart';
import 'package:provider/provider.dart';

class AuthRoute extends StatelessWidget {
  final String route = "/auth";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: themeProvider.backgroundColor,
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                Icon(
                  Icons.architecture,
                  size: 72,
                  color: themeProvider.accentColor,
                ),
                SizedBox(
                  height: 12,
                ),
                Text("Welcome",
                    style: TextStyles.title(
                        context: context, color: themeProvider.accentColor),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 12,
                ),
                AuthForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
