import 'package:flutter/material.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DropDownSelector extends StatefulWidget {
  String value;
  final String title;
  final List<DropDownItem> items;
  final Function(String) onSelect;

  DropDownSelector({@required this.value, @required this.title, @required this.items, @required this.onSelect});

  @override
  _DropDownSelectorState createState() => _DropDownSelectorState();
}

class _DropDownSelectorState extends State<DropDownSelector> {
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
      ),
      body: ListView.builder(
        physics: ScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final DropDownItem item = widget.items[index];
          return ListTile(
            onTap: () {
              setState(() {
                widget.value = item.value;
              });
              widget.onSelect(item.value);
            },
            title: Text(item.text, style: TextStyles.body(context: context, color: themeProvider.textColor)),
            leading: Icon(
              widget.value == item.value ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              color: themeProvider.accentColor,
            ),
          );
        },
        itemCount: widget.items.length,
      ),
    );
  }
}
