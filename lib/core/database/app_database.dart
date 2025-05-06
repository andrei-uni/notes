import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:notes/core/database/tables/notes_table.dart';
import 'package:notes/core/models/notes_sort_mode.dart';

part 'app_database.g.dart';
part 'notes_mixin.dart';

@DriftDatabase(
  tables: [
    NotesTable,
  ],
)
class AppDatabase extends _$AppDatabase with _NotesMixin {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'app_database');
  }
}
