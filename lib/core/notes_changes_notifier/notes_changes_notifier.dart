import 'package:notes/core/notes_changes_notifier/models/notes_changed.dart';

abstract interface class NotesChangesListener {
  Stream<NotesChangedEvent> notesChangesStream();
}

abstract interface class NotesChangesReporter {
  void report(NotesChangedEvent change);
}
