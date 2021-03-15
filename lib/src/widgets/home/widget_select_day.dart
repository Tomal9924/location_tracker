import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider_theme.dart';
import '../../utils/text_styles.dart';

class SelectDays extends StatefulWidget {
  final Function(String) onSelect;
  final String value;

  SelectDays({@required this.onSelect, @required this.value});

  @override
  _SelectDaysState createState() => _SelectDaysState();
}

class _SelectDaysState extends State<SelectDays> {
  final List<String> days = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
  String value = "";

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.backgroundColor,
        brightness: Brightness.light,
        elevation: 0,
        title: Text("Select route days", style: TextStyles.title(context: context, color: themeProvider.accentColor)),
        automaticallyImplyLeading: true,
      ),
      body: ListView.builder(
        physics: ScrollPhysics(),
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return CheckboxListTile(
              value: value.split(", ").contains(days[index]),
              onChanged: (flag) {
                if (flag) {
                  String newValue = "${widget.value}, ${days[index]}";
                  newValue = newValue.startsWith(", ") ? newValue.substring(2) : newValue;
                  setState(() {
                    value = newValue;
                  });
                  widget.onSelect(newValue);
                } else {
                  String newValue = widget.value.replaceAll(days[index], "");
                  newValue = newValue.startsWith(", ") ? newValue.substring(2) : newValue;
                  newValue = newValue.endsWith(", ") ? newValue.substring(0, newValue.length - 2) : newValue;
                  setState(() {
                    value = newValue;
                  });
                  widget.onSelect(newValue);
                }
              },
            title: Text(days[index], style: TextStyles.body(context: context, color: themeProvider.textColor)),
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
        itemCount: days.length,
      ),
    );
  }
}
