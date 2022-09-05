import 'package:flutter/material.dart';

import '../core/utils/custom_function.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    super.key,
    required this.appBar,
    required this.children,
    required this.onRefresh,
  });

  final Widget appBar;
  final List<Widget> children;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          appBar,
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                controller: ScrollController(),
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Container(
                  width: CustomFunctions.getMediaWidth(context),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: children,
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
