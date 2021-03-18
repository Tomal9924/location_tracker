import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:location_tracker/src/model/competitior.dart';
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
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:location_tracker/src/widgets/home/widget_sync_now.dart';
import 'package:location_tracker/src/widgets/widget_dropdown.dart';
import 'package:location_tracker/src/widgets/widget_multi_select_dropdown.dart';
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
  List<File> files = [];
  List<Competitor> competitorsList = [];
  String isDealer = "";
  List<DropDownItem> dealerTypes = [
    DropDownItem(text: "Dealer", value: "Dealer"),
    DropDownItem(text: "Sub-Dealer", value: "Sub-Dealer"),
    DropDownItem(text: "Shop", value: "Shop"),
  ];
  List<DropDownItem> dealerListNames = [
    DropDownItem(text: "Jack", value: "jack"),
    DropDownItem(text: "Smith", value: "smith"),
    DropDownItem(text: "John", value: "john"),
    DropDownItem(text: "Dummy", value: "Dummy"),
  ];
  List<DropDownItem> shopType = [
    DropDownItem(text: "Registered", value: "Registered"),
    DropDownItem(text: "Cash Retailer", value: "Cash Retailer"),
    DropDownItem(text: "Adhoc", value: "Adhoc"),
    DropDownItem(text: "Not Application", value: "Not Application"),
  ];
  List<DropDownItem> subDealerItems = [
    DropDownItem(text: "Harun", value: "Harun"),
    DropDownItem(text: "Nikolas", value: "Nikolas"),
    DropDownItem(text: "Raju", value: "Raju"),
    DropDownItem(text: "Mina", value: "Mina"),
  ];
  String competitor1GUID = "";
  String competitor2GUID = "";
  String competitor3GUID = "";
  String _selectedisDealerTypes = "";
  String _selectedShopTypes = "";
  String _selectedSubShopTypes = "";
  String distributorName = "Shop";
  TextEditingController shopNameController = new TextEditingController();
  TextEditingController ownerNameController = new TextEditingController();
  TextEditingController ownerPhoneController = new TextEditingController();
  TextEditingController thanaController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController routeNameController = new TextEditingController();
  TextEditingController monthlySaleTVController = new TextEditingController();
  TextEditingController monthlySaleRFController = new TextEditingController();
  TextEditingController monthlySaleACController = new TextEditingController();
  TextEditingController showRoomSizeController = new TextEditingController();
  TextEditingController acController = new TextEditingController();
  TextEditingController subShopController = new TextEditingController();
  TextEditingController competitor1TVController = new TextEditingController();
  TextEditingController competitor1RFController = new TextEditingController();
  TextEditingController competitor1ACController = new TextEditingController();
  TextEditingController competitor2TVController = new TextEditingController();
  TextEditingController competitor2RFController = new TextEditingController();
  TextEditingController competitor2ACController = new TextEditingController();
  TextEditingController competitor3TVController = new TextEditingController();
  TextEditingController competitor3RFController = new TextEditingController();
  TextEditingController competitor3ACController = new TextEditingController();

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
    final lookUpProvider = Provider.of<LookUpProvider>(context);
    authProvider.init();
    userProvider.init();
    internetProvider.listen();
    lookUpProvider.init();
    Future.delayed(Duration.zero, () {
      if (!userProvider.isNetworkingCompetitors && userProvider.competitors.isEmpty) {
        userProvider.loadCompetitors();
      }
      if (!lookUpProvider.isNetworking && lookUpProvider.districtBox.isEmpty && lookUpProvider.thanaBox.isEmpty) {
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
                            title: Text("${snapshot.data.latitude}, ${snapshot.data.longitude}",
                                style: TextStyles.body(context: context, color: themeProvider.hintColor)),
                            onTap: () {
                              MapsLauncher.launchCoordinates(snapshot.data.latitude, snapshot.data.longitude);
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        SizedBox(height: 8),
                        Text("District *",
                            style: TextStyles.caption(
                                context: context, color: district.isNotEmpty ? themeProvider.hintColor : themeProvider.errorColor)),
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
                          child: Text("Thana *",
                              style: TextStyles.caption(
                                  context: context, color: thana.isNotEmpty ? themeProvider.hintColor : themeProvider.errorColor)),
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
                        /*Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("District *",
                                      style: TextStyles.caption(
                                          context: context, color: districtValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  CustomDropDownMenu(
                                    onSelect: (value) {
                                      setState(() {
                                        district = value;
                                      });
                                    },
                                    keyword: Api.lookUpDistrict,
                                    value: district,
                                    text: lookUpProvider.displayText(Api.lookUpDistrict, district),
                                    title: "Choose District",
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
                                  Text("Thana *",
                                      style: TextStyles.caption(
                                          context: context, color: districtValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  CustomDropDownMenu(
                                    onSelect: (value) {
                                      setState(() {
                                        thana = value;
                                      });
                                    },
                                    title: "Choose Thana",
                                    keyword: Api.lookUpThana,
                                    value: thana,
                                    text: lookUpProvider.displayText(Api.lookUpThana, thana),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),*/
                        SizedBox(height: 8),
                        //city---------------------------
                        Text("City/village *",
                            style: TextStyles.caption(context: context, color: cityValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
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
                                  Text("Point name *",
                                      style: TextStyles.caption(
                                          context: context, color: districtValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  TextField(
                                    controller: routeNameController,
                                    focusNode: routeNameFocusNode,
                                    keyboardType: TextInputType.text,
                                    style: TextStyles.body(
                                        context: context, color: routeNameValidator.isValid ? themeProvider.textColor : themeProvider.errorColor),
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
                                  Text("Day*",
                                      style: TextStyles.caption(
                                          context: context, color: districtValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
                                  SizedBox(
                                    height: 4,
                                  ),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        //Shop name-------------------
                        Text("Dealer/Sub-dealer/Shop",
                            style: TextStyles.caption(context: context, color: cityValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),

                        SizedBox(height: 4),
                        DropDownMenu(
                            items: dealerTypes,
                            value: _selectedisDealerTypes,
                            onSelect: (value) {
                              setState(() {
                                _selectedisDealerTypes = value;
                                distributorName = _selectedisDealerTypes;
                              });
                            },
                            title: 'Choose brands',
                            text: _selectedisDealerTypes.isEmpty
                                ? "Select one"
                                : dealerTypes.firstWhere((element) => element.value == _selectedisDealerTypes).text),
                        Visibility(
                          visible: _selectedisDealerTypes == "Shop",
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            child: DropDownMenu(
                                items: shopType,
                                value: _selectedShopTypes,
                                onSelect: (value) {
                                  setState(() {
                                    _selectedShopTypes = value;
                                  });
                                },
                                title: 'Choose brands',
                                text: _selectedShopTypes.isEmpty ? "Select one" : shopType.firstWhere((element) => element.value == _selectedShopTypes).text),
                          ),
                        ),
                        Visibility(
                          visible: _selectedShopTypes == "Registered",
                          child: Container(
                            margin: EdgeInsets.only(top: 8),
                            child: TextField(
                              controller: subShopController,
                              keyboardType: TextInputType.text,
                              style: TextStyles.body(context: context, color: themeProvider.textColor),
                              cursorColor: themeProvider.textColor,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: "registered from...",
                                hintStyle: TextStyles.caption(context: context, color: themeProvider.hintColor.withOpacity(.5)),
                                fillColor: themeProvider.secondaryColor,
                                filled: true,
                                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4)),
                                prefixIconConstraints: BoxConstraints(maxWidth: 36, minWidth: 36),
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 16,
                        ),
                        Text("$distributorName Name *",
                            style: TextStyles.caption(context: context, color: shopValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
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
                        //owner name-------------------
                        Text("Owner Name *",
                            style: TextStyles.caption(context: context, color: shopValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
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
                        //owner name-------------------
                        Text("Owner Phone *",
                            style:
                                TextStyles.caption(context: context, color: ownerPhoneValidator.isValid ? themeProvider.hintColor : themeProvider.errorColor)),
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
                                items: userProvider.getAllCompetitors(competitor1GUID),
                                value: competitor1GUID,
                                onSelect: (value) {
                                  setState(() {
                                    competitor1GUID = value;
                                  });
                                },
                                title: 'Choose brands',
                                text: userProvider.isNetworkingCompetitors
                                    ? "Please wait..."
                                    : competitor1GUID.isEmpty
                                        ? "Select one"
                                        : userProvider.competitors.values.firstWhere((element) => element.value == competitor1GUID).text),
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
                                items: userProvider.getAllCompetitors(competitor2GUID),
                                value: competitor2GUID,
                                onSelect: (value) {
                                  setState(() {
                                    competitor2GUID = value;
                                  });
                                },
                                title: 'Choose brands',
                                text: userProvider.isNetworkingCompetitors
                                    ? "Please wait..."
                                    : competitor2GUID.isEmpty
                                        ? "Select one"
                                        : userProvider.competitors.values.firstWhere((element) => element.value == competitor2GUID).text),
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
                                items: userProvider.getAllCompetitors(competitor3GUID),
                                value: competitor3GUID,
                                onSelect: (value) {
                                  setState(() {
                                    competitor3GUID = value;
                                  });
                                },
                                title: 'Choose brands',
                                text: userProvider.isNetworkingCompetitors
                                    ? "Please wait..."
                                    : competitor3GUID.isEmpty
                                        ? "Select one"
                                        : userProvider.competitors.values.firstWhere((element) => element.value == competitor3GUID).text),
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
                                List<Map<String, String>> items = [
                                  {
                                    "CompetitorId": competitor1GUID,
                                    "TV": competitor1TVController.text,
                                    "RF": competitor1RFController.text,
                                    "AC": competitor1ACController.text,
                                  },
                                  {
                                    "CompetitorId": competitor2GUID,
                                    "TV": competitor2TVController.text,
                                    "RF": competitor2RFController.text,
                                    "AC": competitor2ACController.text,
                                  },
                                  {
                                    "CompetitorId": competitor3GUID,
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
                                  shopName: shopNameController.text,
                                  ownerName: ownerNameController.text,
                                  ownerPhone: ownerPhoneController.text,
                                  isDealer: _selectedisDealerTypes,
                                  city: cityController.text,
                                  district: district,
                                  monthlySaleTv: monthlySaleTVController.text.toString(),
                                  monthlySaleRf: monthlySaleRFController.text.toString(),
                                  monthlySaleAc: monthlySaleACController.text.toString(),
                                  showroomSize: showRoomSizeController.text.toString(),
                                  lat: snapshot.data.latitude,
                                  lng: snapshot.data.longitude,
                                  files: "",
                                  shopSubType: _selectedShopTypes,
                                  registeredName: subShopController.text.toString(),
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
                                              content: Text(
                                                  "You've saves '${point.shopName}' in offline mode. Please sync the activity once internet is available",
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
                                competitor1TVController.text = "";
                                competitor1RFController.text = "";
                                competitor2TVController.text = "";
                                competitor2RFController.text = "";
                                competitor3TVController.text = "";
                                competitor3RFController.text = "";
                                monthlySaleTVController.text = "";
                                monthlySaleRFController.text = "";
                                monthlySaleACController.text = "";
                                showRoomSizeController.text = "";
                                isDealer = "";
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
