import 'package:flutter/material.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:location_tracker/src/widgets/history/widget_user_items.dart';
import 'package:provider/provider.dart';

class UserHistoryWidget extends StatelessWidget {
  final String route = "/user_history";
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.backgroundColor,
        elevation: 0,
        brightness: Brightness.light,
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text(
          "User History",
          style: TextStyles.title(
              context: context, color: themeProvider.accentColor),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) => UserHistoryItems(),
        itemCount: 10,
      ),
    );
  }
}
