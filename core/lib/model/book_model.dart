import 'dart:convert';

import 'package:collection/collection.dart';

class BookModel {
  final String id;
  final String title;
  final String description;
  final String subWalletId;
  final List<MemberBook> memberBookList;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String network;
  BookModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subWalletId,
    required this.memberBookList,
    this.createdAt,
    this.updatedAt,
    required this.network,
  });

  BookModel copyWith({
    String? id,
    String? title,
    String? description,
    String? subWalletId,
    List<MemberBook>? memberBookList,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? network,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subWalletId: subWalletId ?? this.subWalletId,
      memberBookList: memberBookList ?? this.memberBookList,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      network: network ?? this.network,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subWalletId': subWalletId,
      'memberBookList': memberBookList.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'network': network,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      subWalletId: map['subWalletId'] ?? '',
      memberBookList: List<MemberBook>.from(
          map['memberBookList']?.map((x) => MemberBook.fromMap(x))),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      network: map['network'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BookModel.fromJson(String source) =>
      BookModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookModel(id: $id, title: $title, description: $description, subWalletId: $subWalletId, memberBookList: $memberBookList, createdAt: $createdAt, updatedAt: $updatedAt, network: $network)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is BookModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.subWalletId == subWalletId &&
        listEquals(other.memberBookList, memberBookList) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.network == network;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        subWalletId.hashCode ^
        memberBookList.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        network.hashCode;
  }
}

class BookItem {
  final int sequenceNumber;
  final String bookId;
  final String subWalletId;
  final DateTime? date;
  final MemberBook memberBook;
  final int debit;
  final int credit;
  BookItem({
    required this.sequenceNumber,
    required this.bookId,
    required this.subWalletId,
    this.date,
    required this.memberBook,
    required this.debit,
    required this.credit,
  });

  BookItem copyWith({
    int? sequenceNumber,
    String? bookId,
    String? subWalletId,
    DateTime? date,
    MemberBook? memberBook,
    int? debit,
    int? credit,
  }) {
    return BookItem(
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      bookId: bookId ?? this.bookId,
      subWalletId: subWalletId ?? this.subWalletId,
      date: date ?? this.date,
      memberBook: memberBook ?? this.memberBook,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sequenceNumber': sequenceNumber,
      'bookId': bookId,
      'subWalletId': subWalletId,
      'date': date?.millisecondsSinceEpoch,
      'memberBook': memberBook.toMap(),
      'debit': debit,
      'credit': credit,
    };
  }

  factory BookItem.fromMap(Map<String, dynamic> map) {
    return BookItem(
      sequenceNumber: map['sequenceNumber']?.toInt() ?? 0,
      bookId: map['bookId'] ?? '',
      subWalletId: map['subWalletId'] ?? '',
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : null,
      memberBook: MemberBook.fromMap(map['memberBook']),
      debit: map['debit']?.toInt() ?? 0,
      credit: map['credit']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookItem.fromJson(String source) =>
      BookItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookItem(sequenceNumber: $sequenceNumber, bookId: $bookId, subWalletId: $subWalletId, date: $date, memberBook: $memberBook, debit: $debit, credit: $credit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookItem &&
        other.sequenceNumber == sequenceNumber &&
        other.bookId == bookId &&
        other.subWalletId == subWalletId &&
        other.date == date &&
        other.memberBook == memberBook &&
        other.debit == debit &&
        other.credit == credit;
  }

  @override
  int get hashCode {
    return sequenceNumber.hashCode ^
        bookId.hashCode ^
        subWalletId.hashCode ^
        date.hashCode ^
        memberBook.hashCode ^
        debit.hashCode ^
        credit.hashCode;
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
