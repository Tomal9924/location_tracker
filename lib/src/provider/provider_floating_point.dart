import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/floating_point.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/model/floating_point_details.dart';
import 'package:location_tracker/src/utils/api.dart';

class FloatingPointProvider extends ChangeNotifier {
  Map<String, FloatingPoint> items = HashMap<String, FloatingPoint>();
  Map<String, FloatingPointDetails> itemDetails = HashMap<String, FloatingPointDetails>();

  bool isNetworking = false;
  bool isDetailsNetworking = false;
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

  FloatingPointDetails findById(String guid) => itemDetails[guid];

  bool isExists(String guid) => itemDetails.containsKey(guid);

  Future<void> loadFloatingPoints() async {
    if (isNetworking) {
      return;
    } else {
      isNetworking = true;
      notifyListeners();
    }
    Map<String, String> headers = {
      "authorization": user.token,
      "userId": user.guid,
    };

    Response response = await get(Api.floatingPoints, headers: headers);
    items = {};
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(json.decode(response.body)["fpList"]);
      list.forEach((element) {
        FloatingPoint point = FloatingPoint.fromJSON(element);
        items[point.guid] = point;
      });
      isNetworking = false;
      notifyListeners();
    }
    hasCalled = true;
    return response.statusCode;
  }

  Future<void> loadDetails(String guid) async {
    if (isDetailsNetworking) {
      return;
    } else {
      isDetailsNetworking = true;
      notifyListeners();
    }
    Map<String, String> headers = {
      "authorization": user.token,
      "floatingPointId": guid,
    };

    Response response = await get(Api.floatingPointsDetails, headers: headers);
    if (response.statusCode == 200) {
      FloatingPointDetails item = FloatingPointDetails.fromJSON(json.decode(response.body));

      itemDetails[item.guid] = item;
    }
    isDetailsNetworking = false;
    notifyListeners();
    return response.statusCode;
  }

  void destroy() {
    isNetworking = false;
    hasCalled = false;
    user = null;
    items = {};
    notifyListeners();
  }
}
