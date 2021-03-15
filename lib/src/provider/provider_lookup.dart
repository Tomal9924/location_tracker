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
      "authorization":
          "bearer VAjBXw1iT1lsxlTaQuYp1K9_ErciOLto6ofeNRMWwnCiSlFl44xxcV19Dk7-cluXUEDMuUhItTCv70n5XRIdbSvFX-lmbWWlaNvcHKyQhcy5YN9hkGaCFm42_GZBzGRXOQd41KyV7Vlyi84krWcBDtGSWYQtfR_sAumy8VD5bE9dvX4IarxgrUGrsJST6558HxaQGsHmyxXQO3r2UN2Rz2mkdeXQhPeb4guXRsqMpI4uJJhsm4m2hfcN9zPG2WUGTO2rHCMoBcFZJHJ-4HYA9wN5ZY1xevMKI1WlmJLj4KOUyuaMQWKXWzI7B0oUxTD8ICif-Ur0mKJSRJKMrwfEn2TJBTEaHlX7JF215dqP1eRucenaGxLUykAL0FctoUENh2MEfYyqHeaicj_5-qebvJ8qTzrm18DofLkamdOc5Eoh4IfP9sxolrCMo2tqhsv8CmUE55nLUWTYnT9SRDiXhIwBjT1bfCYt5wssbfxAG9g",
      "key": key,
    };

    Response response = await get(Api.lookUp, headers: headerParams);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = Map<String, dynamic>.from(json.decode(response.body));
      List<DropDownItem> list = [];
      result["model"].forEach((item) {
        if (item["IsActive"] as bool) {
          list.add(DropDownItem.fromLookUp(item));
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
