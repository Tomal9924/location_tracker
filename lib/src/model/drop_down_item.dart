import 'package:flutter/material.dart';

class DropDownItem {
  String text;
  String value;

  DropDownItem({@required this.text, @required this.value});

  DropDownItem.fromLookUp(Map<String, dynamic> map) {
    text = map["DisplayText"];
    value = map["DataValue"];
  }

  DropDownItem.fromUserJSON(Map<String, dynamic> map) {
    text = map["Name"];
    value = map["UserId"];
  }

  DropDownItem.fromJSONInvoice(Map<String, dynamic> map) {
    text = map["InvoiceId"];
    value = map["InvoiceId"];
  }
}
