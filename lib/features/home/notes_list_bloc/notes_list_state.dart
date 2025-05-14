part of 'notes_list_bloc.dart';

@freezed
sealed class NotesListState with _$NotesListState {
  const NotesListState._();

  const factory NotesListState.idle({
    required CustomPagingState<int, Note> notesPagingState,
    required NotesSortMode notesSortMode,
    required String? searchQuery,
  }) = NotesListState_Idle;

  const factory NotesListState.failedToUpdateNote({
    required CustomPagingState<int, Note> notesPagingState,
    required NotesSortMode notesSortMode,
    required String? searchQuery,
  }) = NotesListState_FailedToUpdateNote;

  NotesListState_Idle idle() {
    return NotesListState_Idle(
      notesPagingState: notesPagingState,
      notesSortMode: notesSortMode,
      searchQuery: searchQuery,
    );
  }

  NotesListState_FailedToUpdateNote failedToUpdateNote() {
    return NotesListState_FailedToUpdateNote(
      notesPagingState: notesPagingState,
      notesSortMode: notesSortMode,
      searchQuery: searchQuery,
    );
  }
}
