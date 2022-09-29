import 'package:hedera_core/apis/journal_api.dart';
import 'package:lumbung_common/model/hedera/concensus_model.dart';
import 'package:lumbung_common/model/hedera/journal_model.dart';
import 'package:lumbung_common/model/hedera/cashbon_journal_model.dart';
import 'package:lumbung_common/utils/log.dart';
import 'package:lumbung_common/base/base_repository.dart';

class JournalApiImpl extends JournalApi {
  late final String url;

  final String firebase = "lumbunghedera";

  JournalApiImpl({
    required this.url,
  });

  @override
  Future<List<JournalModel>> getJournal({String? subWalletId}) async {
    try {
      final data = await request(
        '$url/journal?id=$subWalletId',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data.map<JournalModel>((e) => JournalModel.fromMap(e)).toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "getBook");
      rethrow;
    }
  }

  @override
  Future<JournalModel> setJournal(JournalModel book) async {
    if (book.memberList.isEmpty) {
      throw Exception("Member list cant be empty");
    }
    try {
      final data = await request(
        '$url/journal',
        RequestType.post,
        body: book.toMap(),
        useToken: true,
        firebase: firebase,
      );

      return JournalModel.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "setBook");
      rethrow;
    }
  }

  @override
  Future<CashbonJournalItemModel> submitCashbonMember(
      {required String bookId,
      required int amount,
      required String type}) async {
    if (bookId.isEmpty) {
      throw Exception("Journal id cant be empty");
    }
    if (type.isEmpty) {
      throw Exception("Type cant be empty");
    }
    if (amount <= 0) {
      throw Exception("Amount must be higher than 0");
    }
    try {
      final data = await request(
        '$url/journal/pod/submit',
        RequestType.post,
        body: {
          "journalId": bookId,
          "amount": amount,
          "type": type.toLowerCase(),
        },
        useToken: true,
        firebase: firebase,
      );

      return CashbonJournalItemModel.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "submitCashbonMember");
      rethrow;
    }
  }
}
