import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/point.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/utils/api.dart';

class UserProvider extends ChangeNotifier {
  User user;
  Box<User> userBox;
  Box<Point> pointBox;
  Map<String, DropDownItem> competitors = HashMap();
  bool isNetworking = false;
  bool isNetworkingCompetitors = false;

  init() {
    if (user == null) {
      userBox = Hive.box("users");
      if (userBox.length > 0) {
        user = userBox.getAt(0);
      } else {
        user = User();
      }
    }

    pointBox = Hive.box("points");
  }

  List<DropDownItem> getAllCompetitors(String guid) {
    List<DropDownItem> list = competitors.values.toList();
    list.removeWhere((element) => element.value == guid);
    return list;
  }

  Future<void> loadCompetitors() async {
    init();
    try {
      if (isNetworkingCompetitors)
        return;
      else {
        isNetworkingCompetitors = true;
        notifyListeners();
      }
      var headers = {"authorization": user.token};

      Response response = await get(Api.getCompetitors, headers: headers);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(json.decode(response.body)["cmpList"]);
        result.forEach((element) {
          DropDownItem dropDownItem = DropDownItem.fromJSON(element);
          competitors[dropDownItem.value] = dropDownItem;
        });
      }
      isNetworkingCompetitors = false;
      notifyListeners();
      return;
    } catch (error) {
      print(error);
    }
  }

  Future<int> saveOnline(Point point, List<File> files) async {
    try {
      var headers = {
        "Authorization": user.token,
        "UserId": user.guid,
        "PointName": point.pointName.toString(),
        "RouteDay": point.routeDay,
        "District": point.district,
        "Thana": point.thana,
        "CityVillage": point.city,
        "Lat": point.lat.toString(),
        "Lng": point.lng.toString(),
        "LocationType": point.isDealer.toString(),
        "ShopType": point.shopSubType.toString(),
        "RegisteredName": point.registeredName.toString(),
        "ShopName": point.shopName,
        "OwnerName": point.ownerName,
        "OwnerPhone": point.ownerPhone,
        "MonthlySaleTv": point.monthlySaleTv,
        "MonthlySaleRf": point.monthlySaleRf,
        "MonthlySaleAc": point.monthlySaleAc,
        "ShowroomSize": point.showroomSize,
        "CompetitorList": point.competitorList,
      };

      var request = MultipartRequest(
        'POST',
        Uri.parse(Api.saveData),
      );
      for (var file in files) {
        request.files.add(
          await MultipartFile.fromPath("${DateTime.now().millisecondsSinceEpoch}.png", file.path),
        );
      }

      request.headers.addAll(Map<String, String>.from(headers));

      var response = await request.send();
      await response.stream.bytesToString();
      return response.statusCode;
    } catch (error) {
      print(error);
      return 500;
    }
  }

  Future<bool> syncData(Point point) async {
    try {
      var headers = {
        "Authorization": user.token,
        "UserId": user.guid,
        "PointName": point.pointName.toString(),
        "RouteDay": point.routeDay,
        "District": point.district,
        "Thana": point.thana,
        "CityVillage": point.city,
        "Lat": point.lat.toString(),
        "Lng": point.lng.toString(),
        "LocationType": point.isDealer.toString(),
        "ShopType": point.shopSubType.toString(),
        "RegisteredName": point.registeredName.toString(),
        "ShopName": point.shopName,
        "OwnerName": point.ownerName,
        "OwnerPhone": point.ownerPhone,
        "MonthlySaleTv": point.monthlySaleTv,
        "MonthlySaleRf": point.monthlySaleRf,
        "MonthlySaleAc": point.monthlySaleAc,
        "ShowroomSize": point.showroomSize,
        "CompetitorList": point.competitorList,
      };

      var request = MultipartRequest(
        'POST',
        Uri.parse(Api.saveData),
      );
      if (point.files.isNotEmpty) {
        for (String path in point.files.split(",")) {
          if (path.isNotEmpty) {
            request.files.add(
              await MultipartFile.fromPath("${DateTime.now().millisecondsSinceEpoch}.png", path),
            );
          }
        }
      }

      request.headers.addAll(Map<String, String>.from(headers));

      var response = await request.send();
      final result = await response.stream.bytesToString();
      return response.statusCode == 200;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveOffline(Point point) async {
    try {
      if (pointBox == null) {
        init();
      }
      pointBox.add(point);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  int get unSyncDataLength {
    if (pointBox == null) {
      init();
    }
    return pointBox.length;
  }

  void clearUnSyncData() {
    if (pointBox == null) {
      init();
    }

    while (pointBox.isNotEmpty) {
      pointBox.deleteAt(0);
    }
    notifyListeners();
  }

  void clearTop() {
    if (pointBox.isNotEmpty) {
      pointBox.deleteAt(0);
    }
    notifyListeners();
  }
}
