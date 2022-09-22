import 'dart:convert';

import 'package:lumbung_common/model/user.dart';

class RevokeAssetLogModel {
  final String id;
  final String txId;
  final String assetId;
  final String assetName;
  final String assetUnitName;
  final num revokeAmount;
  final String userEmail;
  final String userAddress;
  final User admin;
  final DateTime createdAt;
  final String createdAtStr;
  RevokeAssetLogModel({
    required this.id,
    required this.txId,
    required this.assetId,
    required this.assetName,
    required this.assetUnitName,
    required this.revokeAmount,
    required this.userEmail,
    required this.userAddress,
    required this.admin,
    required this.createdAt,
    required this.createdAtStr,
  });

  RevokeAssetLogModel copyWith({
    String? id,
    String? txId,
    String? assetId,
    String? assetName,
    String? assetUnitName,
    num? revokeAmount,
    String? userEmail,
    String? userAddress,
    User? admin,
    DateTime? createdAt,
    String? createdAtStr,
  }) {
    return RevokeAssetLogModel(
      id: id ?? this.id,
      txId: txId ?? this.txId,
      assetId: assetId ?? this.assetId,
      assetName: assetName ?? this.assetName,
      assetUnitName: assetUnitName ?? this.assetUnitName,
      revokeAmount: revokeAmount ?? this.revokeAmount,
      userEmail: userEmail ?? this.userEmail,
      userAddress: userAddress ?? this.userAddress,
      admin: admin ?? this.admin,
      createdAt: createdAt ?? this.createdAt,
      createdAtStr: createdAtStr ?? this.createdAtStr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'txId': txId,
      'assetId': assetId,
      'assetName': assetName,
      'assetUnitName': assetUnitName,
      'revokeAmount': revokeAmount,
      'userEmail': userEmail,
      'userAddress': userAddress,
      'admin': admin.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'createdAtStr': createdAtStr,
    };
  }

  factory RevokeAssetLogModel.fromMap(Map<String, dynamic> map) {
    return RevokeAssetLogModel(
      id: map['id'] ?? '',
      txId: map['txId'] ?? '',
      assetId: map['assetId'] ?? '',
      assetName: map['assetName'] ?? '',
      assetUnitName: map['assetUnitName'] ?? '',
      revokeAmount: map['revokeAmount'] ?? 0,
      userEmail: map['userEmail'] ?? '',
      userAddress: map['userAddress'] ?? '',
      admin: User.fromMap(map['admin']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      createdAtStr: map['createdAtStr'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RevokeAssetLogModel.fromJson(String source) =>
      RevokeAssetLogModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RevokeAssetLogModel(id: $id, txId: $txId, assetId: $assetId, assetName: $assetName, assetUnitName: $assetUnitName, revokeAmount: $revokeAmount, userEmail: $userEmail, userAddress: $userAddress, admin: $admin, createdAt: $createdAt, createdAtStr: $createdAtStr)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RevokeAssetLogModel &&
        other.id == id &&
        other.txId == txId &&
        other.assetId == assetId &&
        other.assetName == assetName &&
        other.assetUnitName == assetUnitName &&
        other.revokeAmount == revokeAmount &&
        other.userEmail == userEmail &&
        other.userAddress == userAddress &&
        other.admin == admin &&
        other.createdAt == createdAt &&
        other.createdAtStr == createdAtStr;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        txId.hashCode ^
        assetId.hashCode ^
        assetName.hashCode ^
        assetUnitName.hashCode ^
        revokeAmount.hashCode ^
        userEmail.hashCode ^
        userAddress.hashCode ^
        admin.hashCode ^
        createdAt.hashCode ^
        createdAtStr.hashCode;
  }
}

class AutoOptinLogModel {
  final String id;
  final String address;
  final String txId;
  final User? user;
  final num delayInSeconds;
  final num algorandTransferAmount;
  final bool isLevelOptin;
  final bool isLovesOptin;
  final bool isPointsOptin;
  final bool isTimiOptin;
  final bool isPointConverted;
  final num pointConverted;
  final DateTime? createdAt;
  final String createdAtString;
  final DateTime? updatedAt;
  final String updatedAtString;

  AutoOptinLogModel({
    required this.id,
    required this.address,
    required this.txId,
    this.user,
    required this.delayInSeconds,
    required this.algorandTransferAmount,
    required this.isLevelOptin,
    required this.isLovesOptin,
    required this.isPointsOptin,
    required this.isTimiOptin,
    required this.isPointConverted,
    required this.pointConverted,
    this.createdAt,
    required this.createdAtString,
    this.updatedAt,
    required this.updatedAtString,
  });

  AutoOptinLogModel copyWith({
    String? id,
    String? address,
    String? txId,
    User? user,
    num? delayInSeconds,
    num? algorandTransferAmount,
    bool? isLevelOptin,
    bool? isLovesOptin,
    bool? isPointsOptin,
    bool? isTimiOptin,
    bool? isPointConverted,
    num? pointConverted,
    DateTime? createdAt,
    String? createdAtString,
    DateTime? updatedAt,
    String? updatedAtString,
  }) {
    return AutoOptinLogModel(
      id: id ?? this.id,
      address: address ?? this.address,
      txId: txId ?? this.txId,
      user: user ?? this.user,
      delayInSeconds: delayInSeconds ?? this.delayInSeconds,
      algorandTransferAmount:
          algorandTransferAmount ?? this.algorandTransferAmount,
      isLevelOptin: isLevelOptin ?? this.isLevelOptin,
      isLovesOptin: isLovesOptin ?? this.isLovesOptin,
      isPointsOptin: isPointsOptin ?? this.isPointsOptin,
      isTimiOptin: isTimiOptin ?? this.isTimiOptin,
      isPointConverted: isPointConverted ?? this.isPointConverted,
      pointConverted: pointConverted ?? this.pointConverted,
      createdAt: createdAt ?? this.createdAt,
      createdAtString: createdAtString ?? this.createdAtString,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedAtString: updatedAtString ?? this.updatedAtString,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'txId': txId,
      'user': user?.toRefMap(),
      'delayInSeconds': delayInSeconds,
      'algorandTransferAmount': algorandTransferAmount,
      'isLevelOptin': isLevelOptin,
      'isLovesOptin': isLovesOptin,
      'isPointsOptin': isPointsOptin,
      'isTimiOptin': isTimiOptin,
      'isPointConverted': isPointConverted,
      'pointConverted': pointConverted,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'createdAtString': createdAtString,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'updatedAtString': updatedAtString,
    };
  }

  factory AutoOptinLogModel.fromMap(Map<String, dynamic> map) {
    return AutoOptinLogModel(
      id: map['id'] ?? '',
      address: map['address'] ?? '',
      txId: map['txId'] ?? '',
      user: map['user'] != null ? User.fromMap(map['user']) : null,
      delayInSeconds: map['delayInSeconds'] ?? 0,
      algorandTransferAmount: map['algorandTransferAmount'] ?? 0,
      isLevelOptin: map['isLevelOptin'] ?? false,
      isLovesOptin: map['isLovesOptin'] ?? false,
      isPointsOptin: map['isPointsOptin'] ?? false,
      isTimiOptin: map['isTimiOptin'] ?? false,
      isPointConverted: map['isPointConverted'] ?? false,
      pointConverted: map['pointConverted'] ?? 0,
      createdAt: map['createdAt'] is String
          ? DateTime.tryParse(map['createdAt'])
          : null,
      createdAtString: map['createdAtString'] ?? '',
      updatedAt: map['updatedAt'] is String
          ? DateTime.tryParse(map['updatedAt'])
          : null,
      updatedAtString: map['updatedAtString'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AutoOptinLogModel.fromJson(String source) =>
      AutoOptinLogModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AutoOptinLogModel(id: $id, address: $address, txId: $txId, user: $user, delayInSeconds: $delayInSeconds, algorandTransferAmount: $algorandTransferAmount, isLevelOptin: $isLevelOptin, isLovesOptin: $isLovesOptin, isPointsOptin: $isPointsOptin, isTimiOptin: $isTimiOptin, isPointConverted: $isPointConverted, pointConverted: $pointConverted, createdAt: $createdAt, createdAtString: $createdAtString, updatedAt: $updatedAt, updatedAtString: $updatedAtString)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutoOptinLogModel &&
        other.id == id &&
        other.address == address &&
        other.txId == txId &&
        other.user == user &&
        other.delayInSeconds == delayInSeconds &&
        other.algorandTransferAmount == algorandTransferAmount &&
        other.isLevelOptin == isLevelOptin &&
        other.isLovesOptin == isLovesOptin &&
        other.isPointsOptin == isPointsOptin &&
        other.isTimiOptin == isTimiOptin &&
        other.isPointConverted == isPointConverted &&
        other.pointConverted == pointConverted &&
        other.createdAt == createdAt &&
        other.createdAtString == createdAtString &&
        other.updatedAt == updatedAt &&
        other.updatedAtString == updatedAtString;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        address.hashCode ^
        txId.hashCode ^
        user.hashCode ^
        delayInSeconds.hashCode ^
        algorandTransferAmount.hashCode ^
        isLevelOptin.hashCode ^
        isLovesOptin.hashCode ^
        isPointsOptin.hashCode ^
        isTimiOptin.hashCode ^
        isPointConverted.hashCode ^
        pointConverted.hashCode ^
        createdAt.hashCode ^
        createdAtString.hashCode ^
        updatedAt.hashCode ^
        updatedAtString.hashCode;
  }
}

class AlgorandLogModel {
  final String id;
  final num amount;
  final num fee;
  final String from;
  final String to;
  final String requester;
  final String txid;
  final DateTime? createdAt;
  final String createdAtString;
  final DateTime? updatedAt;
  final String updatedAtString;
  AlgorandLogModel({
    required this.id,
    required this.amount,
    required this.fee,
    required this.from,
    required this.to,
    required this.requester,
    required this.txid,
    this.createdAt,
    required this.createdAtString,
    this.updatedAt,
    required this.updatedAtString,
  });

  AlgorandLogModel copyWith({
    String? id,
    num? amount,
    num? fee,
    String? from,
    String? to,
    String? requester,
    String? txid,
    DateTime? createdAt,
    String? createdAtString,
    DateTime? updatedAt,
    String? updatedAtString,
  }) {
    return AlgorandLogModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      from: from ?? this.from,
      to: to ?? this.to,
      requester: requester ?? this.requester,
      txid: txid ?? this.txid,
      createdAt: createdAt ?? this.createdAt,
      createdAtString: createdAtString ?? this.createdAtString,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedAtString: updatedAtString ?? this.updatedAtString,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'fee': fee,
      'from': from,
      'to': to,
      'requester': requester,
      'txid': txid,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'createdAtString': createdAtString,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'updatedAtString': updatedAtString,
    };
  }

  factory AlgorandLogModel.fromMap(Map<String, dynamic> map) {
    return AlgorandLogModel(
      id: map['id'] ?? '',
      amount: map['amount'] ?? 0,
      fee: map['fee'] ?? 0,
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      requester: map['requester'] ?? '',
      txid: map['txid'] ?? '',
      createdAt: map['createdAt'] is String
          ? DateTime.tryParse(map['createdAt'])
          : null,
      createdAtString: map['createdAtString'] ?? '',
      updatedAt: map['updatedAt'] is String
          ? DateTime.tryParse(map['updatedAt'])
          : null,
      updatedAtString: map['updatedAtString'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AlgorandLogModel.fromJson(String source) =>
      AlgorandLogModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AlgorandLogModel(id: $id, amount: $amount, fee: $fee, from: $from, to: $to, requester: $requester, txid: $txid, createdAt: $createdAt, createdAtString: $createdAtString, updatedAt: $updatedAt, updatedAtString: $updatedAtString)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AlgorandLogModel &&
        other.id == id &&
        other.amount == amount &&
        other.fee == fee &&
        other.from == from &&
        other.to == to &&
        other.requester == requester &&
        other.txid == txid &&
        other.createdAt == createdAt &&
        other.createdAtString == createdAtString &&
        other.updatedAt == updatedAt &&
        other.updatedAtString == updatedAtString;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        fee.hashCode ^
        from.hashCode ^
        to.hashCode ^
        requester.hashCode ^
        txid.hashCode ^
        createdAt.hashCode ^
        createdAtString.hashCode ^
        updatedAt.hashCode ^
        updatedAtString.hashCode;
  }
}
