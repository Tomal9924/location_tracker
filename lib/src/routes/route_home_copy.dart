import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:location_tracker/src/model/db/floating_point.dart';
import 'package:location_tracker/src/model/drop_down_item.dart';
import 'package:location_tracker/src/provider/provider_auth.dart';
import 'package:location_tracker/src/provider/provider_internet.dart';
import 'package:location_tracker/src/provider/provider_lookup.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/provider/provider_user.dart';
import 'package:location_tracker/src/routes/route_auth.dart';
import 'package:location_tracker/src/routes/route_history.dart';
import 'package:location_tracker/src/utils/constants.dart';
import 'package:location_tracker/src/utils/form_validator.dart';
import 'package:location_tracker/src/utils/helper.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:location_tracker/src/widgets/home/widget_sync_now.dart';
import 'package:location_tracker/src/widgets/widget_dropdown.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

class HomeRouteCopy extends StatefulWidget {
  final String route = "/home_copy";

  @override
  _HomeRouteCopyState createState() => _HomeRouteCopyState();
}

class _HomeRouteCopyState extends State<HomeRouteCopy> {
  final picker = ImagePicker();
  bool isLoading = true;

  String routeDay = "";
  String district = "";
  String thana = "";
  String zone = "";
  String area = "";
  String dealer = "";
  List<File> files = [];
  String isDealer = "";
  List<DropDownItem> dealerTypes = [
    DropDownItem(text: "Dealer", value: "Dealer"),
    DropDownItem(text: "Sub-Dealer", value: "Sub-Dealer"),
    DropDownItem(text: "Shop", value: "Shop"),
  ];
  List<DropDownItem> shopType = [
    DropDownItem(text: "Registered", value: "Registered"),
    DropDownItem(text: "Cash Retailer", value: "Cash Retailer"),
    DropDownItem(text: "Adhoc", value: "Adhoc"),
    DropDownItem(text: "Not Application", value: "Not Application"),
  ];
  List<DropDownItem> routeDays = [
    DropDownItem(text: "Saturday", value: "Saturday"),
    DropDownItem(text: "Sunday", value: "Sunday"),
    DropDownItem(text: "Monday", value: "Monday"),
    DropDownItem(text: "Tuesday", value: "Tuesday"),
    DropDownItem(text: "Wednesday", value: "Wednesday"),
    DropDownItem(text: "Thursday", value: "Thursday"),
    DropDownItem(text: "Friday", value: "Friday"),
  ];
  String competitor1GUID = "";
  String competitor2GUID = "";
  String competitor3GUID = "";
  String shopTypes = "";
  String distributorName = "";

  TextEditingController cityVillageController = new TextEditingController();
  TextEditingController routeNameController = new TextEditingController();
  TextEditingController distributorNameController = new TextEditingController();
  TextEditingController registrationController = new TextEditingController();
  TextEditingController ownerNameController = new TextEditingController();
  TextEditingController ownerPhoneController = new TextEditingController();
  TextEditingController competitor1TVController = new TextEditingController();
  TextEditingController competitor1RFController = new TextEditingController();
  TextEditingController competitor1ACController = new TextEditingController();
  TextEditingController competitor2TVController = new TextEditingController();
  TextEditingController competitor2RFController = new TextEditingController();
  TextEditingController competitor2ACController = new TextEditingController();
  TextEditingController competitor3TVController = new TextEditingController();
  TextEditingController competitor3RFController = new TextEditingController();
  TextEditingController competitor3ACController = new TextEditingController();
  TextEditingController monthlySaleTVController = new TextEditingController();
  TextEditingController monthlySaleRFController = new TextEditingController();
  TextEditingController monthlySaleACController = new TextEditingController();
  TextEditingController showRoomSizeController = new TextEditingController();

  FormValidator cityValidator = FormValidator();
  FormValidator registrationValidator = FormValidator();
  FormValidator distributorValidator = FormValidator();
  FormValidator routeNameValidator = FormValidator();
  FormValidator ownerNameValidator = FormValidator();
  FormValidator ownerPhoneValidator = FormValidator();

  @override
  void initState() {
    super.initState();
    Location().requestPermission();
    Location().requestService();
    cityValidator.initialize(controller: cityVillageController, type: FormType.name);
    registrationValidator.initialize(controller: registrationController, type: FormType.name);
    distributorValidator.initialize(controller: distributorNameController, type: FormType.name);
    routeNameValidator.initialize(controller: routeNameController, type: FormType.name);
    ownerNameValidator.initialize(controller: ownerNameController, type: FormType.name);
    ownerPhoneValidator.initialize(controller: ownerPhoneController, type: FormType.name);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final internetProvider = Provider.of<InternetProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final lookUpProvider = Provider.of<LookUpProvider>(context);
    authProvider.init();
    userProvider.init();
    internetProvider.listen();
    lookUpProvider.init();
    Future.delayed(Duration.zero, () {
      if (!userProvider.isNetworkingCompetitors && userProvider.competitorBox.isEmpty) {
        userProvider.loadCompetitors();
      }
      if (!lookUpProvider.isNetworking &&
          lookUpProvider.districtBox.isEmpty &&
          lookUpProvider.thanaBox.isEmpty &&
          lookUpProvider.zoneBox.isEmpty &&
          lookUpProvider.areaBox.isEmpty &&
          lookUpProvider.dealerBox.isEmpty) {
        lookUpProvider.loadLookUp();
      }
    });
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: themeProvider.backgroundColor,
        elevation: 0,
        title: Text(
          "JEAL Plotting",
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
                ),
              ),
            ),
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
                        Text("Zone *",
                            style: TextStyles.caption(context: context, color: district.isNotEmpty ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(
                          height: 4,
                        ),
                        lookUpProvider.isNetworking
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 54,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: themeProvider.secondaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 256,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: themeProvider.backgroundColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              )
                            : DropDownMenu(
                                onSelect: (value) {
                                  setState(() {
                                    zone = value;
                                  });
                                },
                                items: lookUpProvider.getAllZones,
                                value: zone,
                                text: lookUpProvider.zoneDisplayText(zone),
                                title: "Choose a Zone",
                              ),
                        SizedBox(height: 8),
                        Visibility(
                          visible: district.isNotEmpty,
                          child: Text("Area *",
                              style: TextStyles.caption(context: context, color: thana.isNotEmpty ? themeProvider.hintColor : themeProvider.errorColor)),
                        ),
                        Visibility(
                          visible: district.isNotEmpty,
                          child: SizedBox(
                            height: 4,
                          ),
                        ),
                        Visibility(
                          visible: zone.isNotEmpty,
                          child: DropDownMenu(
                            onSelect: (value) {
                              setState(() {
                                area = value;
                              });
                            },
                            value: area,
                            items: lookUpProvider.getAllAreas(zone),
                            text: lookUpProvider.areaDisplayText(area, zone),
                            title: "Choose a Area",
                          ),
                        ),
                        SizedBox(height: 8),
                        Visibility(
                          visible: district.isNotEmpty,
                          child: Text("Dealer *",
                              style: TextStyles.caption(context: context, color: thana.isNotEmpty ? themeProvider.hintColor : themeProvider.errorColor)),
                        ),
                        Visibility(
                          visible: district.isNotEmpty,
                          child: SizedBox(
                            height: 4,
                          ),
                        ),
                        Visibility(
                          visible: area.isNotEmpty,
                          child: DropDownMenu(
                            onSelect: (value) {
                              setState(() {
                                dealer = value;
                              });
                            },
                            value: dealer,
                            items: lookUpProvider.getAllDealer(dealer),
                            text: lookUpProvider.areaDisplayText(dealer, area),
                            title: "Choose a Dealer",
                          ),
                        ),
                        SizedBox(height: 8),
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
                        SizedBox(height: 8),
                        Divider(),
                        SizedBox(height: 8),
                        Text("District *", style: TextStyles.caption(context: context, color: district.isNotEmpty ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(
                          height: 4,
                        ),
                        lookUpProvider.isNetworking
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 54,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: themeProvider.secondaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 256,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: themeProvider.backgroundColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              )
                            : DropDownMenu(
                                onSelect: (value) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  setState(() {
                                    district = value;
                                  });
                                },
                                items: lookUpProvider.getAllDistricts,
                                value: district,
                                text: lookUpProvider.districtDisplayText(district),
                                title: "Choose a District",
                              ),
                        SizedBox(height: 8),
                        Visibility(
                          visible: district.isNotEmpty,
                          child: Text("Thana *", style: TextStyles.caption(context: context, color: thana.isNotEmpty ? themeProvider.hintColor : themeProvider.errorColor)),
                        ),
                        Visibility(
                          visible: district.isNotEmpty,
                          child: SizedBox(
                            height: 4,
                          ),
                        ),
                        Visibility(
                          visible: district.isNotEmpty,
                          child: DropDownMenu(
                            onSelect: (value) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                thana = value;
                              });
                            },
                            value: thana,
                            items: lookUpProvider.getAllThana(district),
                            text: lookUpProvider.thanaDisplayText(thana, district),
                            title: "Choose a Thana",
                          ),
                        ),
                        SizedBox(height: 8),
                        //city---------------------------
                        Text("City/village *", style: TextStyles.caption(context: context, color: cityValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(height: 4),
                        TextField(
                          controller: cityVillageController,
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

                        //Route name and day------------
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Route name *",
                                      style: TextStyles.caption(context: context, color: routeNameValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  TextField(
                                    controller: routeNameController,
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
                                  Text("Day*", style: TextStyles.caption(context: context, color: routeDay.isNotEmpty ? themeProvider.hintColor : themeProvider.errorColor)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  DropDownMenu(
                                      value: routeDay,
                                      text: routeDay,
                                      items: routeDays,
                                      title: "Select route day",
                                      onSelect: (item) {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        setState(() {
                                          routeDay = item;
                                        });
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        //Shop name-------------------
                        Text("Dealer/Sub-dealer/Shop",
                            style: TextStyles.caption(context: context, color: distributorName.isNotEmpty ? themeProvider.hintColor : themeProvider.errorColor)),

                        SizedBox(height: 4),
                        DropDownMenu(
                            items: dealerTypes,
                            value: distributorName,
                            onSelect: (value) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                distributorName = value;
                              });
                            },
                            title: 'Choose brands',
                            text: distributorName.isEmpty ? "Select one" : dealerTypes.firstWhere((element) => element.value == distributorName).text),
                        Visibility(
                          visible: distributorName == "Shop",
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            child: DropDownMenu(
                              items: shopType,
                              value: shopTypes,
                              onSelect: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  shopTypes = value;
                                });
                              },
                              title: 'Choose brands',
                              text: shopTypes.isEmpty ? "Select one" : shopType.firstWhere((element) => element.value == shopTypes).text,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: distributorName == "Shop" && shopTypes == "Registered",
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            child: TextField(
                              controller: registrationController,
                              keyboardType: TextInputType.text,
                              style: TextStyles.body(context: context, color: registrationValidator.isValid ? themeProvider.textColor : themeProvider.errorColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: "registered from...",
                                hintStyle:
                                    TextStyles.caption(context: context, color: registrationValidator.isValid ? themeProvider.hintColor.withOpacity(.5) : themeProvider.errorColor),
                                fillColor: themeProvider.secondaryColor,
                                filled: true,
                                helperText: registrationValidator.validationMessage,
                                helperStyle:
                                    TextStyles.caption(context: context, color: registrationValidator.isValid ? themeProvider.hintColor.withOpacity(.5) : themeProvider.errorColor),
                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                                prefixIconConstraints: BoxConstraints(maxWidth: 36, minWidth: 36),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ),

                        Visibility(visible: distributorName.isNotEmpty, child: SizedBox(height: 16)),
                        Visibility(
                          visible: distributorName.isNotEmpty,
                          child: Text("$distributorName Name *",
                              style: TextStyles.caption(context: context, color: distributorValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        ),
                        Visibility(visible: distributorName.isNotEmpty, child: SizedBox(height: 4)),
                        Visibility(
                          visible: distributorName.isNotEmpty,
                          child: TextField(
                            controller: distributorNameController,
                            keyboardType: TextInputType.text,
                            style: TextStyles.body(context: context, color: distributorValidator.isValid ? themeProvider.textColor : themeProvider.errorColor),
                            cursorColor: distributorValidator.isValid ? themeProvider.textColor : themeProvider.errorColor,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              if (!distributorValidator.isValid) {
                                setState(() {
                                  distributorValidator.validate();
                                });
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: themeProvider.secondaryColor,
                              filled: true,
                              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                              contentPadding: EdgeInsets.all(16),
                              helperText: distributorValidator.validationMessage,
                              helperStyle: TextStyles.caption(context: context, color: themeProvider.errorColor),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        //owner name-------------------
                        Text("Owner Name *", style: TextStyles.caption(context: context, color: ownerNameValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(height: 4),
                        TextField(
                          controller: ownerNameController,
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
                        //owner name-------------------
                        Text("Owner Phone *", style: TextStyles.caption(context: context, color: ownerPhoneValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                        SizedBox(height: 4),
                        TextField(
                          controller: ownerPhoneController,
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
                        SizedBox(
                          height: 16,
                        ),

                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Comp 01--------
                            Text(
                              "Competitor 01",
                              style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            DropDownMenu(
                              items: userProvider.getAllCompetitors(competitor1GUID, competitor2GUID, competitor3GUID),
                              value: competitor1GUID,
                              onSelect: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  competitor1GUID = value;
                                });
                              },
                              title: 'Choose brands',
                              text: userProvider.isNetworkingCompetitors
                                  ? "Please wait..."
                                  : competitor1GUID.isEmpty
                                      ? "Select one"
                                      : userProvider.displayText(competitor1GUID),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "TV",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 48,
                                        decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: competitor1TVController,
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
                                  width: 4,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "RF",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 48,
                                        decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: competitor1RFController,
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
                                  width: 4,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "AC",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 48,
                                        decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: competitor1ACController,
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
                            //Comp 02----------
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Competitor 02",
                              style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            DropDownMenu(
                              items: userProvider.getAllCompetitors(competitor1GUID, competitor2GUID, competitor3GUID),
                              value: competitor2GUID,
                              onSelect: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  competitor2GUID = value;
                                });
                              },
                              title: 'Choose brands',
                              text: userProvider.isNetworkingCompetitors
                                  ? "Please wait..."
                                  : competitor2GUID.isEmpty
                                      ? "Select one"
                                      : userProvider.displayText(competitor2GUID),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "TV",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 48,
                                        decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: competitor2TVController,
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
                                  width: 4,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "RF",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 48,
                                        decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: competitor2RFController,
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
                                  width: 4,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "AC",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 48,
                                        decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: competitor2ACController,
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
                            //Comp 03--------
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Competitor 03",
                              style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            DropDownMenu(
                              items: userProvider.getAllCompetitors(competitor1GUID, competitor2GUID, competitor3GUID),
                              value: competitor3GUID,
                              onSelect: (value) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  competitor3GUID = value;
                                });
                              },
                              title: 'Choose brands',
                              text: userProvider.displayText(competitor3GUID),
                            ),
                            SizedBox(
                              height: 8,
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "TV",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 48,
                                        decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: competitor3TVController,
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
                                  width: 4,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "RF",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 48,
                                        decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: competitor3RFController,
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
                                  width: 4,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "AC",
                                        style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 48,
                                        decoration: BoxDecoration(color: themeProvider.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                        child: TextField(
                                          controller: competitor3ACController,
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
                          ],
                        ),
                        SizedBox(height: 16),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Upload Image *", style: TextStyles.caption(context: context, color: files.isEmpty ? themeProvider.errorColor : themeProvider.hintColor)),
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
                                  color: files.isEmpty ? themeProvider.errorColor : themeProvider.shadowColor,
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
                                distributorValidator.validate();
                                ownerNameValidator.validate();
                                ownerPhoneValidator.validate();
                                cityValidator.validate();
                              });
                              if (district.isNotEmpty &&
                                  thana.isNotEmpty &&
                                  cityValidator.isValid &&
                                  cityVillageController.text.isNotEmpty &&
                                  routeNameValidator.isValid &&
                                  routeNameController.text.isNotEmpty &&
                                  distributorName.isNotEmpty &&
                                  distributorValidator.isValid &&
                                  distributorNameController.text.isNotEmpty &&
                                  (distributorName == "Shop"
                                      ? shopTypes.isNotEmpty && (shopTypes == "Registered" ? (registrationValidator.isValid && registrationController.text.isNotEmpty) : true)
                                      : true) &&
                                  ownerNameValidator.isValid &&
                                  ownerNameController.text.isNotEmpty &&
                                  ownerPhoneValidator.isValid &&
                                  ownerPhoneController.text.isNotEmpty &&
                                  files.isNotEmpty) {
                                List<Map<String, String>> items = [
                                  {
                                    "CompetitorId": competitor1GUID.isEmpty ? zeroGuid : competitor1GUID,
                                    "TV": competitor1TVController.text,
                                    "RF": competitor1RFController.text,
                                    "AC": competitor1ACController.text,
                                  },
                                  {
                                    "CompetitorId": competitor2GUID.isEmpty ? zeroGuid : competitor2GUID,
                                    "TV": competitor2TVController.text,
                                    "RF": competitor2RFController.text,
                                    "AC": competitor2ACController.text,
                                  },
                                  {
                                    "CompetitorId": competitor3GUID.isEmpty ? zeroGuid : competitor3GUID,
                                    "TV": competitor3TVController.text,
                                    "RF": competitor3RFController.text,
                                    "AC": competitor3ACController.text,
                                  },
                                ];

                                Map<String, List<Map<String, String>>> competitorList = {"LocationPointCompetitorLst": items};

                                FloatingPoint point = FloatingPoint(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  pointName: routeNameController.text,
                                  routeDay: routeDay,
                                  shopName: distributorNameController.text,
                                  ownerName: ownerNameController.text,
                                  ownerPhone: ownerPhoneController.text,
                                  isDealer: (distributorName == "Dealer").toString(),
                                  city: cityVillageController.text,
                                  district: district,
                                  monthlySaleTv: monthlySaleTVController.text.toString(),
                                  monthlySaleRf: monthlySaleRFController.text.toString(),
                                  monthlySaleAc: monthlySaleACController.text.toString(),
                                  showroomSize: showRoomSizeController.text.toString(),
                                  lat: snapshot.data.latitude,
                                  lng: snapshot.data.longitude,
                                  files: "",
                                  shopSubType: shopTypes,
                                  registeredName: registrationController.text.toString(),
                                  competitorList: json.encode(competitorList),
                                  thana: thana,
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
                                  StreamedResponse response = await userProvider.saveOnline(point, files);
                                  Navigator.of(context).pop();
                                  if (response == null) {
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
                                  } else if (response.statusCode != 200) {
                                    String result = await response.stream.bytesToString();
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Container(
                                              decoration: BoxDecoration(color: Colors.white),
                                              width: 300,
                                              child: Text(
                                                result,
                                                style: TextStyles.body(context: context, color: Colors.red),
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    setState(() {
                                      district = "";
                                      thana = "";
                                      distributorName = "";
                                      shopTypes = "";
                                      competitor1GUID = "";
                                      competitor2GUID = "";
                                      competitor3GUID = "";
                                      distributorNameController.text = "";
                                      ownerNameController.text = "";
                                      ownerPhoneController.text = "";
                                      cityVillageController.text = "";
                                      routeNameController.text = "";
                                      routeDay = "";
                                      competitor1TVController.text = "";
                                      competitor1RFController.text = "";
                                      competitor1ACController.text = "";
                                      competitor2TVController.text = "";
                                      competitor2RFController.text = "";
                                      competitor2ACController.text = "";
                                      competitor3TVController.text = "";
                                      competitor3RFController.text = "";
                                      competitor3ACController.text = "";
                                      monthlySaleTVController.text = "";
                                      monthlySaleRFController.text = "";
                                      monthlySaleACController.text = "";
                                      showRoomSizeController.text = "";
                                      isDealer = "";
                                      files = [];
                                    });
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
                                    setState(() {
                                      district = "";
                                      thana = "";
                                      distributorName = "";
                                      shopTypes = "";
                                      competitor1GUID = "";
                                      competitor2GUID = "";
                                      competitor3GUID = "";
                                      distributorNameController.text = "";
                                      ownerNameController.text = "";
                                      ownerPhoneController.text = "";
                                      cityVillageController.text = "";
                                      routeNameController.text = "";
                                      routeDay = "";
                                      competitor1TVController.text = "";
                                      competitor1RFController.text = "";
                                      competitor1ACController.text = "";
                                      competitor2TVController.text = "";
                                      competitor2RFController.text = "";
                                      competitor2ACController.text = "";
                                      competitor3TVController.text = "";
                                      competitor3RFController.text = "";
                                      competitor3ACController.text = "";
                                      monthlySaleTVController.text = "";
                                      monthlySaleRFController.text = "";
                                      monthlySaleACController.text = "";
                                      showRoomSizeController.text = "";
                                      isDealer = "";
                                      files = [];
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Success", style: TextStyles.subTitle(context: context, color: themeProvider.accentColor)),
                                              content: Text("You've saved '${point.shopName}' in offline mode. Please sync the activity once internet is available",
                                                  style: TextStyles.body(context: context, color: themeProvider.textColor)),
                                            ));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Error", style: TextStyles.subTitle(context: context, color: themeProvider.accentColor)),
                                              content: Text("Failed to save data while offline", style: TextStyles.body(context: context, color: themeProvider.textColor)),
                                            ));
                                  }
                                }
                              } else {
                                FocusScope.of(context).requestFocus(FocusNode());
                                if (district.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* district is required");
                                } else if (thana.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* thana is required");
                                } else if (!cityValidator.isValid || cityVillageController.text.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* city/village is required");
                                } else if (!routeNameValidator.isValid || routeNameController.text.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* route name is required");
                                } else if (routeDay.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* day is required");
                                } else if (distributorName.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* dealer/sub-dealer/shop is required");
                                } else if (!distributorValidator.isValid || distributorNameController.text.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* ${distributorName.toLowerCase()} name is required");
                                } else if (distributorName == "Shop" && shopTypes.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* shop type is required");
                                } else if (distributorName == "Shop" && shopTypes == "Registered" && (!registrationValidator.isValid || registrationController.text.isEmpty)) {
                                  Helper.alertValidationERROR(context: context, message: "* registration number is required");
                                } else if (!ownerNameValidator.isValid || ownerNameController.text.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* owner's name is required");
                                } else if (!ownerPhoneValidator.isValid || ownerPhoneController.text.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* owner's phone number is required");
                                } else if (files.isEmpty) {
                                  Helper.alertValidationERROR(context: context, message: "* at least one image is required");
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

  String routeDisplayText(String value) {
    try {
      return routeDays.firstWhere((element) => element.value == value).text;
    } catch (error) {
      return "Select one";
    }
  }
}
