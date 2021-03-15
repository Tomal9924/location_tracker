import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location_tracker/src/provider/provider_lookup.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:location_tracker/src/widgets/widget_dropdown_selector.dart';
import 'package:provider/provider.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String value;
  final String title;
  final String text;
  final String keyword;
  final Function(String) onSelect;

  CustomDropDownMenu({@required this.value, @required this.text, @required this.title, @required this.keyword, @required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final lookUpProvider = Provider.of<LookUpProvider>(context);

    Future.delayed(Duration(milliseconds: 1), () {
      lookUpProvider.init();
      if (!lookUpProvider.isNetworking && !lookUpProvider.isExists(keyword)) {
        lookUpProvider.loadLookUp(keyword);
      }
    });

    final Random random = Random();

    return lookUpProvider.isNetworking
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 54,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: themeProvider.secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              width: 112 + random.nextInt(112).toDouble(),
              height: 12,
              decoration: BoxDecoration(
                color: themeProvider.backgroundColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          )
        : TextButton(
            style: ButtonStyle(visualDensity: VisualDensity.compact),
            child: Container(
              child: Text(text, style: TextStyles.body(context: context, color: themeProvider.textColor), textAlign: TextAlign.start),
              width: MediaQuery.of(context).size.width,
              height: 54,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: themeProvider.secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.centerLeft,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => DropDownSelector(
                          value: value,
                          title: title,
                          items: lookUpProvider.getAll(keyword),
                          onSelect: (value) {
                            onSelect(value);
                          },
                        ),
                    fullscreenDialog: true),
              );
            },
          );
  }
}
