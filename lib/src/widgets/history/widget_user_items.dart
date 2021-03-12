import 'package:flutter/material.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:provider/provider.dart';

class UserHistoryItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: themeProvider.hintColor.withOpacity(.05),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      height: 128,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 8),
            visualDensity: VisualDensity.compact,
            leading: Icon(Icons.shop),
            title: Text(
              "Shop Name",
              style: TextStyles.body(
                  context: context, color: themeProvider.textColor),
            ),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 8),
            visualDensity: VisualDensity.compact,
            leading: Icon(Icons.location_on),
            title: Text(
              "Tongi,Dhaka",
              style: TextStyles.body(
                context: context,
                color: themeProvider.textColor,
              ),
            ),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 8),
            visualDensity: VisualDensity.compact,
            leading: Icon(Icons.location_on),
            title: Text("23.45556566, 90.123123123",
                style: TextStyles.body(
                    context: context, color: themeProvider.textColor)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
