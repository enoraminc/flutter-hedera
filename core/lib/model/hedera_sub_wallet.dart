import 'dart:convert';

import 'package:collection/collection.dart';

class HederaSubWallet {
  final String id;
  final String accountId;
  final String privateKey;
  final String state;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String network;

  final String title;
  final String description;
  final List<String> users;

  HederaSubWallet({
    required this.id,
    required this.accountId,
    required this.privateKey,
    required this.state,
    this.createdAt,
    this.updatedAt,
    required this.network,
    required this.title,
    required this.description,
    required this.users,
  });

  factory HederaSubWallet.empty() {
    return HederaSubWallet(
      id: "",
      accountId: "",
      description: "",
      network: "",
      privateKey: "",
      state: "",
      title: "",
      users: [],
    );
  }

  HederaSubWallet copyWith({
    String? id,
    String? accountId,
    String? privateKey,
    String? state,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? network,
    String? title,
    String? description,
    List<String>? users,
  }) {
    return HederaSubWallet(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      privateKey: privateKey ?? this.privateKey,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      network: network ?? this.network,
      title: title ?? this.title,
      description: description ?? this.description,
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountId': accountId,
      'privateKey': privateKey,
      'state': state,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'network': network,
      'title': title,
      'description': description,
      'users': users,
    };
  }

  factory HederaSubWallet.fromMap(Map<String, dynamic> map) {
    return HederaSubWallet(
      id: map['id'] ?? '',
      accountId: map['accountId'] ?? '',
      privateKey: map['privateKey'] ?? '',
      state: map['state'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      network: map['network'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      users: List<String>.from(map['users']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HederaSubWallet.fromJson(String source) =>
      HederaSubWallet.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HederaSubWallet(id: $id, accountId: $accountId, privateKey: $privateKey, state: $state, createdAt: $createdAt, updatedAt: $updatedAt, network: $network, title: $title, description: $description, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is HederaSubWallet &&
        other.id == id &&
        other.accountId == accountId &&
        other.privateKey == privateKey &&
        other.state == state &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.network == network &&
        other.title == title &&
        other.description == description &&
        listEquals(other.users, users);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        accountId.hashCode ^
        privateKey.hashCode ^
        state.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        network.hashCode ^
        title.hashCode ^
        description.hashCode ^
        users.hashCode;
  }
}
