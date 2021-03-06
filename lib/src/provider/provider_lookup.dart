import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/area.dart';
import 'package:location_tracker/src/model/db/dealer.dart';
import 'package:location_tracker/src/model/db/district.dart';
import 'package:location_tracker/src/model/db/division.dart';
import 'package:location_tracker/src/model/db/thana.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/model/db/zone.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/utils/api.dart';

class LookUpProvider extends ChangeNotifier {
  bool isNetworking = false;

  User user;
  Box<User> userBox;
  Box<District> districtBox;
  Box<Thana> thanaBox;
  Box<Zone> zoneBox;
  Box<Area> areaBox;
  Box<Dealer> dealerBox;
  Box<Division> divisionBox;

  init() {
    if (user == null) {
      userBox = Hive.box("users");
      districtBox = Hive.box("districts");
      thanaBox = Hive.box("thanas");
      zoneBox = Hive.box("zones");
      areaBox = Hive.box("areas");
      dealerBox = Hive.box("dealers");
      divisionBox = Hive.box("divisions");
      if (userBox.length > 0) {
        user = userBox.getAt(0);
      } else {
        user = User();
      }
    }
  }

  List<DropDownItem> get getAllZones {
    List<Zone> zones = zoneBox.values.toList();
    zones.sort((a, b) => a.displayText.compareTo(b.displayText));
    return List.generate(zones.length, (index) => zones[index].toDropDownItem);
  }

  List<DropDownItem> getAllDivision(String zone) {
    List<Division> divisions = divisionBox.values.where((element) => element.parentDataKey == zone.trim()).toList();
    divisions.sort((a, b) => a.displayText.compareTo(b.displayText));
    return List.generate(divisions.length, (index) => divisions[index].toDropDownItem);
  }

  List<DropDownItem> get getAllDistricts {
    List<District> districts = districtBox.values.toList();
    districts.sort((a, b) => a.displayText.compareTo(b.displayText));
    return List.generate(districts.length, (index) => districts[index].toDropDownItem);
  }

  List<DropDownItem> getAllThana(String district) {
    List<Thana> thanas = thanaBox.values.where((element) => element.parentDataKey == district.trim()).toList();
    thanas.sort((a, b) => a.displayText.compareTo(b.displayText));
    return List.generate(thanas.length, (index) => thanas[index].toDropDownItem);
  }

  List<DropDownItem> getAllAreas(String divisions) {
    List<Area> area = areaBox.values.where((element) => element.parentDataKey == divisions.trim()).toList();
    area.sort((a, b) => a.displayText.compareTo(b.displayText));
    return List.generate(area.length, (index) => area[index].toDropDownItem);
  }

  List<DropDownItem> getAllDealer(String dealers) {
    List<Dealer> dealer = dealerBox.values.where((element) => element.parentDataKey == dealers.trim()).toList();
    dealer.sort((a, b) => a.displayText.compareTo(b.displayText));
    return List.generate(dealer.length, (index) => dealer[index].toDropDownItem);
  }

  Future<void> loadLookUp() async {
    init();

    if (isNetworking ||
        districtBox.isNotEmpty ||
        thanaBox.isNotEmpty ||
        zoneBox.isNotEmpty ||
        dealerBox.isNotEmpty ||
        areaBox.isNotEmpty ||
        divisionBox.isNotEmpty)
      return;
    else {
      isNetworking = true;
      notifyListeners();
    }
    Map<String, String> headerParams = {
      "Authorization": user.token,
      "datakey": Api.lookUpKeys,
    };

    Response response = await get(Api.lookUp, headers: headerParams);
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(json.decode(response.body));
      result.forEach((item) {
        if (item["IsActive"] as bool) {
          switch (item["DataKey"]) {
            case "District":
              District district = District.fromJSON(item);
              if (!isDistrictExists(district.dataValue)) {
                districtBox.add(district);
              }
              break;
            case "Thana":
              Thana thana = Thana.fromJSON(item);
              print(thana.dataValue);
              if (!isThanaExists(thana.dataValue)) {
                thanaBox.add(thana);
              }
              break;
            case "Zone":
              Zone zone = Zone.fromJSON(item);
              if (!isZoneExists(zone.dataValue)) {
                zoneBox.add(zone);
              }
              break;
            case "Area":
              Area area = Area.fromJSON(item);
              if (!isAreaExists(area.dataValue)) {
                areaBox.add(area);
              }

              break;
            case "Point":
              Dealer dealer = Dealer.fromJSON(item);
              if (!isDealerExists(dealer.dataValue)) {
                dealerBox.add(dealer);
              }
              break;
            case "Division":
              Division division = Division.fromJSON(item);
              if (!isDivisionExists(division.dataValue)) {
                divisionBox.add(division);
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

  String zoneDisplayText(String value) {
    if (isZoneExists(value)) {
      try {
        return getAllZones.firstWhere((element) => element.value == value).text;
      } catch (error) {
        return "Select one";
      }
    } else {
      return "Select one";
    }
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

  String divisionDisplayText(String value, String zone) {
    if (isDivisionExists(value)) {
      try {
        return getAllDivision(zone).firstWhere((element) => element.value == value).text;
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

  String areaDisplayText(String value, String area) {
    if (isAreaExists(value)) {
      try {
        return getAllAreas(area).firstWhere((element) => element.value == value).text;
      } catch (error) {
        return "Select one";
      }
    } else {
      return "Select one";
    }
  }

  String dealerDisplayText(String value, String dealer) {
    if (isDealerExists(value)) {
      try {
        return getAllDealer(dealer).firstWhere((element) => element.value == value).text;
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

  bool isZoneExists(String value) {
    return zoneBox.values.toList().where((element) => element.dataValue == value).isNotEmpty;
  }

  bool isDivisionExists(String value) {
    return divisionBox.values.toList().where((element) => element.dataValue == value).isNotEmpty;
  }

  bool isAreaExists(String value) {
    return areaBox.values.toList().where((element) => element.dataValue == value).isNotEmpty;
  }

  bool isDealerExists(String value) {
    return dealerBox.values.toList().where((element) => element.dataValue == value).isNotEmpty;
  }

  bool isDistrictExists(String value) {
    return districtBox.values.toList().where((element) => element.dataValue == value).isNotEmpty;
  }

  bool isThanaExists(String value) {
    return thanaBox.values.toList().where((element) => element.dataValue == value).isNotEmpty;
  }
}
