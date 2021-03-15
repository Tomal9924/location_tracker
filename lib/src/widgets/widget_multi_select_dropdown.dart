import 'package:flutter/material.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/widgets/widget_multi_select_dropdown_selector.dart';
import 'package:provider/provider.dart';

import '../provider/provider_theme.dart';
import '../utils/text_styles.dart';

class DropDownMultiSelectMenu extends StatelessWidget {
  final List<String> values;
  final String title;
  final String text;
  final Function(List<String>) onSelect;

  DropDownMultiSelectMenu({@required this.values, @required this.text, @required this.title,@required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextButton(
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
              builder: (context) => DropDownMultiSelectSelector(
                    values: values,
                    title: title,
                    items: [
                      DropDownItem(text: "Saturday", value: "Sat"),
                      DropDownItem(text: "Sunday", value: "Sun"),
                      DropDownItem(text: "Monday", value: "Mon"),
                      DropDownItem(text: "Tuesday", value: "Tue"),
                      DropDownItem(text: "Wednesday", value: "Wed"),
                      DropDownItem(text: "Thursday", value: "Thu"),
                      DropDownItem(text: "Friday", value: "Fri"),
                    ],
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
