import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/utils/api.dart';

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

    Map<String, String> bodyParams = {
      "UserName": username,
      "Password": password,
    };
    Map<String, String> headerParams = {
      "Content-Type": "application/json",
    };
    Response response = await post(Api.token, body: json.encode(bodyParams), headers: headerParams);
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> result = Map<String, dynamic>.from(json.decode(response.body));
        if (username.contains("@")) {
          user.email = username;
        } else {
          user.username = username;
        }
        user.password = password;
        user.token = "bearer ${result['token']}";
        //user.expiresOn = DateTime.now().millisecondsSinceEpoch + result['expires_in'];
        updateUser();
        notifyListeners();
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
