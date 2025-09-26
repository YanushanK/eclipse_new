import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _online = true;
  bool get online => _online;

  void startListening() {
    Connectivity().onConnectivityChanged.listen((result) {
      final nowOnline = result != ConnectivityResult.none;
      if (nowOnline != _online) {
        _online = nowOnline;
        notifyListeners();
      }
    });
  }
}