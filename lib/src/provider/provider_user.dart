import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/competitor.dart';
import 'package:location_tracker/src/model/db/floating_point.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/utils/api.dart';

class UserProvider extends ChangeNotifier {
  User user;
  Box<User> userBox;
  Box<FloatingPoint> pointBox;
  Box<Competitor> competitorBox;
  bool isNetworking = false;
  bool isNetworkingCompetitors = false;

  init() {
    if (user == null) {
      userBox = Hive.box("users");
      competitorBox = Hive.box("competitors");
      if (userBox.length > 0) {
        user = userBox.getAt(0);
      } else {
        user = User();
      }
    }

    pointBox = Hive.box("floating_points");
  }

  List<DropDownItem> getAllCompetitors(String competitor1, String competitor2, String competitor3) {
    List<Competitor> list = competitorBox.values.toList();
    list.removeWhere((element) => element.competitorId == competitor1 || element.competitorId == competitor2 || element.competitorId == competitor3);
    return List.generate(list.length, (index) => list[index].toDropDownItem);
  }

  Future<void> loadCompetitors() async {
    init();
    try {
      if (isNetworkingCompetitors || competitorBox.isNotEmpty)
        return;
      else {
        isNetworkingCompetitors = true;
        notifyListeners();
      }
      var headers = {"Authorization": user.token};

      Response response = await get(Api.getCompetitors, headers: headers);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(json.decode(response.body));
        result.forEach((element) {
          Competitor competitor = Competitor.fromJSON(element);
          if (!isCompetitorExists(competitor.competitorId)) {
            competitorBox.add(competitor);
          }
        });
      }
      isNetworkingCompetitors = false;
      notifyListeners();
      return;
    } catch (error) {
      print(error);
    }
  }

  Future<StreamedResponse> saveOnline(FloatingPoint point, List<File> files) async {
    try {
      var headers = {
        "Authorization": user.token,
      };

      var request = MultipartRequest(
        'POST',
        Uri.parse(Api.saveData),
      );
      request.fields.addAll({
        "Lat": point.lat.toString(),
        "Lng": point.lng.toString(),
        "UserId": user.guid,
        "Zone": point.zone.trim(),
        "Area": point.area.trim(),
        "PointName": point.point.trim(),
        "District": point.district.trim(),
        "Thana": point.thana.trim(),
        "CityVillage": point.city.trim(),
        "RouteName": point.routeName.toString().trim(),
        "RouteDay": point.routeDay.trim(),
        "LocationType": point.isDealer.trim(),
        "ShopType": point.shopSubType.trim(),
        "RegisteredName": point.registeredName.toString().trim(),
        "ShopName": point.shopName.trim(),
        "OwnerName": point.ownerName.trim(),
        "OwnerPhone": point.ownerPhone.trim(),
        "MonthlySaleTv": point.monthlySaleTv.trim(),
        "MonthlySaleRf": point.monthlySaleRf.trim(),
        "MonthlySaleAc": point.monthlySaleAc.trim(),
        "ShowroomSize": point.showroomSize.trim(),
        "ListLocationPointCompetitor": json.encode(json.decode(point.competitorList)),
        "Comment": point.comment.toString().trim(),
        "Division": point.division.trim(),
      });
      for (var file in files) {
        request.files.add(
          await MultipartFile.fromPath("ListFiles", file.path),
        );
      }

      request.headers.addAll(Map<String, String>.from(headers));

      StreamedResponse response = await request.send();
      //var response = await request.send();
      return response;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> syncData(FloatingPoint point) async {
    try {
      var headers = {
        "Authorization": user.token,
        "Lat": point.lat.toString(),
        "Lng": point.lng.toString(),
        "UserId": user.guid,
        "Zone": point.zone.trim(),
        "Area": point.area.trim(),
        "PointName": point.point.trim(),
        "District": point.district.trim(),
        "Thana": point.thana.trim(),
        "CityVillage": point.city.trim(),
        "RouteName": point.routeName.toString().trim(),
        "RouteDay": point.routeDay.trim(),
        "LocationType": point.isDealer.trim(),
        "ShopType": point.shopSubType.trim(),
        "RegisteredName": point.registeredName.toString().trim(),
        "ShopName": point.shopName.trim(),
        "OwnerName": point.ownerName.trim(),
        "OwnerPhone": point.ownerPhone.trim(),
        "MonthlySaleTv": point.monthlySaleTv.trim(),
        "MonthlySaleRf": point.monthlySaleRf.trim(),
        "MonthlySaleAc": point.monthlySaleAc.trim(),
        "ShowroomSize": point.showroomSize.trim(),
        "CompetitorList": json.encode(json.decode(point.competitorList.trim())),
        "Comment": point.comment.toString().trim(),
        "Division": point.division.trim(),
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

  Future<bool> saveOffline(FloatingPoint point) async {
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

  bool isCompetitorExists(String value) {
    return competitorBox.values.toList().where((element) => element.competitorId == value).isNotEmpty;
  }

  String displayText(String value) {
    if (isCompetitorExists(value)) {
      try {
        return competitorBox.values.toList().firstWhere((element) => element.competitorId == value).name;
      } catch (error) {
        return "Select one";
      }
    } else {
      return "Select one";
    }
  }
}
