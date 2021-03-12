import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:location_tracker/src/provider/provider_auth.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/provider/provider_user.dart';
import 'package:location_tracker/src/routes/route_auth.dart';
import 'package:location_tracker/src/utils/constants.dart';
import 'package:location_tracker/src/utils/form_validator.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:location_tracker/src/widgets/history/widget_user_history.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  final String route = "/home";

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final picker = ImagePicker();
  bool isLoading = true;

  List<File> files = [];
  bool _isChecked = true;
  TextEditingController shopNameController = new TextEditingController();
  TextEditingController ownerNameController = new TextEditingController();
  TextEditingController ownerPhoneController = new TextEditingController();
  TextEditingController thanaController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController routeNameController = new TextEditingController();
  TextEditingController routeDayController = new TextEditingController();
  TextEditingController waltonTVController = new TextEditingController();
  TextEditingController waltonRFController = new TextEditingController();
  TextEditingController visionTVController = new TextEditingController();
  TextEditingController visionRFController = new TextEditingController();
  TextEditingController marcelTVController = new TextEditingController();
  TextEditingController ministerRFController = new TextEditingController();
  TextEditingController monthlySaleTVController = new TextEditingController();
  TextEditingController monthlySaleRFController = new TextEditingController();
  TextEditingController monthlySaleACController = new TextEditingController();
  TextEditingController showRoomSizeController = new TextEditingController();
  TextEditingController displayOutController = new TextEditingController();
  TextEditingController displayInController = new TextEditingController();

  FormValidator shopValidator = FormValidator();
  FormValidator routeNameValidator = FormValidator();
  FormValidator ownerNameValidator = FormValidator();
  FormValidator ownerPhoneValidator = FormValidator();

  @override
  void initState() {
    super.initState();
    Location().requestPermission();
    Location().requestService();
    shopValidator.initialize(
        controller: shopNameController, type: FormType.name);
    routeNameValidator.initialize(
        controller: routeDayController, type: FormType.name);
    ownerNameValidator.initialize(
        controller: ownerNameController, type: FormType.username);
    ownerPhoneValidator.initialize(
        controller: ownerPhoneController, type: FormType.username);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    authProvider.init();
    userProvider.init();
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: themeProvider.backgroundColor,
        elevation: 0,
        title: Text(
          "Location Plotting",
          style: TextStyles.title(
              context: context, color: themeProvider.accentColor),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(UserHistoryWidget().route);
                },
                child: CircleAvatar(
                    backgroundColor: themeProvider.accentColor.withOpacity(.08),
                    child: Icon(
                      Icons.history,
                      color: themeProvider.accentColor,
                    ))),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: InkWell(
                onTap: () {
                  authProvider.logout();
                  Navigator.of(context).pushReplacementNamed(AuthRoute().route);
                },
                child: CircleAvatar(
                    backgroundColor: themeProvider.accentColor.withOpacity(.08),
                    child: Icon(
                      Icons.logout,
                      color: themeProvider.accentColor,
                    ))),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Location().onLocationChanged,
        builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              padding: EdgeInsets.all(16),
              scrollDirection: Axis.vertical,
              children: [
                Text(
                  "Location",
                  style: TextStyles.caption(
                      context: context, color: themeProvider.hintColor),
                ),
                SizedBox(
                  height: 4,
                ),
                //Location TextField--------------
                InkWell(
                  onTap: () {
                    MapsLauncher.launchCoordinates(
                        snapshot.data.latitude, snapshot.data.longitude);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 8),
                    decoration: BoxDecoration(
                        color: themeProvider.secondaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Latitude : " + snapshot.data.latitude.toString(),
                          style: TextStyles.body(
                              context: context, color: themeProvider.textColor),
                        ),
                        Text(
                          "Longitude : " + snapshot.data.longitude.toString(),
                          style: TextStyles.body(
                              context: context, color: themeProvider.textColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                //Route TextField-----------------
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Route Name",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: routeNameController,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              style: TextStyles.body(
                                  context: context,
                                  color: routeNameValidator.isValid
                                      ? themeProvider.textColor
                                      : themeProvider.errorColor),
                              cursorColor: routeNameValidator.isValid
                                  ? themeProvider.textColor
                                  : themeProvider.errorColor,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                if (!routeNameValidator.isValid) {
                                  setState(() {
                                    routeNameValidator.validate();
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Route Day",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: routeDayController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                //Shop TextField----------------
                Text(
                  "Shop Name",
                  style: TextStyles.caption(
                      context: context, color: themeProvider.hintColor),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 48,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                  decoration: BoxDecoration(
                      color: themeProvider.secondaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: shopNameController,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    style: TextStyles.body(
                        context: context, color: themeProvider.textColor),
                    cursorColor: themeProvider.textColor,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(top: 24),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                //Owner TextField----------------
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Owner Name",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: ownerNameController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Owner Phone",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: ownerPhoneController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.phone,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                //isDealer -----------------------
                CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      "Dealer",
                      style: TextStyles.body(
                          context: context, color: themeProvider.textColor),
                    ),
                    value: _isChecked,
                    onChanged: (val) {
                      setState(() {
                        _isChecked = val;
                      });
                    }),
                SizedBox(
                  height: 8,
                ),

                //Thana------------------------
                Text(
                  "Thana",
                  style: TextStyles.caption(
                      context: context, color: themeProvider.hintColor),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 48,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                  decoration: BoxDecoration(
                      color: themeProvider.secondaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: thanaController,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    style: TextStyles.body(
                        context: context, color: themeProvider.textColor),
                    cursorColor: themeProvider.textColor,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(top: 24),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                //City-----------------------
                Text(
                  "City",
                  style: TextStyles.caption(
                      context: context, color: themeProvider.hintColor),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 48,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                  decoration: BoxDecoration(
                      color: themeProvider.secondaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: cityController,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    style: TextStyles.body(
                        context: context, color: themeProvider.textColor),
                    cursorColor: themeProvider.textColor,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(top: 24),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                //District--------------------------
                Text(
                  "District",
                  style: TextStyles.caption(
                      context: context, color: themeProvider.hintColor),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 48,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                  decoration: BoxDecoration(
                      color: themeProvider.secondaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: districtController,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    style: TextStyles.body(
                        context: context, color: themeProvider.textColor),
                    cursorColor: themeProvider.textColor,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(top: 24),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                //Competitor01------------------------
                Text(
                  "Competitor01",
                  style: TextStyles.body(
                      context: context, color: themeProvider.hintColor),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Walton(TV)",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: waltonTVController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Walton(RF)",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: waltonRFController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                //Competitor02---------------------
                Text(
                  "Competitor02",
                  style: TextStyles.body(
                      context: context, color: themeProvider.hintColor),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vision(TV)",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: visionTVController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vision(RF)",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: visionRFController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                //Competitor03----------------------
                Text(
                  "Competitor03",
                  style: TextStyles.body(
                      context: context, color: themeProvider.hintColor),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Marcel(TV)",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: marcelTVController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Minister(RF)",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: ministerRFController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                //Monthly sale ----------------------
                Text(
                  "Monthly Sale",
                  style: TextStyles.body(
                      context: context, color: themeProvider.hintColor),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TV",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.textColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: monthlySaleTVController,
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.top,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                fillColor: themeProvider.accentColor,
                                filled: true,
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 24, minHeight: 24),
                                prefix: Text(
                                  "Tk.",
                                  style: TextStyles.body(
                                      context: context,
                                      color: themeProvider.textColor),
                                  textAlign: TextAlign.center,
                                ),
                                prefixStyle: TextStyles.caption(
                                        context: context,
                                        color: themeProvider.textColor)
                                    .copyWith(fontSize: 8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "RF",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 0, right: 0, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: monthlySaleRFController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixText: "Tk.",
                                prefixStyle: TextStyles.caption(
                                        context: context,
                                        color: themeProvider.textColor)
                                    .copyWith(fontSize: 8),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AC",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 0, right: 0, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: monthlySaleACController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixText: "Tk.",
                                prefixStyle: TextStyles.caption(
                                        context: context,
                                        color: themeProvider.textColor)
                                    .copyWith(fontSize: 8),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //Showroom size----------------------
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Showroom size",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: showRoomSizeController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixText: "SQ.",
                                prefixStyle: TextStyles.caption(
                                        context: context,
                                        color: themeProvider.textColor)
                                    .copyWith(fontSize: 8),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Display(out)",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: displayOutController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Display(in)",
                            style: TextStyles.caption(
                                context: context,
                                color: themeProvider.hintColor),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 48,
                            padding:
                                EdgeInsets.only(left: 16, bottom: 16, top: 8),
                            decoration: BoxDecoration(
                                color: themeProvider.secondaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: displayInController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              style: TextStyles.body(
                                  context: context,
                                  color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.only(top: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //Upload image-------------------------
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload Image",
                      style: TextStyles.caption(
                          context: context, color: themeProvider.hintColor),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 128,
                        decoration: BoxDecoration(
                            color: themeProvider.secondaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          Icons.cloud_upload,
                          size: 64,
                          color: themeProvider.shadowColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                    visible: files.isNotEmpty,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 144,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        padding: EdgeInsets.all(8),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => isLoading
                            ? CircularProgressIndicator()
                            : Container(
                                width: 144,
                                height: 144,
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    border: Border.all(width: .3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Image.file(
                                  files[index],
                                  fit: BoxFit.cover,
                                  width: 144,
                                  height: 144,
                                ),
                              ),
                        itemCount: files.length,
                      ),
                    )),
                Visibility(
                  visible: files.isNotEmpty,
                  child: SizedBox(
                    height: 16,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () async {
                      if (shopNameController.text.toString().isNotEmpty &&
                          districtController.text.toString().isNotEmpty &&
                          cityController.text.toString().isNotEmpty) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                    width: 128,
                                    height: 128,
                                    child: Center(
                                        child: CircularProgressIndicator())),
                              );
                            });
                        var response = await userProvider.uploadSave(
                          context,
                          files,
                          shopNameController.text.toString(),
                          districtController.text.toString(),
                          cityController.text.toString(),
                          _isChecked,
                          snapshot.data.latitude.toString(),
                          snapshot.data.longitude.toString(),
                          routeDayController.text.toString(),
                          routeNameController.text.toString(),
                          ownerNameController.text.toString(),
                          ownerPhoneController.text.toString(),
                          waltonTVController.text.toString(),
                          waltonRFController.text.toString(),
                          visionTVController.text.toString(),
                          visionRFController.text.toString(),
                          marcelTVController.text.toString(),
                          ministerRFController.text.toString(),
                          monthlySaleTVController.text.toString(),
                          monthlySaleRFController.text.toString(),
                          monthlySaleACController.text.toString(),
                          showRoomSizeController.text.toString(),
                          displayOutController.text.toString(),
                          displayInController.text.toString(),
                        );
                        Navigator.of(context).pop();
                        if (response == 500) {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  content: Container(
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    width: 300,
                                    child: Text(
                                      "Something went wrong",
                                      style: TextStyles.body(
                                          context: context, color: Colors.red),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          shopNameController.text = "";
                          ownerNameController.text = "";
                          ownerPhoneController.text = "";
                          thanaController.text = "";
                          cityController.text = "";
                          districtController.text = "";
                          routeNameController.text = "";
                          routeDayController.text = "";
                          waltonTVController.text = "";
                          waltonRFController.text = "";
                          visionTVController.text = "";
                          visionRFController.text = "";
                          marcelTVController.text = "";
                          ministerRFController.text = "";
                          monthlySaleTVController.text = "";
                          monthlySaleRFController.text = "";
                          monthlySaleACController.text = "";
                          showRoomSizeController.text = "";
                          displayOutController.text = "";
                          displayInController.text = "";
                          _isChecked = false;
                          files = [];
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return AlertDialog(
                                  content: Container(
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    width: 300,
                                    child: Text(
                                      "Data saved successfully",
                                      style: TextStyles.body(
                                          context: context,
                                          color: Colors.green),
                                    ),
                                  ),
                                );
                              });
                        }
                      } else {
                        return showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  width: 300,
                                  child: Text(
                                    "Fill up the form",
                                    style: TextStyles.body(
                                        context: context,
                                        color: themeProvider.errorColor),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    child: Text(
                      "Save".toUpperCase(),
                      style: TextStyles.body(
                          context: context, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        files.add(File(pickedFile.path));
        isLoading = false;
      } else {
        print('No image selected.');
      }
    });
  }
}
