import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/model/floating_point.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/utils/api.dart';

class FloatingPointProvider extends ChangeNotifier {
  Map<String, FloatingPoint> items = HashMap<String, FloatingPoint>();

  bool isNetworking = false;
  bool hasCalled = false;
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

  List<FloatingPoint> getAll() {
    List<FloatingPoint> list = items.values.toList();
    return list;
  }

  Future<void> loadFloatingPoints() async {
    Map<String, String> headers = {
      "authorization": user.token,
      "userId": user.guid,
    };

    Response response = await get(Api.floatingPoints, headers: headers);
    if (response.statusCode == 200) {
      // List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(json.decode());
    }
  }

  void destroy() {
    isNetworking = false;
    items = {};
    notifyListeners();
  }
}
