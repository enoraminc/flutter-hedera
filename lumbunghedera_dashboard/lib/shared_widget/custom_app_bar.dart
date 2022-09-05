import 'package:flutter/material.dart';

import '../core/utils/custom_function.dart';
import '../core/utils/text_styles.dart';
import '../flavor_config.dart';
import 'profile_dropdown_widget.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border(
          right: BorderSide(
            width: 1,
            color: Theme.of(context).appBarTheme.backgroundColor!,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: CustomFunctions.getMediaWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                "assets/logo/logo.png",
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FlavorConfig.instance.values.appName,
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  FlavorConfig.instance.values.versionNumber,
                  style: Styles.commonTextStyle(
                    size: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const ProfileDropdown(),
          ],
        ),
      ),
    );
  }
}
