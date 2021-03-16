import 'package:flutter/material.dart';

class DropDownItem {
  String text;
  String value;

  DropDownItem({@required this.text, @required this.value});

  DropDownItem.fromJSON(Map<String, dynamic> map) {
    text = map["Name"];
    value = map["CompetitorId"];
  }
  DropDownItem.fromJSONLookUp(Map<String, dynamic> map) {
    text = map["DisplayText"];
    value = map["Id"].toString();
  }
}
