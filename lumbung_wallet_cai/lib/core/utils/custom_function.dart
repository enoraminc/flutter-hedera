import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFunctions {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 1200;
  }

  static bool isDarkTheme(BuildContext context) {
    if (EasyDynamicTheme.of(context).themeMode == ThemeMode.dark) {
      return true;
    } else {
      return false;
    }
  }

  static double getMediaWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width <= 600) {
      return MediaQuery.of(context).size.width;
    } else if (MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width <= 1200) {
      return 1000;
    } else if (MediaQuery.of(context).size.width >= 1200 &&
        MediaQuery.of(context).size.width <= 1600) {
      return 1200;
    } else {
      return 1450;
    }
  }
}
