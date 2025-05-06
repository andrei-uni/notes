part of 'app_database.dart';

mixin _NotesMixin on _$AppDatabase {
  Future<List<NotesTableData>> getNotes({
    required int limit,
    required int offset,
    required NotesSortMode notesSortMode,
    required String? seachQuery,
  }) async {
    final dateOrderingMode = switch (notesSortMode) {
      NotesSortMode.dateDesc => OrderingMode.desc,
      NotesSortMode.dateAsc => OrderingMode.asc,
    };

    final query = select(notesTable);
    if (seachQuery != null && seachQuery.isNotEmpty) {
      query.where(
        (n) => n.title.contains(seachQuery) | n.content.contains(seachQuery),
      );
    }
    query
      ..orderBy([
        (n) => OrderingTerm(
              expression: n.creationDate,
              mode: dateOrderingMode,
            ),
      ])
      ..limit(limit, offset: offset);

    return await query.get();
  }

  Future<NotesTableData?> getNote({
    required int id,
  }) async {
    return await (select(notesTable)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  Future<NotesTableData> insertNote(NotesTableCompanion note) async {
    return await into(notesTable).insertReturning(note);
  }

  Future<void> updateNote(NotesTableCompanion note) async {
    await into(notesTable).insertOnConflictUpdate(note);
  }

  Future<void> deleteNote({
    required int id,
  }) async {
    await (delete(notesTable)..where((e) => e.id.equals(id))).go();
  }
}
