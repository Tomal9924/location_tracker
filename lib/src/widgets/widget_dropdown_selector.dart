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

  final TextEditingController searchController = TextEditingController();

  List<DropDownItem> list = [];

  @override
  void initState() {
    list = widget.items;
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
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              keyboardType: TextInputType.name,
              style: TextStyles.body(context: context, color: themeProvider.textColor),
              cursorColor: themeProvider.accentColor,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {
                  list = widget.items.where((element) => element.text.toLowerCase().startsWith(value.toLowerCase())).toList();
                });
              },
              decoration: InputDecoration(
                fillColor: themeProvider.secondaryColor,
                filled: true,
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.all(16),
                hintText: "search",
                hintStyle: TextStyles.body(context: context, color: themeProvider.hintColor),
                helperStyle: TextStyles.caption(context: context, color: themeProvider.errorColor),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: ScrollPhysics(),
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final DropDownItem item = list[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      widget.value = item.value;
                    });
                    widget.onSelect(item.value);
                  },
                  title: Text(item.text ?? "-", style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  leading: Icon(
                    widget.value == item.value ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                    color: themeProvider.accentColor,
                  ),
                  dense: false,
                  visualDensity: VisualDensity.comfortable,
                  contentPadding: EdgeInsets.zero,
                );
              },
              itemCount: list.length,
            ),
          ),
        ],
      ),
    );
  }
}
