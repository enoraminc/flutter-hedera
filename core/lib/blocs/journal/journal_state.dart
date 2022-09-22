part of 'journal_cubit.dart';

@immutable
abstract class JournalState extends Equatable {
  final List<JournalModel> journalList;
  final JournalModel? selectedJournal;

  const JournalState(
      {required this.journalList, required this.selectedJournal});

  @override
  List<Object?> get props => [journalList, selectedJournal];
}

class JournalInitial extends JournalState {
  JournalInitial() : super(journalList: [], selectedJournal: null);
}

class JournalLoading extends JournalState {
  const JournalLoading({
    required super.journalList,
    required super.selectedJournal,
  });
}

class SubmitJournalLoading extends JournalState {
  const SubmitJournalLoading({
    required super.journalList,
    required super.selectedJournal,
  });
}

class JournalMessageLoading extends JournalState {
  const JournalMessageLoading({
    required super.journalList,
    required super.selectedJournal,
  });
}

class SetJournalSuccess extends JournalState {
  const SetJournalSuccess({
    required super.journalList,
    required super.selectedJournal,
  });
}

class GetJournalSuccess extends JournalState {
  const GetJournalSuccess({
    required super.journalList,
    required super.selectedJournal,
  });
}

class JournalFailed extends JournalState {
  final String message;
  const JournalFailed({
    required this.message,
    required super.journalList,
    required super.selectedJournal,
  });
}

class GetJournalMessageDataSuccess extends JournalState {
  final List<ConcensusMessageDataModel> data;
  const GetJournalMessageDataSuccess({
    required this.data,
    required super.journalList,
    required super.selectedJournal,
  });
}

class GetJournalMessageDataFailed extends JournalState {
  final String message;
  const GetJournalMessageDataFailed({
    required this.message,
    required super.journalList,
    required super.selectedJournal,
  });
}

class DeleteJournalSuccess extends JournalState {
  const DeleteJournalSuccess({
    required super.journalList,
    required super.selectedJournal,
  });
}

class DeleteJournalFailed extends JournalState {
  final String message;
  const DeleteJournalFailed({
    required this.message,
    required super.journalList,
    required super.selectedJournal,
  });
}

class ExportJournalSuccess extends JournalState {
  const ExportJournalSuccess({
    required super.journalList,
    required super.selectedJournal,
  });
}

class ExportJournalFailed extends JournalState {
  final String message;
  const ExportJournalFailed({
    required this.message,
    required super.journalList,
    required super.selectedJournal,
  });
}
