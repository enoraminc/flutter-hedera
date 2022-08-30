import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'flavor_config.dart';
import 'injector.dart';
import 'my_app.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlavorConfig(
    values: FlavorValues(
      appName: "Lumbung Wallet",
      logoPath: "assets/logo.png",
      versionNumber: '0.0.1',
      versionDate: "29 August 2022",
      rempahApiUrl:
          "https://rempah-prod-dot-lumbungdemo.as.r.appspot.com/_api/lumbungrempah",
      hederaApiUrl:
          "https://ground-prod-dot-lumbungdemo.as.r.appspot.com/_api/lumbungground",
    ),
  );

  // Depedency Injection
  await setupLocator();

  runApp(
    EasyDynamicThemeWidget(
      initialThemeMode: ThemeMode.dark,
      child: MyApp(),
    ),
  );
}
