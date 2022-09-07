import 'dart:convert';

import 'package:collection/collection.dart';

class BookModel {
  final String id;
  final String topicId;
  final String title;
  final String description;
  final String subWalletId;
  final String type;
  final List<MemberBook> memberBookList;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String network;
  final String state;

  BookModel({
    required this.id,
    required this.topicId,
    required this.title,
    required this.description,
    required this.subWalletId,
    required this.type,
    required this.memberBookList,
    this.createdAt,
    this.updatedAt,
    required this.network,
    required this.state,
  });

  static String activeState = "Active";
  static String deletedState = "Deleted";

  static String cashbonType = "Cashbon";

  static List<String> typeList = [cashbonType];

  BookModel copyWith({
    String? id,
    String? topicId,
    String? title,
    String? description,
    String? subWalletId,
    String? type,
    List<MemberBook>? memberBookList,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? network,
    String? state,
  }) {
    return BookModel(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      description: description ?? this.description,
      subWalletId: subWalletId ?? this.subWalletId,
      type: type ?? this.type,
      memberBookList: memberBookList ?? this.memberBookList,
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
      'memberBookList': memberBookList.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'network': network,
      'state': state,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] ?? '',
      topicId: map['topicId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      subWalletId: map['subWalletId'] ?? '',
      type: map['type'] ?? '',
      memberBookList: List<MemberBook>.from(
          map['memberBookList']?.map((x) => MemberBook.fromMap(x))),
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

  factory BookModel.fromJson(String source) =>
      BookModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookModel(id: $id, topicId: $topicId, title: $title, description: $description, subWalletId: $subWalletId, type: $type, memberBookList: $memberBookList, createdAt: $createdAt, updatedAt: $updatedAt, network: $network, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is BookModel &&
        other.id == id &&
        other.topicId == topicId &&
        other.title == title &&
        other.description == description &&
        other.subWalletId == subWalletId &&
        other.type == type &&
        listEquals(other.memberBookList, memberBookList) &&
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
        memberBookList.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        network.hashCode ^
        state.hashCode;
  }
}

class MemberBook {
  final String name;
  final String email;
  final int limitPayable;
  MemberBook({
    required this.name,
    required this.email,
    required this.limitPayable,
  });

  MemberBook copyWith({
    String? name,
    String? email,
    int? limitPayable,
  }) {
    return MemberBook(
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

  factory MemberBook.fromMap(Map<String, dynamic> map) {
    return MemberBook(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      limitPayable: map['limitPayable']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberBook.fromJson(String source) =>
      MemberBook.fromMap(json.decode(source));

  @override
  String toString() =>
      'MemberBook(name: $name, email: $email, limitPayable: $limitPayable)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MemberBook &&
        other.name == name &&
        other.email == email &&
        other.limitPayable == limitPayable;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ limitPayable.hashCode;
}

class BookMessageDataModel {
  final String data;
  final int topicSequenceNumber;
  BookMessageDataModel({
    required this.data,
    required this.topicSequenceNumber,
  });

  BookMessageDataModel copyWith({
    String? data,
    int? topicSequenceNumber,
  }) {
    return BookMessageDataModel(
      data: data ?? this.data,
      topicSequenceNumber: topicSequenceNumber ?? this.topicSequenceNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'topicSequenceNumber': topicSequenceNumber,
    };
  }

  factory BookMessageDataModel.fromMap(Map<String, dynamic> map) {
    return BookMessageDataModel(
      data: map['data'] ?? '',
      topicSequenceNumber: map['topicSequenceNumber']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookMessageDataModel.fromJson(String source) =>
      BookMessageDataModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'BookMessageDataModel(data: $data, topicSequenceNumber: $topicSequenceNumber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookMessageDataModel &&
        other.data == data &&
        other.topicSequenceNumber == topicSequenceNumber;
  }

  @override
  int get hashCode => data.hashCode ^ topicSequenceNumber.hashCode;
}
