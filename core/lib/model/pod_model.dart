import 'dart:convert';

import 'journal_model.dart';

class PodModel {
  final int id;
  final GrainNoteModel? note;
  final LaciModel? laci;
  final String partiA;
  final String partiB;
  PodModel({
    required this.id,
    required this.note,
    required this.laci,
    required this.partiA,
    required this.partiB,
  });

  PodModel copyWith({
    int? id,
    GrainNoteModel? note,
    LaciModel? laci,
    String? partiA,
    String? partiB,
  }) {
    return PodModel(
      id: id ?? this.id,
      note: note ?? this.note,
      laci: laci ?? this.laci,
      partiA: partiA ?? this.partiA,
      partiB: partiB ?? this.partiB,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note': note?.toMap(),
      'laci': laci?.toMap(),
      'partiA': partiA,
      'partiB': partiB,
    };
  }

  factory PodModel.fromMap(Map<String, dynamic> map) {
    return PodModel(
      id: map['id']?.toInt() ?? 0,
      note: map['note'] != null ? GrainNoteModel.fromMap(map['note']) : null,
      laci: map['laci'] != null ? LaciModel.fromMap(map['laci']) : null,
      partiA: map['partiA'] ?? '',
      partiB: map['partiB'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PodModel.fromJson(String source) =>
      PodModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PodModel(id: $id, note: $note, laci: $laci, partiA: $partiA, partiB: $partiB)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PodModel &&
        other.id == id &&
        other.note == note &&
        other.laci == laci &&
        other.partiA == partiA &&
        other.partiB == partiB;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        note.hashCode ^
        laci.hashCode ^
        partiA.hashCode ^
        partiB.hashCode;
  }
}

class GrainNoteModel {
  final String message;
  final DateTime dateTimeWib;
  GrainNoteModel({
    required this.message,
    required this.dateTimeWib,
  });

  GrainNoteModel copyWith({
    String? message,
    DateTime? dateTimeWib,
  }) {
    return GrainNoteModel(
      message: message ?? this.message,
      dateTimeWib: dateTimeWib ?? this.dateTimeWib,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'dateTimeWib': dateTimeWib.millisecondsSinceEpoch,
    };
  }

  factory GrainNoteModel.fromMap(Map<String, dynamic> map) {
    return GrainNoteModel(
      message: map['message'] ?? '',
      dateTimeWib: DateTime.fromMillisecondsSinceEpoch(map['dateTimeWib']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GrainNoteModel.fromJson(String source) =>
      GrainNoteModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'GrainNote(message: $message, dateTimeWib: $dateTimeWib)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GrainNoteModel &&
        other.message == message &&
        other.dateTimeWib == dateTimeWib;
  }

  @override
  int get hashCode => message.hashCode ^ dateTimeWib.hashCode;
}

class LaciModel {
  final String journalId;
  final String subWalletId;
  final DateTime date;
  final MemberModel member;
  final int debit;
  final int credit;
  LaciModel({
    required this.journalId,
    required this.subWalletId,
    required this.date,
    required this.member,
    required this.debit,
    required this.credit,
  });

  LaciModel copyWith({
    String? journalId,
    String? subWalletId,
    DateTime? date,
    MemberModel? member,
    int? debit,
    int? credit,
  }) {
    return LaciModel(
      journalId: journalId ?? this.journalId,
      subWalletId: subWalletId ?? this.subWalletId,
      date: date ?? this.date,
      member: member ?? this.member,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'journalId': journalId,
      'subWalletId': subWalletId,
      'date': date.millisecondsSinceEpoch,
      'member': member.toMap(),
      'debit': debit,
      'credit': credit,
    };
  }

  factory LaciModel.fromMap(Map<String, dynamic> map) {
    return LaciModel(
      journalId: map['journalId'] ?? '',
      subWalletId: map['subWalletId'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      member: MemberModel.fromMap(map['member']),
      debit: map['debit']?.toInt() ?? 0,
      credit: map['credit']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LaciModel.fromJson(String source) =>
      LaciModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LaciModel(journalId: $journalId, subWalletId: $subWalletId, date: $date, member: $member, debit: $debit, credit: $credit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LaciModel &&
        other.journalId == journalId &&
        other.subWalletId == subWalletId &&
        other.date == date &&
        other.member == member &&
        other.debit == debit &&
        other.credit == credit;
  }

  @override
  int get hashCode {
    return journalId.hashCode ^
        subWalletId.hashCode ^
        date.hashCode ^
        member.hashCode ^
        debit.hashCode ^
        credit.hashCode;
  }
}
