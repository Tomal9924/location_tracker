import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:location_tracker/src/model/db/model/user_history.dart';
import 'package:location_tracker/src/model/db/user.dart';

class UserHistoryProvider extends ChangeNotifier {
  Map<String, UserHistory> items = HashMap<String, UserHistory>();

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

  List<UserHistory> getAll() {
    List<UserHistory> list = items.values.toList();
    list.sort((a, b) => a.shopName.compareTo(b.shopName));
    return list;
  }

  void destroy() {
    isNetworking = false;
    items = {};
    notifyListeners();
  }
}
