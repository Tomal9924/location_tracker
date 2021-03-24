import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/model/floating_point.dart';
import 'package:location_tracker/src/model/floating_point_details.dart';
import 'package:location_tracker/src/utils/api.dart';

class FloatingPointProvider extends ChangeNotifier {
  Map<String, FloatingPoint> items = HashMap<String, FloatingPoint>();
  Map<int, FloatingPointDetails> itemDetails = HashMap<int, FloatingPointDetails>();

  bool isNetworking = false;
  bool isDetailsNetworking = false;
  bool isPaginating = false;
  User user;
  Box<User> userBox;

  int pageNo = 0;
  int totalSize = -1;
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
    list.sort((a, b) => b.id.compareTo(a.id));
    return list;
  }

  FloatingPointDetails findById(int id) => itemDetails[id];

  bool isExists(int id) => itemDetails.containsKey(id);

  Future<void> loadFloatingPoints() async {
    if (isNetworking) {
      return;
    } else {
      pageNo = 1;
      isNetworking = true;
      notifyListeners();
    }
    Map<String, String> headers = {
      "Authorization": user.token,
      "pageno": "1",
      "pagesize": "50",
    };

    Response response = await get(Api.locationPoints, headers: headers);
    items = {};
    if (response.statusCode == 200) {
      items = {};
      totalSize = json.decode(response.body)["Default"][0]["TotalCount"] as int;
      List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(json.decode(response.body)["Default1"]);
      list.forEach((element) {
        FloatingPoint point = FloatingPoint.fromJSON(element);
        items[point.guid] = point;
      });
      isNetworking = false;
      notifyListeners();
    }
    return response.statusCode;
  }

  void paginate() async {
    if (getAll().length < totalSize) {
      if (!isPaginating) {
        isPaginating = true;
        notifyListeners();
        Map<String, String> headers = {
          "authorization": user.token,
          "pageno": (++pageNo).toString(),
          "pagesize": "50",
        };

        Response response = await get(Api.locationPoints, headers: headers);
        if (response.statusCode == 200) {
          List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(json.decode(response.body)["Default1"]);
          list.forEach((element) {
            FloatingPoint point = FloatingPoint.fromJSON(element);
            items[point.guid] = point;
          });
          isPaginating = false;
          notifyListeners();
        }
      }
    }
  }

  Future<void> loadDetails(int id) async {
    try {
      if (isDetailsNetworking) {
        return;
      } else {
        isDetailsNetworking = true;
        notifyListeners();
      }
      Map<String, String> headers = {
        "Id": id.toString(),
        "Authorization": user.token,
      };

      Response response = await get(Api.locationPointsDetails, headers: headers);
      if (response.statusCode == 200) {
        FloatingPointDetails item = FloatingPointDetails.fromJSON(json.decode(response.body));

        itemDetails[item.id] = item;
      }
      isDetailsNetworking = false;
      notifyListeners();
      return response.statusCode;
    } catch (error) {
      print(error);
    }
  }

  void destroy() {
    isNetworking = false;
    user = null;
    items = {};
    notifyListeners();
  }
}
