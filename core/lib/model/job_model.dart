import 'dart:convert';

import 'package:collection/collection.dart';

class JobModel {
  final String id;
  final String title;
  final String description;
  final String type;
  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
  });

  JobModel copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JobModel.fromJson(String source) =>
      JobModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JobModel(id: $id, title: $title, description: $description, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JobModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ description.hashCode ^ type.hashCode;
  }
}

class JobRequestModel {
  final int id;
  final String topicId;
  final String state;
  final String type;
  final Map<String, dynamic> data;
  final DateTime? createdAt;
  final DateTime? executeAt;
  final String message;
  final List<String> users;
  final String network;

  static String walletType = "Wallet";

  JobRequestModel({
    required this.id,
    required this.topicId,
    required this.state,
    required this.type,
    required this.data,
    this.createdAt,
    this.executeAt,
    required this.message,
    required this.users,
    required this.network,
  });

  JobRequestModel copyWith({
    int? id,
    String? topicId,
    String? state,
    String? type,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? executeAt,
    String? message,
    List<String>? users,
    String? network,
  }) {
    return JobRequestModel(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      state: state ?? this.state,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      executeAt: executeAt ?? this.executeAt,
      message: message ?? this.message,
      users: users ?? this.users,
      network: network ?? this.network,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'state': state,
      'type': type,
      'data': data,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'executeAt': executeAt?.millisecondsSinceEpoch,
      'message': message,
      'users': users,
      'network': network,
    };
  }

  factory JobRequestModel.fromMap(Map<String, dynamic> map) {
    return JobRequestModel(
      id: map['id']?.toInt() ?? 0,
      topicId: map['topicId'] ?? '',
      state: map['state'] ?? '',
      type: map['type'] ?? '',
      data: Map<String, dynamic>.from(map['data']),
      createdAt: map['createdAt'] != 0
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      executeAt: map['executeAt'] != 0
          ? DateTime.fromMillisecondsSinceEpoch(map['executeAt'])
          : null,
      message: map['message'] ?? '',
      users: List<String>.from(map['users']),
      network: map['network'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JobRequestModel.fromJson(String source) =>
      JobRequestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JobRequestModel(id: $id, topicId: $topicId, state: $state, type: $type, data: $data, createdAt: $createdAt, executeAt: $executeAt, message: $message, users: $users, network: $network)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;

    return other is JobRequestModel &&
        other.id == id &&
        other.topicId == topicId &&
        other.state == state &&
        other.type == type &&
        collectionEquals(other.data, data) &&
        other.createdAt == createdAt &&
        other.executeAt == executeAt &&
        other.message == message &&
        collectionEquals(other.users, users) &&
        other.network == network;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        topicId.hashCode ^
        state.hashCode ^
        type.hashCode ^
        data.hashCode ^
        createdAt.hashCode ^
        executeAt.hashCode ^
        message.hashCode ^
        users.hashCode ^
        network.hashCode;
  }
}
