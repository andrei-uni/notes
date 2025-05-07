import 'package:notes/core/models/note.dart';
import 'package:notes/core/models/note_data.dart';
import 'package:notes/core/models/notes_sort_mode.dart';

abstract interface class NotesRepository {
  Future<List<Note>> getNotes({
    required int limit,
    required int offset,
    required NotesSortMode notesSortMode,
    required String? searchQuery,
  });

  Future<Note?> getNote({required int noteId});

  Future<Note> addNote(NoteData note);

  Future<void> deleteNote({required int noteId});

  Future<void> updateNote(Note note);
}
