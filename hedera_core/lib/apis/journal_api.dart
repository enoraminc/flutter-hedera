import 'package:hedera_core/model/cashbon_book_model.dart';
import 'package:lumbung_common/base/base_repository.dart';

import '../model/concensus_model.dart';
import '../model/journal_model.dart';
import '../model/log_model.dart';

abstract class JournalApi extends BaseRepository {
  Future<JournalModel> setJournal(JournalModel book);
  Future<List<JournalModel>> getJournal({String? subWalletId});

  Future<CashbonBookItemModel> submitCashbonMember({
    required String bookId,
    required int amount,
    required String type,
  });
}
