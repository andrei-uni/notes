import 'package:notes/core/database/app_database.dart';
import 'package:notes/core/models/note.dart';
import 'package:notes/core/models/note_data.dart';
import 'package:notes/core/models/notes_sort_mode.dart';
import 'package:notes/core/notes_repository/mappers/note_mapper.dart';
import 'package:notes/core/notes_repository/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl({
    required this.appDatabase,
  });

  final AppDatabase appDatabase;

  @override
  Future<Note> addNote(NoteData note) async {
    final row = note.toRowInsert();
    final newNote = await appDatabase.insertNote(row);
    return newNote.toModel();
  }

  @override
  Future<void> deleteNote({required int noteId}) async {
    await appDatabase.deleteNote(id: noteId);
  }

  @override
  Future<Note> getNote({required int noteId}) async {
    final row = await appDatabase.getNote(id: noteId);
    return row!.toModel(); //TODO
  }

  @override
  Future<List<Note>> getNotes({
    required int limit,
    required int offset,
    required NotesSortMode notesSortMode,
    required String? searchQuery,
  }) async {
    final rows = await appDatabase.getNotes(
      limit: limit,
      offset: offset,
      notesSortMode: notesSortMode,
      seachQuery: searchQuery,
    );
    return rows.map((r) => r.toModel()).toList();
  }

  @override
  Future<void> updateNote(Note note) async {
    final row = note.toRowUpdate();
    await appDatabase.updateNote(row);
  }
}
