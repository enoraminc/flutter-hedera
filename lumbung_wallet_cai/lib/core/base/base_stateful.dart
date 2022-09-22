import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import 'package:core/utils/log.dart';
import '../../flavor_config.dart';

abstract class BaseStateful<S extends StatefulWidget> extends State<S> {
  // /// Access the Navigation Service
  // final NavigationService nav = NavigationService.instance;

  // /// Access app Text Style Theme
  // final TextStyleTheme tTheme = TextStyleTheme.instance;

  // /// Access SVG with this property
  // final SVGDirectory svgDir = SVGDirectory.instance;

  // /// Access messenger service with this property
  // final MessengerService messenger = MessengerService.instance;

  ProgressDialog? progressDialog;
  CustomProgressDialog? loading;

  //format number

  String formatNumber(String s) =>
      NumberFormat.decimalPattern('id').format(num.tryParse(s) ?? 0);

  double stringToNumber(String s) =>
      double.tryParse(s.replaceAll(",", ".").replaceAll(".", "").trim()) ?? 0;

  double decimalStringToNumber(String s) =>
      double.tryParse(s.replaceAll(".", "").replaceAll(",", ".")) ?? 0;

  String decimalNumberToString(num s) => "$s".replaceAll(".", ",");

  String formatAmount(num? amount) {
    if (amount != null) {
      NumberFormat rpFormat = NumberFormat.simpleCurrency(locale: 'in_id');
      return rpFormat
          .format(amount)
          .replaceAll(RegExp('Rp'), 'Rp. ')
          .replaceAll(',00', '');
    }
    return 'Rp. 0';
  }

  /// Set screen size
  late double height;
  late double width;
  void setSize(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }

  /// Print log for debugging with this function
  void setLog(dynamic desc, {String method = "Log"}) {
    Log.setLog(desc, method: method);
  }

  /// Show snackbar with this function
  void showSnackBar(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
              isError ? Colors.red : Theme.of(context).colorScheme.secondary,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void showSnackBarWithAction(
    String message, {
    String? actionText,
    bool isError = false,
    void Function()? actionCallback,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
              isError ? Colors.red : Theme.of(context).colorScheme.secondary,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 60),
          action: SnackBarAction(
            label: actionText ?? "Refresh",
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              actionCallback?.call();
            },
          ),
        ),
      );
  }

  /// Variable contains height of the on-screen keyboard
  double keyboardHeight = 0.0;
  void calculateBottomInsets() {
    keyboardHeight = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance.window.viewInsets,
      WidgetsBinding.instance.window.devicePixelRatio,
    ).bottom;
  }

  // Body Constraints
  Widget bodyConstraints({required Widget child, double maxWidth = 1200}) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  /// Body of the page
  Widget body();

  @override
  Widget build(BuildContext context) {
    setSize(context);
    calculateBottomInsets();
    // setStatusBarColorToPrimary();
    return SelectionArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: body(),
      ),
    );
  }

  // BlocListener<ConfigCubit, ConfigModel> configListener() {
  //   return BlocListener<ConfigCubit, ConfigModel>(
  //     listener: (context, state) {
  //       if (checkAppVersion(
  //           FlavorConfig.instance?.values.versionNumber, state.version)) {
  //         router.navigateTo(context, Routes.update,
  //             replace: true, clearStack: true);
  //       } else if (state.isMaintenance) {
  //         router.navigateTo(
  //           context,
  //           Routes.maintenance,
  //           replace: true,
  //           clearStack: true,
  //         );
  //       }
  //     },
  //   );
  // }
}
