import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/point.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/utils/api.dart';

class UserProvider extends ChangeNotifier {
  User user;
  Box<User> userBox;
  Box<Point> pointBox;

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

  Future<int> saveOnline(Point point, List<File> files) async {
    try {
      var headers = {
        "Authorization": user.token,
        "UserId": user.guid,
        "District": point.district,
        "City": point.city,
        "Name": point.routeName,
        "Lat": point.lat.toString(),
        "Lng": point.lng.toString(),
        "IsDealer": point.isDealer.toString(),
        "RouteDay": point.routeDay,
        "ShopName": point.shopName,
        "OwnerName": point.ownerName,
        "OwnerPhone": point.ownerPhone,
        "Competitor1TvWalton": point.competitor1TvWalton,
        "Competitor1RfWalton": point.competitor1RfWalton,
        "Competitor2TvVision": point.competitor2TvVision,
        "Competitor2RfVision": point.competitor2RfVision,
        "Competitor3TvMarcel": point.competitor3TvMarcel,
        "Competitor3RfMinister": point.competitor3RfMinister,
        "MonthlySaleTv": point.monthlySaleTv,
        "MonthlySaleRf": point.monthlySaleRf,
        "MonthlySaleAc": point.monthlySaleAc,
        "ShowroomSize": point.showroomSize,
        "DisplayOut": point.displayOut,
        "DisplayIn": point.displayIn,
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
        "District": point.district,
        "City": point.city,
        "Name": point.routeName,
        "Lat": point.lat.toString(),
        "Lng": point.lng.toString(),
        "IsDealer": point.isDealer.toString(),
        "RouteDay": point.routeDay,
        "ShopName": point.shopName,
        "OwnerName": point.ownerName,
        "OwnerPhone": point.ownerPhone,
        "Competitor1TvWalton": point.competitor1TvWalton,
        "Competitor1RfWalton": point.competitor1RfWalton,
        "Competitor2TvVision": point.competitor2TvVision,
        "Competitor2RfVision": point.competitor2RfVision,
        "Competitor3TvMarcel": point.competitor3TvMarcel,
        "Competitor3RfMinister": point.competitor3RfMinister,
        "MonthlySaleTv": point.monthlySaleTv,
        "MonthlySaleRf": point.monthlySaleRf,
        "MonthlySaleAc": point.monthlySaleAc,
        "ShowroomSize": point.showroomSize,
        "DisplayOut": point.displayOut,
        "DisplayIn": point.displayIn,
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
