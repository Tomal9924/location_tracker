import 'package:flutter/material.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:provider/provider.dart';

import '../provider/provider_theme.dart';
import '../utils/text_styles.dart';

class DropDownMultiSelectSelector extends StatefulWidget {
  final List<String> values;
  final String title;
  final List<DropDownItem> items;
  final Function(List<String>) onSelect;

  DropDownMultiSelectSelector({@required this.values, @required this.title, @required this.items, @required this.onSelect});

  @override
  _DropDownMultiSelectSelectorState createState() => _DropDownMultiSelectSelectorState();
}

class _DropDownMultiSelectSelectorState extends State<DropDownMultiSelectSelector> {
  List<DropDownItem> list = [];
  List<String> selections = [];

  @override
  void initState() {
    list = widget.items;
    selections = widget.values;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.title, style: TextStyles.title(context: context, color: themeProvider.accentColor)),
        backgroundColor: themeProvider.backgroundColor,
        centerTitle: false,
        brightness: Brightness.light,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.check, color: themeProvider.accentColor),
              onPressed: () {
                widget.onSelect(selections);
                Navigator.of(context).pop();
              })
        ],
      ),
      body: ListView.builder(
        physics: ScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final DropDownItem item = list[index];
          return CheckboxListTile(
            value: selections.contains(item.value),
            onChanged: (flag) {
              setState(() {
                if (flag) {
                  selections.add(item.value);
                } else {
                  selections.remove(item.value);
                }
              });
            },
            title: Text(item.text, style: TextStyles.body(context: context, color: themeProvider.textColor)),
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
