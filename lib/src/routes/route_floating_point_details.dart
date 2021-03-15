import 'package:cached_network_image/cached_network_image.dart';
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
    final String guid = ModalRoute.of(context).settings.arguments as String;
    final FloatingPointDetails details = floatingPointProvider.findById(guid);

    floatingPointProvider.init();

    Future.delayed(Duration(milliseconds: 0), () {
      if (!floatingPointProvider.isDetailsNetworking && !floatingPointProvider.isExists(guid)) {
        floatingPointProvider.loadDetails(guid);
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
                  onTap: (){
                    launch("tel:${details.ownerPhone}");
                  },
                ),
                Visibility(
                  visible: details.isDealer,
                  child: ListTile(
                    leading: Icon(Icons.admin_panel_settings_outlined, color: themeProvider.hintColor),
                    title: Text("Dealer", style: TextStyles.body(context: context, color: themeProvider.textColor)),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.location_on_outlined, color: themeProvider.hintColor),
                  title: Text(details.city, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  subtitle: Text(details.district, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  leading: Icon(Icons.gps_fixed_outlined, color: themeProvider.hintColor),
                  title: Text("${details.lat}, ${details.lng}", style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  onTap: (){
                    MapsLauncher.launchCoordinates(details.lat, details.lng);
                  },
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Competitor 1",
                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.tv, color: themeProvider.hintColor),
                  title: Text(details.waltonTV, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  subtitle: Text("Walton TV", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  leading: Icon(MdiIcons.fridgeOutline, color: themeProvider.hintColor),
                  title: Text(details.waltonRF, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  subtitle: Text("Walton RF", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Competitor 2",
                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.tv, color: themeProvider.hintColor),
                  title: Text(details.visionTV, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  subtitle: Text("Vision TV", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  leading: Icon(MdiIcons.fridgeOutline, color: themeProvider.hintColor),
                  title: Text(details.visionRF, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  subtitle: Text("Vision RF", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Competitor 3",
                    style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.tv, color: themeProvider.hintColor),
                  title: Text(details.marcelTV, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  subtitle: Text("Marcel TV", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                ListTile(
                  leading: Icon(MdiIcons.fridgeOutline, color: themeProvider.hintColor),
                  title: Text(details.ministerRF, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                  subtitle: Text("Minister RF", style: TextStyles.caption(context: context, color: themeProvider.hintColor)),
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
                      separatorBuilder: (context, index) => SizedBox(width: 16,),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 256,
                            height: 256,
                            decoration: BoxDecoration(
                              color: themeProvider.secondaryColor
                            ),
                            child: Image.network(
                              Api.fileUrl(details.files[index]),
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
