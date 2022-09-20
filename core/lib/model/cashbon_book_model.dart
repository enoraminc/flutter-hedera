import 'dart:convert';

import 'package:core/model/journal_model.dart';

class CashbonBookItemModel {
  final int sequenceNumber;
  final String bookId;
  final String subWalletId;
  final DateTime? date;
  final MemberModel memberBook;
  final int debit;
  final int credit;

  CashbonBookItemModel({
    required this.sequenceNumber,
    required this.bookId,
    required this.subWalletId,
    this.date,
    required this.memberBook,
    required this.debit,
    required this.credit,
  });

  CashbonBookItemModel copyWith({
    int? sequenceNumber,
    String? bookId,
    String? subWalletId,
    DateTime? date,
    MemberModel? memberBook,
    int? debit,
    int? credit,
  }) {
    return CashbonBookItemModel(
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

  factory CashbonBookItemModel.fromMap(Map<String, dynamic> map) {
    return CashbonBookItemModel(
      sequenceNumber: map['sequenceNumber']?.toInt() ?? 0,
      bookId: map['bookId'] ?? '',
      subWalletId: map['subWalletId'] ?? '',
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : null,
      memberBook: MemberModel.fromMap(map['memberBook']),
      debit: map['debit']?.toInt() ?? 0,
      credit: map['credit']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashbonBookItemModel.fromJson(String source) =>
      CashbonBookItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CashbonBookItemModel(sequenceNumber: $sequenceNumber, bookId: $bookId, subWalletId: $subWalletId, date: $date, memberBook: $memberBook, debit: $debit, credit: $credit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CashbonBookItemModel &&
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
