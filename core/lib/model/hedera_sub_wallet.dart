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
  final List<UserData> userList;

  static String activeState = "Active";
  static String deletedState = "Deleted";

  bool isDeleted() => state == deletedState;

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
    required this.userList,
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
      userList: [],
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
    List<UserData>? userList,
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
      userList: userList ?? this.userList,
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
      'userList': userList.map((x) => x.toMap()).toList(),
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
      userList: List<UserData>.from(
          (map['userList'] ?? []).map((x) => UserData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory HederaSubWallet.fromJson(String source) =>
      HederaSubWallet.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HederaSubWallet(id: $id, accountId: $accountId, privateKey: $privateKey, state: $state, createdAt: $createdAt, updatedAt: $updatedAt, network: $network, title: $title, description: $description, users: $users, userList: $userList)';
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
        listEquals(other.users, users) &&
        listEquals(other.userList, userList);
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
        users.hashCode ^
        userList.hashCode;
  }
}

class UserData {
  final String name;
  final String email;
  final String avatarUrl;
  UserData({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  UserData copyWith({
    String? name,
    String? email,
    String? avatarUrl,
  }) {
    return UserData(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserData(name: $name, email: $email, avatarUrl: $avatarUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserData &&
        other.name == name &&
        other.email == email &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ avatarUrl.hashCode;
}
