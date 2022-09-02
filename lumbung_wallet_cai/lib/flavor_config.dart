import 'dart:ui';

import 'package:flutter/material.dart';

enum HederaNetwork {
  mainnet,
  testnet,
}

class FlavorValues {
  FlavorValues({
    required this.appName,
    required this.logoPath,
    required this.versionNumber,
    required this.versionDate,
    required this.rempahApiUrl,
    required this.hederaApiUrl,
    required this.hederaNetwork,
  });

  String appName;
  final String logoPath;
  String versionNumber;
  String versionDate;
  final String rempahApiUrl;
  final String hederaApiUrl;
  final HederaNetwork hederaNetwork;

  FlavorValues copyWith({
    String? appName,
    String? logoPath,
    String? versionNumber,
    String? versionDate,
    String? rempahApiUrl,
    String? groundApiUrl,
    HederaNetwork? hederaNetwork,
  }) {
    return FlavorValues(
      appName: appName ?? this.appName,
      logoPath: logoPath ?? this.logoPath,
      versionNumber: versionNumber ?? this.versionNumber,
      versionDate: versionDate ?? this.versionDate,
      rempahApiUrl: rempahApiUrl ?? this.rempahApiUrl,
      hederaApiUrl: groundApiUrl ?? this.hederaApiUrl,
      hederaNetwork: hederaNetwork ?? this.hederaNetwork,
    );
  }
}

class FlavorConfig {
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig? _instance;
  static String? COMPANY_LOGO;
  static String? APP_NAME;

  factory FlavorConfig({Color color = Colors.blue, FlavorValues? values}) {
    _instance ??= FlavorConfig._internal("", color, values!);
    return _instance!;
  }

  FlavorConfig._internal(this.name, this.color, this.values) {
    COMPANY_LOGO = "assets/logo/logo.png";
    APP_NAME = "Lumbung Wallet";
  }

  static FlavorConfig get instance {
    return _instance!;
  }
}
