import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

class InternetProvider extends ChangeNotifier {
  bool _hasInternet = false;

  bool get connected => _hasInternet;

  bool get notConnected => !_hasInternet;

  listen() async {
    DataConnectionChecker().onStatusChange.listen((event) {
      _hasInternet = event==DataConnectionStatus.connected;
      notifyListeners();
    });
  }
}
