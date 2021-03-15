import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:location_tracker/src/model/db/point.dart';
import 'package:location_tracker/src/model/db/user.dart';
import 'package:location_tracker/src/provider/provider_auth.dart';
import 'package:location_tracker/src/provider/provider_internet.dart';
import 'package:location_tracker/src/provider/provider_theme.dart';
import 'package:location_tracker/src/provider/provider_user.dart';
import 'package:location_tracker/src/routes/route_floating_point_details.dart';
import 'package:location_tracker/src/routes/route_history.dart';
import 'package:location_tracker/src/routes/route_home.dart';
import 'package:location_tracker/src/routes/route_auth.dart';
import 'package:location_tracker/src/widgets/history/widget_user_history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'src/provider/provider_floating_point.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PointAdapter());
  runApp(
    MultiProvider(child: MyApp(), providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => InternetProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => FloatingPointProvider()),
    ]),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Jamuna Electronics & Automobiles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeProvider.accentColor,
        accentColor: themeProvider.accentColor,
        backgroundColor: themeProvider.backgroundColor,
        canvasColor: themeProvider.backgroundColor,
        shadowColor: themeProvider.shadowColor,
        indicatorColor: themeProvider.accentColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: themeProvider.accentColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: themeProvider.accentColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 3,
          ),
        ),
        iconTheme: IconThemeData(color: themeProvider.textColor, size: 24),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: themeProvider.accentColor),
            actionsIconTheme: IconThemeData(color: themeProvider.accentColor)),
      ),
      home: LauncherRoute(),
      routes: {
        AuthRoute().route: (context) => AuthRoute(),
        HomeRoute().route: (context) => HomeRoute(),
        UserHistoryWidget().route: (context) => UserHistoryWidget(),
        HistoryRoute().route: (context) => HistoryRoute(),
        FloatingPointDetailsRoute().route: (context) => FloatingPointDetailsRoute(),
      },
    );
  }
}

class LauncherRoute extends StatefulWidget {
  @override
  _LauncherRouteState createState() => _LauncherRouteState();
}

class _LauncherRouteState extends State<LauncherRoute> {
  ThemeProvider themeProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      redirect();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: themeProvider.backgroundColor,
        body: Center(
          child: Image.asset(
            "images/logo.png",
            width: MediaQuery.of(context).size.width * .2,
            height: MediaQuery.of(context).size.width * .2,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  redirect() async {
    try {
      Box<User> userBox = await Hive.openBox("users");
      Box<Point> pointBox = await Hive.openBox("points");
      User user;
      if (userBox.length > 0) {
        user = userBox.getAt(0);
      }
      Navigator.of(context).pushReplacementNamed(user == null
          ? AuthRoute().route
          : user.isAuthenticated ?? false
              ? HomeRoute().route
              : AuthRoute().route);
    } catch (error) {
      Navigator.of(context).pushReplacementNamed(AuthRoute().route);
    }
  }
}
