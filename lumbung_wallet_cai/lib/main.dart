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
      hederaNetwork: HederaNetwork.testnet,
      appName: "Lumbung Wallet",
      logoPath: "assets/logo.png",
      versionNumber: '1.0.2',
      versionDate: "2 September 2022",
      rempahApiUrl:
          "https://rempah-prod-dot-lumbungdemo.as.r.appspot.com/_api/lumbungrempah",
      // hederaApiUrl:
      //     "https://hedera-prod-dot-lumbungdemo.as.r.appspot.com/_api/hedera",
      hederaApiUrl:
          "https://hedera-dev-dot-lumbungdemo.as.r.appspot.com/_api/hedera",
      // hederaApiUrl: "http://192.168.1.7:8080/_api/hedera",
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
