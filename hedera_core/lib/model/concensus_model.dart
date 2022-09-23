import 'dart:convert';

class ConcensusMessageDataModel {
  final String data;
  final int topicSequenceNumber;
  ConcensusMessageDataModel({
    required this.data,
    required this.topicSequenceNumber,
  });

  ConcensusMessageDataModel copyWith({
    String? data,
    int? topicSequenceNumber,
  }) {
    return ConcensusMessageDataModel(
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

  factory ConcensusMessageDataModel.fromMap(Map<String, dynamic> map) {
    return ConcensusMessageDataModel(
      data: map['data'] ?? '',
      topicSequenceNumber: map['topicSequenceNumber']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConcensusMessageDataModel.fromJson(String source) =>
      ConcensusMessageDataModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'BookMessageDataModel(data: $data, topicSequenceNumber: $topicSequenceNumber)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConcensusMessageDataModel &&
        other.data == data &&
        other.topicSequenceNumber == topicSequenceNumber;
  }

  @override
  int get hashCode => data.hashCode ^ topicSequenceNumber.hashCode;
}
