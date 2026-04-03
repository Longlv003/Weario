import 'package:flutter/material.dart';

class System {
  static late String baseUrl;

  static const supportedLocales = [Locale('en', 'US'), Locale('vi', 'VI')];

  static const mainLocale = Locale('vi', 'VI');

  static const int receiveTimeout = 60000;
  static const int connectionTimeout = 60000;
  static const header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
