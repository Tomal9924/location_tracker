import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/utils/api.dart';

class UserProvider extends ChangeNotifier {
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

  Future<int> uploadSave(
    BuildContext context,
    List<File> filesList,
    String routeName,
    String district,
    String city,
    bool isDealer,
    String lat,
    String lng,
    String routeDay,
    String shopName,
    String ownerName,
    String ownerPhone,
    String competitor1TvWalton,
    String competitor1RfWalton,
    String Competitor2TvVision,
    String Competitor2RfVision,
    String Competitor3TvMarcel,
    String Competitor3RfMinister,
    String MonthlySaleTv,
    String MonthlySaleRf,
    String MonthlySaleAc,
    String ShowroomSize,
    String DisplayOut,
    String DisplayIn,
  ) async {
    try {
      var headers = {
        "Authorization": user.token,
        "UserId": user.guid,
        "District": district,
        "City": city,
        "Name": routeName,
        "Lat": lat,
        "Lng": lng,
        "IsDealer": isDealer.toString(),
        "RouteDay": routeDay,
        "ShopName": shopName,
        "OwnerName": ownerName,
        "OwnerPhone": ownerPhone,
        "Competitor1TvWalton": competitor1TvWalton,
        "Competitor1RfWalton": competitor1RfWalton,
        "Competitor2TvVision": Competitor2TvVision,
        "Competitor2RfVision": Competitor2RfVision,
        "Competitor3TvMarcel": Competitor3TvMarcel,
        "Competitor3RfMinister": Competitor3RfMinister,
        "MonthlySaleTv": MonthlySaleTv,
        "MonthlySaleRf": MonthlySaleRf,
        "MonthlySaleAc": MonthlySaleAc,
        "ShowroomSize": ShowroomSize,
        "DisplayOut": DisplayOut,
        "DisplayIn": DisplayIn,
      };

      var request = MultipartRequest(
        'POST',
        Uri.parse(Api.saveData),
      );
      for (var file in filesList) {
        request.files.add(
          await MultipartFile.fromPath(
              "${DateTime.now().millisecondsSinceEpoch}.png", file.path),
        );
      }

      request.headers.addAll(Map<String, String>.from(headers));

      var response = await request.send();
      final result = await response.stream.bytesToString();
      //user.photo = json.decode(result)["data"]["profileImage"];
      return response.statusCode;
    } catch (error) {
      return 500;
    }
  }
}
