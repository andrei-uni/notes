part of 'edit_note_bloc.dart';

@freezed
sealed class EditNoteState with _$EditNoteState {
  const EditNoteState._();

  const factory EditNoteState.idle({
    required Note? loadedNote,
  }) = EditNoteState_Idle;

  const factory EditNoteState.loadedNote({
    required Note loadedNote,
  }) = EditNoteState_LoadedNote;

  const factory EditNoteState.loadedNoteFailure() = EditNoteState_LoadedNoteFailure;

  const factory EditNoteState.success() = EditNoteState_Success;

  Note? get loadedNote => switch (this) {
        EditNoteState_Idle(:final loadedNote) => loadedNote,
        EditNoteState_LoadedNote(:final loadedNote) => loadedNote,
        EditNoteState_LoadedNoteFailure() => null,
        EditNoteState_Success() => null,
      };
}
