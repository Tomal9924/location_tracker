import 'package:flutter/material.dart';

enum FormType {
  name,
  phone,
  username,
  email,
  zip,
  password,
}

const String appVersion = "v1.0";
const List<Color> themeColors = [
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.orange,
  Colors.red,
  Colors.pink,
];

const int tableUser = 0;
const int tablePoint = 1;

///------------------------User Table------------------------
final String userId = "id";
final String userGUID = "guid";
final String userName = "name";
final String userEmail = "email";
final String userUsername = "username";
final String userPhone = "phone";
final String userStreet = "street";
final String userCity = "city";
final String userState = "state";
final String userZip = "zip";
final String userProfilePicture = "profilePicture";
final String userCompanyGUID = "companyGUID";
final String userCompanyName = "companyName";
final String userCompanyWebsite = "companyWebsite";
final String userCompanyLogo = "companyLogo";
final String userIsActive = "isActive";
final String userIsDeleted = "isDeleted";
final String userIsAuthenticated = "isAuthenticated";
final String userToken = "token";
final String userPassword = "password";
final String userExpiresOn = "expiresOn";

///-----------------------------------------------------------