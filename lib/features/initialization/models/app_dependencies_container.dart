import 'package:notes/core/notes_changes_notifier/notes_changes_notifier.dart';
import 'package:notes/core/notes_repository/notes_repository.dart';

class AppDependenciesContainer {
  AppDependenciesContainer({
    required this.notesRepository,
    required this.notesChangesListener,
    required this.notesChangesReporter,
  });

  final NotesRepository notesRepository;
  final NotesChangesReporter notesChangesReporter;
  final NotesChangesListener notesChangesListener;
}
