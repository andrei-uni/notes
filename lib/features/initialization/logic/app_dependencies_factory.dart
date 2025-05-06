import 'package:notes/core/database/app_database.dart';
import 'package:notes/core/notes_changes_notifier/notes_changes_notifier_impl.dart';
import 'package:notes/core/notes_repository/notes_repository.dart';
import 'package:notes/core/notes_repository/notes_repository_impl.dart';
import 'package:notes/features/initialization/models/app_dependencies_container.dart';

class AppDependenciesFactory {
  Future<AppDependenciesContainer> create() async {
    final appDatabase = AppDatabase();

    final notesRepository = _createNotesRepository(appDatabase);

    final notesChangesNotifier = NotesChangesNotifierImpl();

    return AppDependenciesContainer(
      notesRepository: notesRepository,
      notesChangesListener: notesChangesNotifier,
      notesChangesReporter: notesChangesNotifier,
    );
  }

  NotesRepository _createNotesRepository(AppDatabase appDatabase) {
    return NotesRepositoryImpl(
      appDatabase: appDatabase,
    );
  }
}
