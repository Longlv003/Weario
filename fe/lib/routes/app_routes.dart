import 'package:weario/pages/home/home_page.dart';
import 'package:weario/pages/login/login_page.dart';
import 'package:weario/pages/register/register_page.dart';
import 'package:weario/pages/splash/splash_page.dart';
import 'package:weario/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  List<GetPage> get routes => <GetPage>[
    _getPage(name: Routes.splashPage, page: () => SplashPage()),
    _getPage(name: Routes.loginPage, page: () => LoginPage()),
    _getPage(name: Routes.registerPage, page: () => RegisterPage()),
    _getPage(name: Routes.homePage, page: () => HomePage()),
  ];

  GetPage _getPage({required String name, required Widget Function() page}) =>
      GetPage(name: name, page: page);
}
