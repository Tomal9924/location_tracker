import 'package:flutter/material.dart';
import 'package:location_tracker/src/model/floating_point_details.dart';
import 'package:location_tracker/src/provider/provider_floating_point.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/utils/api.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FloatingPointDetailsRoute extends StatelessWidget {
  final String route = "/floating_point_details";

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final floatingPointProvider = Provider.of<FloatingPointProvider>(context);
    final int id = ModalRoute.of(context).settings.arguments as int;
    final FloatingPointDetails details = floatingPointProvider.findById(id);

    floatingPointProvider.init();

    Future.delayed(Duration(milliseconds: 0), () {
      if (!floatingPointProvider.isDetailsNetworking && !floatingPointProvider.isExists(id)) {
        floatingPointProvider.loadDetails(id);
      }
    });

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.backgroundColor,
        brightness: Brightness.light,
        elevation: 0,
        title: Text("Details", style: TextStyles.title(context: context, color: themeProvider.accentColor)),
        automaticallyImplyLeading: true,
      ),
      body: floatingPointProvider.isDetailsNetworking || details == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              physics: ScrollPhysics(),
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                ListTile(
                  leading: Icon(MdiIcons.roadVariant, color: themeProvider.hintColor),
                  title: Text(details.routeName, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  leading: Icon(Icons.event_outlined, color: themeProvider.hintColor),
                  title: Text(details.routeDay, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  leading: Icon(Icons.store_outlined, color: themeProvider.hintColor),
                  title: Text(details.shopName, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  leading: Icon(Icons.person_outline_rounded, color: themeProvider.hintColor),
                  title: Text(details.ownerName, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  leading: Icon(Icons.call_outlined, color: themeProvider.hintColor),
                  title: Text(details.ownerPhone, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    launch("tel:${details.ownerPhone}");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.location_on_outlined, color: themeProvider.hintColor),
                  title: Text(details.thana ?? "", style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  subtitle: Text(details.district, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  leading: Icon(Icons.gps_fixed_outlined, color: themeProvider.hintColor),
                  title: Text("${details.lat}, ${details.lng}", style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    MapsLauncher.launchCoordinates(details.lat, details.lng);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today_outlined, color: themeProvider.hintColor),
                  title: Text("${details.createdDate}", style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                Visibility(visible: details.files.isNotEmpty, child: Divider()),
                Visibility(
                  visible: details.files.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Images",
                      style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                    ),
                  ),
                ),
                Visibility(
                  visible: details.files.isNotEmpty,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 256,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      physics: ScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => SizedBox(
                        width: 16,
                      ),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 256,
                            height: 256,
                            decoration: BoxDecoration(color: themeProvider.secondaryColor),
                            child: Image.network(
                              Api.fileUrl(details.files[index]).replaceAll("wwwroot/", ""),
                              width: 256,
                              height: 256,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      itemCount: details.files.length,
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
    );
  }
}
