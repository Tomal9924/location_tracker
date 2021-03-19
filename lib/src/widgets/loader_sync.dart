import 'package:flutter/material.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/provider/provider_user.dart';
import 'package:provider/provider.dart';

class SyncLoader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.init();
    return Center(
      child: SizedBox(
        width: 112,
        height: 112,
        child: Stack(
          children: [
            Positioned(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation(themeProvider.backgroundColor),
              ),
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
            ),
            Positioned(
              child: CircleAvatar(
                backgroundColor: themeProvider.shadowColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sync, color: themeProvider.backgroundColor, size: 32,),
                  ],
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
