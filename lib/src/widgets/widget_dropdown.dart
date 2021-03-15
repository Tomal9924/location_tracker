import 'package:flutter/material.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:location_tracker/src/widgets/widget_dropdown_selector.dart';
import 'package:provider/provider.dart';

class DropDownMenu extends StatelessWidget {
  final String value;
  final String title;
  final String text;
  final List<DropDownItem> items;
  final Function(String) onSelect;

  DropDownMenu({@required this.value, @required this.text, @required this.title, @required this.items, @required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextButton(
      style: ButtonStyle(visualDensity: VisualDensity.compact),
      child: Container(
        child: Text(text, style: TextStyles.body(context: context, color: themeProvider.textColor), textAlign: TextAlign.start),
        width: MediaQuery.of(context).size.width,
        height: 54,
        padding: EdgeInsets.symmetric(horizontal: 8),
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
                    items: items,
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
