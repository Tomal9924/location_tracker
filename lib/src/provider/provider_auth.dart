import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/utils/api.dart';
import 'package:location_tracker/src/utils/constants.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AuthProvider extends ChangeNotifier {
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

  Future<Response> authenticate(String username, String password) async {
    init();

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String model = "";
    String brand = "";
    String version = "";
    final SmsAutoFill _autoFill = SmsAutoFill();
    final phone = await _autoFill.hint ?? "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
      brand = androidInfo.manufacturer;
      version = androidInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      model = iosInfo.model;
      brand = "Apple";
      version = iosInfo.utsname.release;
    }

    Map<String, String> bodyParams = {
      "UserName": username.trim(),
      "Password": password.trim(),
      "Model": model.trim(),
      "Brand": brand.trim(),
      "MAC": version,
      "IMEI": appVersion,
      "PhoneNumber": phone.trim(),
    };

    Response response = await post(Api.token, headers: headers, body: json.encode(bodyParams));
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> result = Map<String, dynamic>.from(json.decode(response.body));
        if (result["StatusCode"] == 200) {
          if (username.contains("@")) {
            user.email = username;
          } else {
            user.username = username;
          }
          user.password = password;
          user.phone = phone;
          user.token = "bearer ${result['token']}";
          user = User.fromAuth(result["UserInfo"], user);
          updateUser();
          notifyListeners();
        } else {
          return response;
        }
        break;
      default:
        user.isAuthenticated = false;
        notifyListeners();
        break;
    }
    return response;
  }

  Future<Response> userInfo() async {
    Map<String, String> headerParams = {
      "Authorization": user.token,
      "username": user.username,
    };

    Response response = await get(Api.userInfo, headers: headerParams);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> result = Map<String, dynamic>.from(json.decode(response.body));
        user = User.fromAuth(result, user);
        updateUser();
        notifyListeners();
        break;
      default:
        user.isAuthenticated = false;
        updateUser();
        notifyListeners();
        break;
    }
    return response;
  }

  updateUser() {
    if (userBox.isEmpty) {
      userBox.add(user);
    } else {
      userBox.putAt(0, user);
    }
  }

  logout() {
    user.isAuthenticated = false;
    updateUser();
    notifyListeners();
  }
}
