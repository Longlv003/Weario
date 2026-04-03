import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:weario/app.dart';
import 'package:weario/configs/system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

var logger = Logger();
FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize();
  await initializeDateFormatting('vi_VN', null);
  try {
    await dotenv.load(fileName: ".env");
    System.baseUrl = dotenv.env['BASE_URL'] ?? "http://10.0.2.2:3000/api";
  } catch (e) {
    System.baseUrl = "http://10.0.2.2:3000/api";
    logger.e("dotenv error: $e");
  }
  runApp(const App());
}
