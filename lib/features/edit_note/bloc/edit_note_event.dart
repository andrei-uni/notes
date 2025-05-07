part of 'edit_note_bloc.dart';

@freezed
sealed class EditNoteEvent with _$EditNoteEvent {
  const factory EditNoteEvent.loadNote({
    required int noteId,
  }) = _LoadNote;

  const factory EditNoteEvent.saveNote({
    required String title,
    required String content,
  }) = _SaveNote;

  const factory EditNoteEvent.deleteNote() = _DeleteNote;
}
