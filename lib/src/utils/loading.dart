import 'package:flutter/material.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:provider/provider.dart';

class LoadingAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Center(
      child: SizedBox(
        width: 84,
        height: 84,
        child: Stack(
          children: [
            Positioned(
              child: CircularProgressIndicator( strokeWidth: 4, valueColor: AlwaysStoppedAnimation(themeProvider.accentColor),),
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
            ),
            Positioned(
              child: CircleAvatar(
                backgroundColor: themeProvider.shadowColor,
                child: Image.asset(
                  "images/logo.png",
                  width: 42,
                  height: 42,
                  fit: BoxFit.contain,
                ),
              ),
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
            ),
          ],
        ),
      ),
    );
  }
}
