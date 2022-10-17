import 'package:flutter/material.dart';
import '../core/utils/text_styles.dart';

import '../core/utils/custom_function.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    super.key,
    required this.appBar,
    required this.children,
    required this.onRefresh,
    this.backgroundColor,
  });

  final Widget appBar;
  final List<Widget> children;
  final Future<void> Function() onRefresh;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          appBar,
          Expanded(
            child: Container(
              color: backgroundColor ??
                  Theme.of(context).appBarTheme.backgroundColor,
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Container(
                    width: CustomFunctions.getMediaWidth(context),
                    padding: CustomFunctions.isMobile(context)
                        ? null
                        : const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: children,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BaseScreen2 extends StatelessWidget {
  const BaseScreen2({
    super.key,
    required this.appBar,
    required this.bottomNavBar,
    required this.mainChild,
    required this.onRefresh,
    required this.sidebarChildren,
    required this.selectedId,
    required this.onBack,
    required this.isLoading,
    this.tabWidget,
    this.onCreateTap,
    this.customButton,
    this.searchWidget,
  });

  final Widget appBar;
  final Widget bottomNavBar;
  final Widget mainChild;
  final List<Widget> sidebarChildren;
  final Future<void> Function() onRefresh;
  final String? selectedId;
  final Function() onBack;
  final Widget? tabWidget;
  final bool isLoading;
  final Function()? onCreateTap;
  final Widget? customButton;
  final Widget? searchWidget;

  @override
  Widget build(BuildContext context) {
    bool isMobile = CustomFunctions.isMobile(context);
    bool hasSelectedItem = false;
    if (isMobile) {
      hasSelectedItem = selectedId?.isNotEmpty ?? false;
    } else {
      hasSelectedItem = true;
    }

    return Scaffold(
      body: Column(
        children: [
          if (!hasSelectedItem || !isMobile) appBar,
          Expanded(
            child: Container(
              width: CustomFunctions.getMediaWidth(context),
              padding:
                  !isMobile ? const EdgeInsets.symmetric(horizontal: 18) : null,
              child: Row(
                children: [
                  if (!hasSelectedItem || !isMobile) ...[
                    isMobile
                        ? Expanded(
                            child: sideBarSection(context),
                          )
                        : sideBarSection(context),
                    if (!isMobile) const SizedBox(width: 10),
                  ],
                  if (hasSelectedItem) mainSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          (!hasSelectedItem && !isMobile) ? bottomNavBar : null,
    );
  }

  Expanded mainSection(BuildContext context) {
    bool isMobile = CustomFunctions.isMobile(context);
    return Expanded(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        margin: !isMobile
            ? const EdgeInsets.symmetric(
                vertical: 10,
              )
            : null,
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: !isMobile ? BorderRadius.circular(5) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile) ...[
              const SizedBox(height: 10),
              IconButton(
                onPressed: onBack,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Expanded(child: mainChild),
          ],
        ),
      ),
    );
  }

  Container sideBarSection(BuildContext context) {
    bool isMobile = CustomFunctions.isMobile(context);

    return Container(
      width: (isMobile)
          ? double.infinity
          : CustomFunctions.getMediaWidth(context) / 4,
      height: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: isMobile ? 18 : 0,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              if (tabWidget != null) ...[
                tabWidget!,
                const SizedBox(height: 10),
              ],
              if (searchWidget != null) ...[
                searchWidget!,
                const SizedBox(height: 10),
              ],
              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ),
                )
              else ...[
                if (sidebarChildren.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        "Data is empty",
                        textAlign: TextAlign.center,
                        style: Styles.commonTextStyle(
                          size: 18,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: onRefresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        controller: ScrollController(),
                        children: sidebarChildren,
                      ),
                    ),
                  ),
              ],
            ],
          ),
          if (onCreateTap != null || customButton != null)
            Positioned(
              right: 0,
              bottom: 10,
              child: customButton != null
                  ? customButton!
                  : InkWell(
                      onTap: () {
                        onCreateTap?.call();
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 25,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
