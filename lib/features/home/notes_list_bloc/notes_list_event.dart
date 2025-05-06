part of 'notes_list_bloc.dart';

@freezed
sealed class NotesListEvent with _$NotesListEvent {
  const factory NotesListEvent.loadNotes() = _LoadNotes;

  const factory NotesListEvent.deleteNote({
    required int noteId,
  }) = _DeleteNote;

  const factory NotesListEvent.sortModeChanged({
    required NotesSortMode sortMode,
  }) = _SortModeChanged;

  const factory NotesListEvent.searchQueryChanged({
    required String? searchQuery,
  }) = _SearchQueryChanged;

  const factory NotesListEvent.notesChanged({
    required NotesChangedEvent change,
  }) = _NotesChanged;
}
