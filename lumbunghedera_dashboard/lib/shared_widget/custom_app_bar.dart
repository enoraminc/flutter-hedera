import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumbunghedera_dashboard/core/routes/routes.dart';
import 'package:lumbunghedera_dashboard/shared_widget/rounded_button.dart';

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
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        width: CustomFunctions.getMediaWidth(context),
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
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Column(
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
            ),
            const SizedBox(width: 5),
            CustomFunctions.isMobile(context)
                ? const Spacer()
                : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        tabWidget(
                          context,
                          route: Routes.dashboard,
                          title: "Dashboard",
                        ),
                        tabWidget(
                          context,
                          route: Routes.journal,
                          title: "Journal",
                        ),
                        tabWidget(
                          context,
                          route: Routes.job,
                          title: "Job",
                        ),
                        tabWidget(
                          context,
                          route: "${Routes.wallet}/${Routes.mainWallet}",
                          title: "Wallet",
                        ),
                      ],
                    ),
                  ),
            const SizedBox(width: 5),
            const Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: ProfileDropdown(),
            ),
          ],
        ),
      ),
    );
  }

  InkWell tabWidget(
    BuildContext context, {
    required String route,
    required String title,
  }) {
    final currentRoute = GoRouter.of(context).location.split("?").first;

    // print("==== $route $currentRoute");///

    return InkWell(
      onTap: () {
        if (currentRoute != route) {
          Router.neglect(
            context,
            () => context.go(route),
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
          border: currentRoute == route
              ? const Border(
                  bottom: BorderSide(
                    color: Colors.orange,
                    width: 3.0,
                  ),
                )
              : const Border(
                  bottom: BorderSide(
                    color: Colors.transparent,
                    width: 3.0,
                  ),
                ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: currentRoute == route ? FontWeight.bold : null,
            color: currentRoute == route
                ? CustomFunctions.isDarkTheme(context)
                    ? Colors.white
                    : Colors.black
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class CustomSecondAppBar extends StatelessWidget {
  const CustomSecondAppBar({
    Key? key,
    required this.title,
    this.onActionTap,
    this.actionTitle = "Save",
  }) : super(key: key);
  final String title;
  final Function()? onActionTap;
  final String actionTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        width: CustomFunctions.getMediaWidth(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
                color: Theme.of(context).textSelectionTheme.cursorColor,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      text: title,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              if (onActionTap != null)
                SizedBox(
                  height: 50,
                  width: 100,
                  child: RoundedButton(
                    text: actionTitle,
                    onPressed: onActionTap,
                    selected: true,
                    selectedColor: Colors.orange,
                    isSmall: true,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
