import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes/core/models/note.dart';
import 'package:notes/core/models/note_data.dart';
import 'package:notes/core/notes_changes_notifier/models/notes_changed.dart';
import 'package:notes/core/notes_changes_notifier/notes_changes_notifier.dart';
import 'package:notes/core/notes_repository/notes_repository.dart';

part 'edit_note_event.dart';
part 'edit_note_state.dart';
part 'edit_note_bloc.freezed.dart';

class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  EditNoteBloc({
    required NotesRepository notesRepository,
    required NotesChangesReporter notesChangesReporter,
  })  : _notesRepository = notesRepository,
        _notesChangesReporter = notesChangesReporter,
        super(const EditNoteState.idle(loadedNote: null)) {
    on<EditNoteEvent>(
      (event, emit) async => switch (event) {
        _LoadNote() => _onLoadNote(event, emit),
        _SaveNote() => _onSaveNote(event, emit),
        _DeleteNote() => _onDeleteNote(event, emit),
      },
    );
  }

  final NotesRepository _notesRepository;
  final NotesChangesReporter _notesChangesReporter;

  Future<void> _onLoadNote(_LoadNote event, Emitter<EditNoteState> emit) async {
    final note = await _notesRepository.getNote(noteId: event.noteId);

    if (note == null) {
      emit(const EditNoteState.loadedNoteFailure());
      return;
    }

    emit(EditNoteState.loadedNote(loadedNote: note));
    emit(EditNoteState.idle(loadedNote: note));
  }

  Future<void> _onSaveNote(_SaveNote event, Emitter<EditNoteState> emit) async {
    final loadedNote = state.loadedNote;

    if (loadedNote == null) {
      final newNoteDate = NoteData(
        title: event.title,
        content: event.content,
        creationDate: DateTime.now(),
      );

      final newNote = await _notesRepository.addNote(newNoteDate);
      _notesChangesReporter.report(NotesChangedEvent.addedNote(noteId: newNote.id));

      emit(const EditNoteState.success());
      return;
    }

    final updatedNote = Note(
      id: loadedNote.id,
      title: event.title,
      content: event.content,
      creationDate: loadedNote.creationDate,
    );

    await _notesRepository.updateNote(updatedNote);
    _notesChangesReporter.report(NotesChangedEvent.updatedNote(noteId: loadedNote.id));

    emit(const EditNoteState.success());
  }

  Future<void> _onDeleteNote(_DeleteNote event, Emitter<EditNoteState> emit) async {
    assert(state.loadedNote != null);

    final loadedNote = state.loadedNote!;

    await _notesRepository.deleteNote(noteId: loadedNote.id);
    _notesChangesReporter.report(NotesChangedEvent.deletedNote(noteId: loadedNote.id));

    emit(const EditNoteState.success());
  }
}
