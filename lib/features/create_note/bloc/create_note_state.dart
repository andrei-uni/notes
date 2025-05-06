part of 'create_note_bloc.dart';

@freezed
sealed class CreateNoteState with _$CreateNoteState {
  const CreateNoteState._();

  const factory CreateNoteState.idle({
    required Note? loadedNote,
  }) = CreateNoteState_Idle;

  const factory CreateNoteState.loadedNote({
    required Note loadedNote,
  }) = CreateNoteState_LoadedNote;

  const factory CreateNoteState.success() = CreateNoteState_Success;

  Note? get loadedNote => switch (this) {
        CreateNoteState_Idle(:final loadedNote) => loadedNote,
        CreateNoteState_LoadedNote(:final loadedNote) => loadedNote,
        CreateNoteState_Success() => null,
      };
}
