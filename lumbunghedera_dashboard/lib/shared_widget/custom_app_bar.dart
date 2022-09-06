import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumbunghedera_dashboard/core/routes/routes.dart';

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
            InkWell(
              onTap: () {
                Router.neglect(
                  context,
                  () => context.go(
                    Routes.dashboard,
                  ),
                );
              },
              child: SizedBox(
                height: 35,
                width: 35,
                child: Image.asset(
                  "assets/logo/logo.png",
                ),
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
                    size: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  FlavorConfig.instance.values.versionNumber,
                  style: Styles.commonTextStyle(
                    size: 12,
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
