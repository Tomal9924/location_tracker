import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:location_tracker/src/model/db/point.dart';
import 'package:location_tracker/src/provider/provider_auth.dart';
import 'package:location_tracker/src/provider/provider_internet.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/provider/provider_user.dart';
import 'package:location_tracker/src/routes/route_auth.dart';
import 'package:location_tracker/src/routes/route_history.dart';
import 'package:location_tracker/src/utils/constants.dart';
import 'package:location_tracker/src/utils/form_validator.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:location_tracker/src/widgets/home/widget_sync_now.dart';
import 'package:location_tracker/src/widgets/widget_multi_select_dropdown.dart';
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
  String routeDay = "";

  List<File> files = [];
  bool isDealer = false;
  TextEditingController shopNameController = new TextEditingController();
  TextEditingController ownerNameController = new TextEditingController();
  TextEditingController ownerPhoneController = new TextEditingController();
  TextEditingController thanaController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController routeNameController = new TextEditingController();
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
  FormValidator cityValidator = FormValidator();
  FormValidator districtValidator = FormValidator();

  FocusNode shopNameFocusNode = FocusNode();
  FocusNode routeNameFocusNode = FocusNode();
  FocusNode ownerNameFocusNode = FocusNode();
  FocusNode ownerPhoneFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode districtFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Location().requestPermission();
    Location().requestService();
    shopValidator.initialize(controller: shopNameController, type: FormType.name);
    routeNameValidator.initialize(controller: routeNameController, type: FormType.name);
    ownerNameValidator.initialize(controller: ownerNameController, type: FormType.name);
    ownerPhoneValidator.initialize(controller: ownerPhoneController, type: FormType.name);
    cityValidator.initialize(controller: ownerPhoneController, type: FormType.name);
    districtValidator.initialize(controller: ownerPhoneController, type: FormType.name);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final internetProvider = Provider.of<InternetProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    authProvider.init();
    userProvider.init();
    internetProvider.listen();
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: themeProvider.backgroundColor,
        elevation: 0,
        title: Text(
          "Location Plotting",
          style: TextStyles.title(context: context, color: themeProvider.accentColor),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(HistoryRoute().route);
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
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      scrollDirection: Axis.vertical,
                      children: [
                        Visibility(
                          child: SyncData(),
                          visible: internetProvider.connected && userProvider.unSyncDataLength > 0,
                        ),
                        Visibility(child: SizedBox(height: 16), visible: internetProvider.connected && userProvider.unSyncDataLength > 0),
                        Text("Location", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                        SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ListTile(
                            tileColor: themeProvider.secondaryColor,
                            leading: Icon(Icons.location_on_outlined),
                            title: Text("${snapshot.data.latitude}, ${snapshot.data.longitude}", style: TextStyles.body(context: context, color: themeProvider.hintColor)),
                            onTap: () {
                              MapsLauncher.launchCoordinates(snapshot.data.latitude, snapshot.data.longitude);
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Route Name *", style: TextStyles.caption(context: context, color: routeNameValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(height: 4),
                        TextField(
                          controller: routeNameController,
                          focusNode: routeNameFocusNode,
                          keyboardType: TextInputType.text,
                          style: TextStyles.body(context: context, color: routeNameValidator.isValid ? themeProvider.textColor : themeProvider.errorColor),
                          cursorColor: routeNameValidator.isValid ? themeProvider.textColor : themeProvider.errorColor,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (!routeNameValidator.isValid) {
                              setState(() {
                                routeNameValidator.validate();
                              });
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: themeProvider.secondaryColor,
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                            contentPadding: EdgeInsets.all(16),
                            helperText: routeNameValidator.validationMessage,
                            helperStyle: TextStyles.caption(context: context, color: themeProvider.errorColor),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Route Day", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                        SizedBox(height: 4),
                        DropDownMultiSelectMenu(
                            values: routeDay.split(", "),
                            text: routeDay,
                            title: "Select route day",
                            onSelect: (items) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                routeDay = items.join(", ");
                                routeDay = routeDay.startsWith(", ") ? routeDay.substring(2) : routeDay;
                                print(routeDay);
                              });
                            }),
                        SizedBox(height: 16),
                        Text("Shop Name *", style: TextStyles.caption(context: context, color: shopValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(height: 4),
                        TextField(
                          controller: shopNameController,
                          focusNode: shopNameFocusNode,
                          keyboardType: TextInputType.text,
                          style: TextStyles.body(context: context, color: shopValidator.isValid ? themeProvider.textColor : themeProvider.errorColor),
                          cursorColor: shopValidator.isValid ? themeProvider.textColor : themeProvider.errorColor,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (!shopValidator.isValid) {
                              setState(() {
                                shopValidator.validate();
                              });
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: themeProvider.secondaryColor,
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                            contentPadding: EdgeInsets.all(16),
                            helperText: shopValidator.validationMessage,
                            helperStyle: TextStyles.caption(context: context, color: themeProvider.errorColor),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Owner Name *", style: TextStyles.caption(context: context, color: shopValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(height: 4),
                        TextField(
                          controller: ownerNameController,
                          focusNode: ownerNameFocusNode,
                          keyboardType: TextInputType.text,
                          style: TextStyles.body(context: context, color: ownerNameValidator.isValid ? themeProvider.textColor : themeProvider.errorColor),
                          cursorColor: ownerNameValidator.isValid ? themeProvider.textColor : themeProvider.errorColor,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (!ownerNameValidator.isValid) {
                              setState(() {
                                ownerNameValidator.validate();
                              });
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: themeProvider.secondaryColor,
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                            contentPadding: EdgeInsets.all(16),
                            helperText: ownerNameValidator.validationMessage,
                            helperStyle: TextStyles.caption(context: context, color: themeProvider.errorColor),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Owner Phone *", style: TextStyles.caption(context: context, color: ownerPhoneValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(height: 4),
                        TextField(
                          controller: ownerPhoneController,
                          focusNode: ownerPhoneFocusNode,
                          keyboardType: TextInputType.phone,
                          style: TextStyles.body(context: context, color: ownerPhoneValidator.isValid ? themeProvider.textColor : themeProvider.errorColor),
                          cursorColor: ownerPhoneValidator.isValid ? themeProvider.textColor : themeProvider.errorColor,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (!ownerPhoneValidator.isValid) {
                              setState(() {
                                ownerPhoneValidator.validate();
                              });
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: themeProvider.secondaryColor,
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                            contentPadding: EdgeInsets.all(16),
                            helperText: ownerPhoneValidator.validationMessage,
                            helperStyle: TextStyles.caption(context: context, color: themeProvider.errorColor),
                          ),
                        ),
                        //isDealer -----------------------
                        CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              "Dealer",
                              style: TextStyles.body(context: context, color: themeProvider.textColor),
                            ),
                            value: isDealer,
                            onChanged: (val) {
                              setState(() {
                                isDealer = val;
                              });
                            }),
                        SizedBox(
                          height: 8,
                        ),

                        //Thana------------------------
                        Text(
                          "Thana",
                          style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          height: 48,
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                          decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                          child: TextField(
                            controller: thanaController,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            style: TextStyles.body(context: context, color: themeProvider.textColor),
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
                        SizedBox(height: 16),
                        Text("City *", style: TextStyles.caption(context: context, color: cityValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(height: 4),
                        TextField(
                          controller: cityController,
                          focusNode: cityFocusNode,
                          keyboardType: TextInputType.name,
                          style: TextStyles.body(context: context, color: cityValidator.isValid ? themeProvider.textColor : themeProvider.errorColor),
                          cursorColor: cityValidator.isValid ? themeProvider.textColor : themeProvider.errorColor,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (!cityValidator.isValid) {
                              setState(() {
                                cityValidator.validate();
                              });
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: themeProvider.secondaryColor,
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                            contentPadding: EdgeInsets.all(16),
                            helperText: cityValidator.validationMessage,
                            helperStyle: TextStyles.caption(context: context, color: themeProvider.errorColor),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("District *", style: TextStyles.caption(context: context, color: districtValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(height: 4),
                        TextField(
                          controller: districtController,
                          focusNode: districtFocusNode,
                          keyboardType: TextInputType.name,
                          style: TextStyles.body(context: context, color: districtValidator.isValid ? themeProvider.textColor : themeProvider.errorColor),
                          cursorColor: districtValidator.isValid ? themeProvider.textColor : themeProvider.errorColor,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (!districtValidator.isValid) {
                              setState(() {
                                districtValidator.validate();
                              });
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: themeProvider.secondaryColor,
                            filled: true,
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                            contentPadding: EdgeInsets.all(16),
                            helperText: districtValidator.validationMessage,
                            helperStyle: TextStyles.caption(context: context, color: themeProvider.errorColor),
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          "Competitor01",
                          style: TextStyles.body(context: context, color: themeProvider.hintColor),
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
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                                    decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                    child: TextField(
                                      controller: waltonTVController,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyles.body(context: context, color: themeProvider.textColor),
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
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                                    decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                    child: TextField(
                                      controller: waltonRFController,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyles.body(context: context, color: themeProvider.textColor),
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
                        SizedBox(height: 16),
                        //Competitor02---------------------
                        Text(
                          "Competitor02",
                          style: TextStyles.body(context: context, color: themeProvider.hintColor),
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
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                                    decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                    child: TextField(
                                      controller: visionTVController,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyles.body(context: context, color: themeProvider.textColor),
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
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                                    decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                    child: TextField(
                                      controller: visionRFController,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyles.body(context: context, color: themeProvider.textColor),
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
                        SizedBox(height: 16),
                        //Competitor03----------------------
                        Text(
                          "Competitor03",
                          style: TextStyles.body(context: context, color: themeProvider.hintColor),
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
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                                    decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                    child: TextField(
                                      controller: marcelTVController,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyles.body(context: context, color: themeProvider.textColor),
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
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                                    decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                    child: TextField(
                                      controller: ministerRFController,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyles.body(context: context, color: themeProvider.textColor),
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
                        SizedBox(height: 8),
                        Divider(),
                        SizedBox(height: 8),
                        Text("Monthly Sale", style: TextStyles.body(context: context, color: themeProvider.hintColor)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("TV", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: monthlySaleTVController,
                                keyboardType: TextInputType.number,
                                style: TextStyles.body(context: context, color: themeProvider.textColor),
                                cursorColor: themeProvider.textColor,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  setState(() {
                                    monthlySaleTVController.text = formatCurrency(monthlySaleTVController.text);
                                    monthlySaleTVController.selection = TextSelection.fromPosition(TextPosition(offset: monthlySaleTVController.text.length));
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor: themeProvider.secondaryColor,
                                  filled: true,
                                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                                  prefixIcon: Text(
                                    "TK",
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  prefixIconConstraints: BoxConstraints(maxWidth: 36, minWidth: 36),
                                  contentPadding: EdgeInsets.only(right: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("RF", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: monthlySaleRFController,
                                keyboardType: TextInputType.number,
                                style: TextStyles.body(context: context, color: themeProvider.textColor),
                                cursorColor: themeProvider.textColor,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  setState(() {
                                    monthlySaleRFController.text = formatCurrency(monthlySaleRFController.text);
                                    monthlySaleRFController.selection = TextSelection.fromPosition(TextPosition(offset: monthlySaleRFController.text.length));
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor: themeProvider.secondaryColor,
                                  filled: true,
                                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                                  prefixIcon: Text(
                                    "TK",
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  prefixIconConstraints: BoxConstraints(maxWidth: 36, minWidth: 36),
                                  contentPadding: EdgeInsets.only(right: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text("AC", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: monthlySaleACController,
                                keyboardType: TextInputType.number,
                                style: TextStyles.body(context: context, color: themeProvider.textColor),
                                cursorColor: themeProvider.textColor,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  setState(() {
                                    monthlySaleACController.text = formatCurrency(monthlySaleACController.text);
                                    monthlySaleACController.selection = TextSelection.fromPosition(TextPosition(offset: monthlySaleACController.text.length));
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor: themeProvider.secondaryColor,
                                  filled: true,
                                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                                  prefixIcon: Text(
                                    "TK",
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  prefixIconConstraints: BoxConstraints(maxWidth: 36, minWidth: 36),
                                  contentPadding: EdgeInsets.only(right: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
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
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  TextField(
                                    controller: showRoomSizeController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyles.body(context: context, color: themeProvider.textColor),
                                    cursorColor: themeProvider.textColor,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      fillColor: themeProvider.secondaryColor,
                                      filled: true,
                                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                                      prefixIcon: Text(
                                        "SQ",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                        textAlign: TextAlign.center,
                                      ),
                                      prefixIconConstraints: BoxConstraints(maxWidth: 36, minWidth: 36),
                                      contentPadding: EdgeInsets.only(right: 12),
                                    ),
                                  ),
                                ],
                              ),
                              flex: 4,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Display(out)",
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                                    decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                    child: TextField(
                                      controller: displayOutController,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyles.body(context: context, color: themeProvider.textColor),
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
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Display(in)",
                                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 48,
                                    padding: EdgeInsets.only(left: 16, bottom: 16, top: 8),
                                    decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                    child: TextField(
                                      controller: displayInController,
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyles.body(context: context, color: themeProvider.textColor),
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
                        SizedBox(height: 16),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Upload Image", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                            SizedBox(height: 4),
                            InkWell(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 128,
                                decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 64,
                                  color: themeProvider.shadowColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
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
                                        decoration: BoxDecoration(border: Border.all(width: .3), borderRadius: BorderRadius.circular(8)),
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
                          child: SizedBox(height: 16),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(),
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                routeNameValidator.validate();
                                shopValidator.validate();
                                ownerNameValidator.validate();
                                ownerPhoneValidator.validate();
                                cityValidator.validate();
                                districtValidator.validate();
                              });

                              if (routeNameValidator.isValid &&
                                  shopValidator.isValid &&
                                  ownerNameValidator.isValid &&
                                  ownerPhoneValidator.isValid &&
                                  cityValidator.isValid &&
                                  districtValidator.isValid) {
                                Point point = Point(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  routeName: routeNameController.text,
                                  routeDay: routeDay,
                                  shopName: shopNameController.text,
                                  ownerName: ownerNameController.text,
                                  ownerPhone: ownerPhoneController.text,
                                  isDealer: isDealer,
                                  city: cityController.text,
                                  district: districtController.text,
                                  competitor1TvWalton: waltonTVController.text.toString(),
                                  competitor1RfWalton: waltonRFController.text.toString(),
                                  competitor2TvVision: visionTVController.text.toString(),
                                  competitor2RfVision: visionRFController.text.toString(),
                                  competitor3TvMarcel: marcelTVController.text.toString(),
                                  competitor3RfMinister: ministerRFController.text.toString(),
                                  monthlySaleTv: monthlySaleTVController.text.toString(),
                                  monthlySaleRf: monthlySaleRFController.text.toString(),
                                  monthlySaleAc: monthlySaleACController.text.toString(),
                                  showroomSize: showRoomSizeController.text.toString(),
                                  displayOut: displayOutController.text.toString(),
                                  displayIn: displayInController.text.toString(),
                                  lat: snapshot.data.latitude,
                                  lng: snapshot.data.longitude,
                                  files: "",
                                );
                                if (internetProvider.connected) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Container(width: 128, height: 128, child: Center(child: CircularProgressIndicator())),
                                        );
                                      });
                                  var response = await userProvider.saveOnline(point, files);
                                  Navigator.of(context).pop();
                                  if (response == 500) {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Container(
                                              decoration: BoxDecoration(color: Colors.white),
                                              width: 300,
                                              child: Text(
                                                "Something went wrong",
                                                style: TextStyles.body(context: context, color: Colors.red),
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Success",
                                              style: TextStyles.body(context: context, color: themeProvider.accentColor),
                                            ),
                                            content: Text(
                                              "Data saved successfully",
                                              style: TextStyles.body(context: context, color: themeProvider.textColor),
                                            ),
                                          );
                                        });
                                  }
                                } else {
                                  String filePaths = List.generate(files.length, (index) => files[index].path).join(",");
                                  point.files = filePaths;
                                  bool result = await userProvider.saveOffline(point);
                                  if (result) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Success", style: TextStyles.subTitle(context: context, color: themeProvider.accentColor)),
                                              content: Text("You've saves '${point.shopName}' in offline mode. Please sync the activity once internet is available",
                                                  style: TextStyles.body(context: context, color: themeProvider.textColor)),
                                            ));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Error", style: TextStyles.subTitle(context: context, color: themeProvider.accentColor)),
                                          content: Text("Failed to save data while offline",
                                              style: TextStyles.body(context: context, color: themeProvider.textColor)),
                                        ));
                                  }
                                }

                                shopNameController.text = "";
                                ownerNameController.text = "";
                                ownerPhoneController.text = "";
                                thanaController.text = "";
                                cityController.text = "";
                                districtController.text = "";
                                routeNameController.text = "";
                                routeDay = "";
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
                                isDealer = false;
                                files = [];
                              } else {
                                if (routeNameValidator.isValid) {
                                  FocusScope.of(context).requestFocus(routeNameFocusNode);
                                } else if (shopValidator.isValid) {
                                  FocusScope.of(context).requestFocus(shopNameFocusNode);
                                } else if (ownerNameValidator.isValid) {
                                  FocusScope.of(context).requestFocus(ownerNameFocusNode);
                                } else if (ownerPhoneValidator.isValid) {
                                  FocusScope.of(context).requestFocus(ownerPhoneFocusNode);
                                } else if (cityValidator.isValid) {
                                  FocusScope.of(context).requestFocus(cityFocusNode);
                                } else if (districtValidator.isValid) {
                                  FocusScope.of(context).requestFocus(districtFocusNode);
                                }
                              }
                            },
                            child: Text(
                              "Save".toUpperCase(),
                              style: TextStyles.body(context: context, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: internetProvider.connected ? 0 : 42,
                  ),
                  Visibility(
                    visible: internetProvider.notConnected,
                    child: Positioned(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("No internet", style: TextStyles.caption(context: context, color: Colors.red)),
                      ),
                      bottom: 0,
                      right: 0,
                      left: 0,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, maxWidth: 512, maxHeight: 512, imageQuality: 80);

    setState(() {
      if (pickedFile != null) {
        files.add(File(pickedFile.path));
        isLoading = false;
      } else {
        print('No image selected.');
      }
    });
  }

  String formatCurrency(String value) {
    String actualString = value.replaceAll(',', '');
    if (actualString.length > 3) {
      String resultLastPart = actualString.substring(actualString.length - 3, actualString.length);
      String resultFirstPart = actualString.length.isEven ? "${actualString.substring(0, 1)}," : '';
      String resultMiddlePart = '';
      String middlePart = actualString.length.isEven ? actualString.substring(1, actualString.length - 3) : actualString.substring(0, actualString.length - 3);
      if (middlePart.isNotEmpty) {
        for (int i = 0; i < middlePart.length ~/ 2; i++) {
          resultMiddlePart = "$resultMiddlePart${middlePart.substring(i * 2, (i * 2) + 2)},";
        }
      }
      return "$resultFirstPart$resultMiddlePart$resultLastPart";
    } else {
      return actualString;
    }
  }
}
