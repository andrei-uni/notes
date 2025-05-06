import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_changed.freezed.dart';

@freezed
sealed class NotesChangedEvent with _$NotesChangedEvent {
  const factory NotesChangedEvent.addedNote({
    required int noteId,
  }) = NotesChangedEvent_AddedNote;

  const factory NotesChangedEvent.updatedNote({
    required int noteId,
  }) = NotesChangedEvent_UpdatedNote;

  const factory NotesChangedEvent.deletedNote({
    required int noteId,
  }) = NotesChangedEvent_DeletedNote;
}
