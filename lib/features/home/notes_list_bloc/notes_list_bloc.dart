import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:notes/core/models/note.dart';
import 'package:notes/core/notes_changes_notifier/models/notes_changed.dart';
import 'package:notes/core/notes_changes_notifier/notes_changes_notifier.dart';
import 'package:notes/core/notes_repository/notes_repository.dart';
import 'package:notes/core/models/notes_sort_mode.dart';
import 'package:notes/utils/iterable_extensions.dart';
import 'package:notes/utils/paging_state_no_equal.dart';

part 'notes_list_event.dart';
part 'notes_list_state.dart';
part 'notes_list_bloc.freezed.dart';

class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  NotesListBloc({
    required NotesRepository notesRepository,
    required NotesChangesReporter notesChangesReporter,
    required NotesChangesListener notesChangesListener,
  })  : _notesRepository = notesRepository,
        _notesChangesReporter = notesChangesReporter,
        _notesChangesListener = notesChangesListener,
        super(NotesListState.idle(
          notesPagingState: PagingStateNoEqual(),
          notesSortMode: NotesSortMode.dateDesc,
          searchQuery: null,
        )) {
    on<NotesListEvent>(
      (event, emit) async => switch (event) {
        _LoadNotes() => _onLoadNotes(event, emit),
        _DeleteNote() => _onDeleteNote(event, emit),
        _SortModeChanged() => _onSortModeChanged(event, emit),
        _SearchQueryChanged() => _onSearchQueryChanged(event, emit),
        _NotesChanged() => _onNotesChanged(event, emit),
      },
    );

    _notesChangedSub = _notesChangesListener.notesChangesStream().listen((change) {
      add(NotesListEvent.notesChanged(change: change));
    });
  }

  final NotesRepository _notesRepository;
  final NotesChangesReporter _notesChangesReporter;
  final NotesChangesListener _notesChangesListener;

  late final StreamSubscription<NotesChangedEvent> _notesChangedSub;

  static const int _limit = 15;

  @override
  Future<void> close() async {
    await _notesChangedSub.cancel();
    return super.close();
  }

  Future<void> _onLoadNotes(_LoadNotes event, Emitter<NotesListState> emit) async {
    final pagingState = state.notesPagingState;

    emit(state.copyWith(
      notesPagingState: pagingState.copyWith(
        isLoading: true,
      ),
    ));

    final offset = (pagingState.pages?.length ?? 0) * _limit;

    final newNotes = await _notesRepository.getNotes(
      limit: _limit,
      offset: offset,
      notesSortMode: state.notesSortMode,
      searchQuery: state.searchQuery,
    );

    emit(state.copyWith(
      notesPagingState: pagingState.copyWith(
        pages: [...?pagingState.pages, newNotes],
        keys: [...?pagingState.keys, offset],
        hasNextPage: newNotes.length == _limit,
        isLoading: false,
      ),
    ));
  }

  Future<void> _onDeleteNote(_DeleteNote event, Emitter<NotesListState> emit) async {
    final noteId = event.noteId;

    for (final List<Note> page in state.notesPagingState.pages ?? []) {
      final noteIndex = page.firstIndexWhereOrNull((n) => n.id == noteId);

      if (noteIndex != null) {
        page.removeAt(noteIndex);
        emit(state.copyWith(
          notesPagingState: state.notesPagingState.copyWith(),
        ));
        break;
      }
    }

    emit(state.copyWith(
      notesPagingState: state.notesPagingState.copyWith(),
    ));

    await _notesRepository.deleteNote(noteId: noteId);
    _notesChangesReporter.report(NotesChangedEvent.deletedNote(noteId: noteId));
  }

  void _onSortModeChanged(_SortModeChanged event, Emitter<NotesListState> emit) {
    if (event.sortMode == state.notesSortMode) {
      return;
    }

    emit(state.copyWith(
      notesPagingState: state.notesPagingState.reset(),
      notesSortMode: event.sortMode,
    ));
  }

  void _onSearchQueryChanged(_SearchQueryChanged event, Emitter<NotesListState> emit) {
    if (event.searchQuery == state.searchQuery) {
      return;
    }

    emit(state.copyWith(
      notesPagingState: state.notesPagingState.reset(),
      searchQuery: event.searchQuery,
    ));
  }

  Future<void> _onNotesChanged(_NotesChanged event, Emitter<NotesListState> emit) async {
    switch (event.change) {
      case NotesChangedEvent_AddedNote():
        emit(state.copyWith(
          notesPagingState: state.notesPagingState.reset(),
        ));

      case NotesChangedEvent_UpdatedNote(:final noteId):
        for (final List<Note> page in state.notesPagingState.pages ?? []) {
          final noteIndex = page.firstIndexWhereOrNull((n) => n.id == noteId);

          if (noteIndex != null) {
            final updatedNote = await _notesRepository.getNote(noteId: noteId);

            if (updatedNote == null) {
              emit(state.failedToUpdateNote());
              emit(state.idle());
              return;
            }

            page[noteIndex] = updatedNote;
            emit(state.copyWith(
              notesPagingState: state.notesPagingState.copyWith(),
            ));
            return;
          }
        }

      case NotesChangedEvent_DeletedNote(:final noteId):
        for (final List<Note> page in state.notesPagingState.pages ?? []) {
          final deletedNoteIndex = page.firstIndexWhereOrNull((n) => n.id == noteId);

          if (deletedNoteIndex != null) {
            page.removeAt(deletedNoteIndex);
            emit(state.copyWith(
              notesPagingState: state.notesPagingState.copyWith(),
            ));
            return;
          }
        }
    }
  }
}
