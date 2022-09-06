import 'package:core/apis/book_api.dart';
import 'package:core/model/book_model.dart';
import 'package:lumbung_common/utils/log.dart';
import 'package:lumbung_common/base/base_repository.dart';

class BookApiImpl extends BookApi {
  late final String url;

  final String firebase = "lumbungalgo";

  BookApiImpl({
    required this.url,
  });

  @override
  Future<List<BookModel>> getBook(String subWalletId) async {
    try {
      final data = await request(
        '$url/book?id=$subWalletId',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data.map<BookModel>((e) => BookModel.fromMap(e)).toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "getBook");
      rethrow;
    }
  }

  @override
  Future<BookModel> setBook(BookModel book) async {
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

      return BookModel.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "setBook");
      rethrow;
    }
  }

  @override
  Future<List<BookMessageDataModel>> getBookMessageData(String topicId) async {
    try {
      final data = await request(
        '$url/consensus/message/$topicId',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data
          .map<BookMessageDataModel>((e) => BookMessageDataModel.fromMap(e))
          .toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "getBookMessageData");
      rethrow;
    }
  }
}
