import 'dart:convert';

import 'package:collection/collection.dart';

class JournalModel {
  final String id;
  final String topicId;
  final String title;
  final String description;
  final String subWalletId;
  final String type;
  final List<MemberModel> memberList;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String network;
  final String state;

  JournalModel({
    required this.id,
    required this.topicId,
    required this.title,
    required this.description,
    required this.subWalletId,
    required this.type,
    required this.memberList,
    this.createdAt,
    this.updatedAt,
    required this.network,
    required this.state,
  });

  static String activeState = "Active";
  static String deletedState = "Deleted";

  static String cashbonType = "Cashbon";

  static List<String> typeList = [cashbonType];

  JournalModel copyWith({
    String? id,
    String? topicId,
    String? title,
    String? description,
    String? subWalletId,
    String? type,
    List<MemberModel>? memberList,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? network,
    String? state,
  }) {
    return JournalModel(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      description: description ?? this.description,
      subWalletId: subWalletId ?? this.subWalletId,
      type: type ?? this.type,
      memberList: memberList ?? this.memberList,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      network: network ?? this.network,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'title': title,
      'description': description,
      'subWalletId': subWalletId,
      'type': type,
      'memberList': memberList.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'network': network,
      'state': state,
    };
  }

  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      id: map['id'] ?? '',
      topicId: map['topicId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      subWalletId: map['subWalletId'] ?? '',
      type: map['type'] ?? '',
      memberList: List<MemberModel>.from(
          map['memberList']?.map((x) => MemberModel.fromMap(x))),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      network: map['network'] ?? '',
      state: map['state'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JournalModel.fromJson(String source) =>
      JournalModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JournalModel(id: $id, topicId: $topicId, title: $title, description: $description, subWalletId: $subWalletId, type: $type, memberList: $memberList, createdAt: $createdAt, updatedAt: $updatedAt, network: $network, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is JournalModel &&
        other.id == id &&
        other.topicId == topicId &&
        other.title == title &&
        other.description == description &&
        other.subWalletId == subWalletId &&
        other.type == type &&
        listEquals(other.memberList, memberList) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.network == network &&
        other.state == state;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        topicId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        subWalletId.hashCode ^
        type.hashCode ^
        memberList.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        network.hashCode ^
        state.hashCode;
  }
}

class MemberModel {
  final String name;
  final String email;
  final int limitPayable;
  MemberModel({
    required this.name,
    required this.email,
    required this.limitPayable,
  });

  MemberModel copyWith({
    String? name,
    String? email,
    int? limitPayable,
  }) {
    return MemberModel(
      name: name ?? this.name,
      email: email ?? this.email,
      limitPayable: limitPayable ?? this.limitPayable,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'limitPayable': limitPayable,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      limitPayable: map['limitPayable']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) =>
      MemberModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'MemberModel(name: $name, email: $email, limitPayable: $limitPayable)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MemberModel &&
        other.name == name &&
        other.email == email &&
        other.limitPayable == limitPayable;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ limitPayable.hashCode;
}
