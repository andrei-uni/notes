import 'dart:async';

import 'package:notes/core/notes_changes_notifier/models/notes_changed.dart';
import 'package:notes/core/notes_changes_notifier/notes_changes_notifier.dart';

class NotesChangesNotifierImpl implements NotesChangesListener, NotesChangesReporter {
  final _streamController = StreamController<NotesChangedEvent>.broadcast();

  @override
  Stream<NotesChangedEvent> notesChangesStream() async* {
    yield* _streamController.stream;
  }

  @override
  void report(NotesChangedEvent change) {
    _streamController.add(change);
  }
}
