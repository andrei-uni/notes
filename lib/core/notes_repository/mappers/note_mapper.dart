import 'package:drift/drift.dart';
import 'package:notes/core/database/app_database.dart';
import 'package:notes/core/models/note.dart';
import 'package:notes/core/models/note_data.dart';

extension NoteMapperModel on NotesTableData {
  Note toModel() {
    return Note(
      id: id,
      title: title,
      content: content,
      creationDate: creationDate,
    );
  }
}

extension NoteDataMapperTable on NoteData {
  NotesTableCompanion toRowInsert() {
    return NotesTableCompanion.insert(
      title: title,
      content: content,
      creationDate: creationDate,
    );
  }
}

extension NoteMapperTable on Note {
  NotesTableCompanion toRowUpdate() {
    return NotesTableCompanion.insert(
      id: Value(id),
      title: title,
      content: content,
      creationDate: creationDate,
    );
  }
}
