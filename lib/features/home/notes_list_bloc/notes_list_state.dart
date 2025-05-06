part of 'notes_list_bloc.dart';

@freezed
abstract class NotesListState with _$NotesListState {
  const factory NotesListState({
    required PagingState<int, Note> notesPagingState,
    required NotesSortMode notesSortMode,
    required String? searchQuery,
  }) = _NotesListState;
}
