import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/utils/api.dart';

class LookUpProvider extends ChangeNotifier {
  Map<String, List<DropDownItem>> items = HashMap<String, List<DropDownItem>>();
  Map<String, bool> hasCalled = HashMap<String, bool>();

  bool isNetworking = false;

  User user;
  Box<User> userBox;

  init() {
    if (user == null) {
      userBox = Hive.box("users");
      if (userBox.length > 0) {
        user = userBox.getAt(0);
      } else {
        user = User();
      }
    }
  }

  List<DropDownItem> getAll(String keyword) {
    return items[keyword].toList();
  }

  bool isExists(String key) => items.containsKey(key);

  bool hasData(String key) => !hasCalled.containsKey(key) || hasCalled[key];

  Future<void> loadLookUp(String key) async {
    init();

    if (isNetworking || !hasData(key))
      return;
    else {
      isNetworking = true;
      notifyListeners();
    }
    Map<String, String> headerParams = {
      "Authorization": user.token,
      "key": key,
    };

    Response response = await get(Api.lookUp, headers: headerParams);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = Map<String, dynamic>.from(json.decode(response.body));
      List<DropDownItem> list = [];
      result["data"].forEach((item) {
        if (item["IsActive"] as bool) {
          list.add(DropDownItem.fromJSONLookUp(item));
        }
      });
      items[key] = list;
      hasCalled[key] = list.isNotEmpty;
    }
    isNetworking = false;
    notifyListeners();
    return;
  }

  String displayText(String key, String value) {
    if (isExists(key)) {
      try {
        return getAll(key).firstWhere((element) => element.value == value).text;
      } catch (error) {
        return "Select one";
      }
    } else {
      return "Select one";
    }
  }

  void destroy() {
    isNetworking = false;
    items = {};
    notifyListeners();
  }
}
