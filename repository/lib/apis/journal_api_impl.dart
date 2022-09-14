import 'package:core/apis/journal_api.dart';
import 'package:core/model/concensus_model.dart';
import 'package:core/model/journal_model.dart';
import 'package:core/model/cashbon_book_model.dart';
import 'package:lumbung_common/utils/log.dart';
import 'package:lumbung_common/base/base_repository.dart';

class JournalApiImpl extends JournalApi {
  late final String url;

  final String firebase = "lumbungalgo";

  JournalApiImpl({
    required this.url,
  });

  @override
  Future<List<JournalModel>> getJournal(String subWalletId) async {
    try {
      final data = await request(
        '$url/book?id=$subWalletId',
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
    if (book.memberBookList.isEmpty) {
      throw Exception("Member list cant be empty");
    }
    try {
      final data = await request(
        '$url/book',
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
  Future<List<ConcensusMessageDataModel>> getJournalMessageData(
      String topicId) async {
    try {
      final data = await request(
        '$url/consensus/message/$topicId',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data
          .map<ConcensusMessageDataModel>(
              (e) => ConcensusMessageDataModel.fromMap(e))
          .toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "getBookMessageData");
      rethrow;
    }
  }

  @override
  Future<CashbonBookItemModel> submitCashbonMember(
      {required String bookId,
      required int amount,
      required String type}) async {
    if (bookId.isEmpty) {
      throw Exception("Book id cant be empty");
    }
    if (type.isEmpty) {
      throw Exception("Type cant be empty");
    }
    if (amount <= 0) {
      throw Exception("Amount must be higher than 0");
    }
    try {
      final data = await request(
        '$url/book/cashbon/submit',
        RequestType.post,
        body: {
          "bookId": bookId,
          "amount": amount,
          "type": type.toLowerCase(),
        },
        useToken: true,
        firebase: firebase,
      );

      return CashbonBookItemModel.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "submitCashbonMember");
      rethrow;
    }
  }
}
