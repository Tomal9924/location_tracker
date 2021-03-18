import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/district.dart';
import 'package:location_tracker/src/model/db/thana.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/utils/api.dart';

class LookUpProvider extends ChangeNotifier {

  bool isNetworking = false;

  User user;
  Box<User> userBox;
  Box<District> districtBox;
  Box<Thana> thanaBox;

  init() {
    if (user == null) {
      userBox = Hive.box("users");
      districtBox = Hive.box("districts");
      thanaBox = Hive.box("thanas");
      if (userBox.length > 0) {
        user = userBox.getAt(0);
      } else {
        user = User();
      }
    }
  }

  List<DropDownItem> get getAllDistricts {
    List<District> districts = districtBox.values.toList();
    districts.sort((a,b)=>a.displayText.compareTo(b.displayText));
    return List.generate(districts.length, (index) => districts[index].toDropDownItem);
  }

  List<DropDownItem> getAllThana(String district) {
    List<Thana> thanas = thanaBox.values.where((element) => element.parentDataKey==district).toList();
    thanas.sort((a,b)=>a.displayText.compareTo(b.displayText));
    return List.generate(thanas.length, (index) => thanas[index].toDropDownItem);
  }

  Future<void> loadLookUp() async {
    init();

    if (isNetworking || districtBox.isNotEmpty || thanaBox.isNotEmpty)
      return;
    else {
      isNetworking = true;
      notifyListeners();
    }
    Map<String, String> headerParams = {
      "Authorization": user.token,
      "key": Api.lookUpKeys,
    };

    Response response = await get(Api.lookUp, headers: headerParams);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = Map<String, dynamic>.from(json.decode(response.body));
      result["data"].forEach((item) {
        if (item["IsActive"] as bool) {
          switch(item["DataKey"]) {
            case "District":
              District district = District.fromJSON(item);
              if(!isDistrictExists(district.dataValue)) {
                districtBox.add(district);
              }
              break;
            case "Thana":
              Thana thana = Thana.fromJSON(item);
              if(!isThanaExists(thana.dataValue)) {
                thanaBox.add(thana);
              }
              break;
          }
        }
      });
    }
    isNetworking = false;
    notifyListeners();
    return;
  }

  String districtDisplayText(String value) {
    if (isDistrictExists(value)) {
      try {
        return getAllDistricts.firstWhere((element) => element.value == value).text;
      } catch (error) {
        return "Select one";
      }
    } else {
      return "Select one";
    }
  }

  String thanaDisplayText(String value, String district) {
    if (isThanaExists(value)) {
      try {
        return getAllThana(district).firstWhere((element) => element.value == value).text;
      } catch (error) {
        return "Select one";
      }
    } else {
      return "Select one";
    }
  }

  void destroy() {
    isNetworking = false;
    notifyListeners();
  }

  bool isDistrictExists(String value) {
    return districtBox.values.toList().where((element) => element.dataValue==value).isNotEmpty;
  }

  bool isThanaExists(String value) {
    return thanaBox.values.toList().where((element) => element.dataValue==value).isNotEmpty;
  }
}
