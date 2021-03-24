import 'package:flutter/material.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/provider/provider_user.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:location_tracker/src/widgets/loader_sync.dart';
import 'package:provider/provider.dart';

class SyncData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.init();
    final int unsavedDataCount = userProvider.unSyncDataLength;
    return PhysicalModel(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: themeProvider.backgroundColor,
      shadowColor: themeProvider.accentColor.withOpacity(.25),
      elevation: 4,
      shape: BoxShape.rectangle,
      child: MaterialBanner(
        content: Text("You have $unsavedDataCount unsaved location plotting data"),
        forceActionsBelow: true,
        padding: EdgeInsets.all(16),
        leading: Icon(Icons.sync_problem, color: themeProvider.textColor),
        contentTextStyle: TextStyles.body(context: context, color: themeProvider.textColor),
        actions: [
          TextButton(
            onPressed: () {
              userProvider.clearUnSyncData();
            },
            child: Text("Discard", style: TextStyles.body(context: context, color: themeProvider.textColor)),
          ),
          ElevatedButton(
            onPressed: () async {
              userProvider.pointBox.values.forEach((element) async {
                showDialog(context: context, builder: (context) => SyncLoader(), barrierDismissible: false);
                bool result = await userProvider.syncData(element);
                Navigator.of(context).pop();
                userProvider.clearUnSyncData();
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Success",
                          style: TextStyles.body(context: context, color: themeProvider.accentColor),
                        ),
                        content: Text(
                          "Data saved successfully",
                          style: TextStyles.body(context: context, color: themeProvider.textColor),
                        ),
                      );
                    });
                if (!result) {
                  return;
                } else {
                  userProvider.clearTop();
                }
              });
            },
            child: Text("Sync now", style: TextStyles.body(context: context, color: themeProvider.backgroundColor)),
          ),
        ],
      ),
    );
  }
}
