import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'custom_function.dart';

class TextStyles {
  static TextStyle hintStyle(Color color) => TextStyle(
        color: color,
        fontSize: 16,
      );

  static TextStyle captionStyle(Color color) => TextStyle(
        color: color,
        fontSize: 14,
      );

  static TextStyle tabLabelStyle(Color color) => TextStyle(
        fontSize: 16,
        color: color,
        fontWeight: FontWeight.bold,
      );

  static TextStyle normalContent(Color color) => TextStyle(
        fontSize: 16,
        color: color,
      );

  static TextStyle bodyText1(Color color) => TextStyle(
        color: color,
        fontSize: 18,
      );

  static TextStyle subTitle1Style(Color color) =>
      TextStyle(color: color, fontSize: 14);

  static TextStyle subTitle2Style(Color color) =>
      TextStyle(color: color, fontSize: 12);

  static TextStyle headLine2Style(Color color) =>
      TextStyle(color: color, fontSize: 12);

  static TextStyle headLine3Style(Color color) =>
      TextStyle(color: color, fontSize: 16);

  static TextStyle Body2Style(Color color) => TextStyle(
        color: color,
        fontSize: 16,
      );

  static TextStyle Headline1Style(Color color) => TextStyle(
        color: color,
        fontSize: 16,
      );

  static TextStyle editButtonStyle(Color color) => TextStyle(
        color: color,
        fontSize: 14,
      );

  static TextStyle primaryHeadline1Style(Color color) => TextStyle(
        color: color,
        fontSize: 18,
      );

  static TextStyle primaryHeadline2Style(Color color) => TextStyle(
        color: color,
        fontSize: 16,
      );

  static TextStyle descriptionStyle(Color color) => TextStyle(
      color: color, fontSize: 18, decoration: TextDecoration.underline);

  static TextStyle appNameLoginScreen(BuildContext context) {
    if (CustomFunctions.isDarkTheme(context)) {
      return const TextStyle(color: Colors.white, fontSize: 22);
    }
    return const TextStyle(color: AppColors.blackColor, fontSize: 22);
  }

  static TextStyle deleteTitleTaskStyle(BuildContext context) => TextStyle(
      color: CustomFunctions.isDarkTheme(context)
          ? AppColors.kLightColor
          : AppColors.blackColor,
      fontSize: 20);

  static TextStyle deleteSubTitleTaskStyle(BuildContext context,
          {bool isBold = false}) =>
      TextStyle(
          color: CustomFunctions.isDarkTheme(context)
              ? AppColors.kLightColor
              : AppColors.blackColor,
          fontSize: 18,
          fontWeight: (isBold) ? FontWeight.bold : null);
}

class Styles {
  static TextStyle commonTextStyle({
    double? size,
    FontWeight? fontWeight,
    Color? color,
    TextDecoration? decoration,
  }) =>
      GoogleFonts.ptSans(
        fontWeight: fontWeight ?? FontWeight.w500,
        fontSize: size ?? 16,
        color: color,
        decoration: decoration,
      );

  static TextStyle buttonTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static TextStyle regularTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static TextStyle boldTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static TextStyle semiBoldTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  static TextStyle inputTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static TextStyle hintTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static TextStyle accentTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );
}
