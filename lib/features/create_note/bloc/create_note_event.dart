part of 'create_note_bloc.dart';

@freezed
sealed class CreateNoteEvent with _$CreateNoteEvent {
  const factory CreateNoteEvent.loadNote({
    required int noteId,
  }) = _LoadNote;

  const factory CreateNoteEvent.saveNote({
    required String title,
    required String content,
  }) = _SaveNote;

  const factory CreateNoteEvent.deleteNote() = _DeleteNote;
}
