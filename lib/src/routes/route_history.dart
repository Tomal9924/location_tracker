import 'package:flutter/material.dart';
import 'package:location_tracker/src/model/floating_point.dart';
import 'package:location_tracker/src/provider/provider_floating_point.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/routes/route_floating_point_details.dart';
import 'package:location_tracker/src/utils/text_styles.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

class HistoryRoute extends StatelessWidget {
  final String route = '/history';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final floatingPointProvider = Provider.of<FloatingPointProvider>(context);
    floatingPointProvider.init();

    Future.delayed(Duration(milliseconds: 0), () {
      if (!floatingPointProvider.isNetworking && !floatingPointProvider.hasCalled && floatingPointProvider.items.isEmpty) {
        floatingPointProvider.loadFloatingPoints();
      }
    });

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.backgroundColor,
        brightness: Brightness.light,
        elevation: 0,
        title: Text("History", style: TextStyles.title(context: context, color: themeProvider.accentColor)),
        automaticallyImplyLeading: true,
        actions: [
          Visibility(
            visible: !floatingPointProvider.isNetworking,
            child: Container(
              margin: EdgeInsets.only(right: 16),
              alignment: Alignment.centerRight,
              child: Text(
                "${floatingPointProvider.getAll().length}items",
                style: TextStyles.caption(context: context, color: themeProvider.accentColor),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
      body: floatingPointProvider.isNetworking
          ? Center(child: CircularProgressIndicator())
          : floatingPointProvider.getAll().isEmpty
              ? RefreshIndicator(
                  onRefresh: () async => floatingPointProvider.loadFloatingPoints(),
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - kToolbarHeight - kToolbarHeight,
                        child: Center(
                          child: Text("No data found", style: TextStyles.body(context: context, color: themeProvider.hintColor)),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async => floatingPointProvider.loadFloatingPoints(),
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      FloatingPoint point = floatingPointProvider.getAll()[index];
                      return ExpansionTile(
                        title: Text(point.shopName ?? "", style: TextStyles.body(context: context, color: themeProvider.textColor)),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 16),
                        subtitle: Text(
                          "${point.city}, ${point.district}",
                          style: TextStyles.caption(context: context, color: themeProvider.hintColor),
                        ),
                        leading: Icon(point.isDealer ? Icons.domain : Icons.store, color: themeProvider.hintColor),
                        trailing: point.lat == 0
                            ? null
                            : IconButton(
                                icon: Icon(Icons.directions_outlined, color: themeProvider.accentColor),
                                onPressed: () {
                                  if (point.lng != 0) {
                                    MapsLauncher.launchCoordinates(point.lat, point.lng);
                                  }
                                },
                                padding: EdgeInsets.zero,
                              ),
                        children: [
                          ListTile(
                            leading: Icon(Icons.person, color: themeProvider.hintColor),
                            title: Text(point.ownerName, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: EdgeInsets.zero,
                          ),
                          ListTile(
                            leading: Icon(Icons.phone, color: themeProvider.hintColor),
                            title: Text(point.ownerPhone, style: TextStyles.body(context: context, color: themeProvider.textColor)),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: EdgeInsets.zero,
                          ),
                          ListTile(
                            leading: Icon(Icons.location_pin, color: themeProvider.hintColor),
                            title: Text("${point.lat}, ${point.lng}", style: TextStyles.body(context: context, color: themeProvider.textColor)),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            contentPadding: EdgeInsets.zero,
                          ),
                          ActionChip(
                            label: Text("See more"),
                            onPressed: () {
                              Navigator.of(context).pushNamed(FloatingPointDetailsRoute().route, arguments: point.guid);
                            },
                            avatar: Icon(Icons.open_in_new, size: 16, color: themeProvider.hintColor),
                            backgroundColor: themeProvider.secondaryColor,
                          )
                        ],
                      );
                    },
                    itemCount: floatingPointProvider.getAll().length,
                  ),
                ),
    );
  }
}
