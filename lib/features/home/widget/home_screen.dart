import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:notes/core/models/note.dart';
import 'package:notes/core/models/notes_sort_mode.dart';
import 'package:notes/features/create_note/widget/create_note_screen.dart';
import 'package:notes/features/home/notes_list_bloc/notes_list_bloc.dart';
import 'package:notes/features/home/widget/note_list_item_widget.dart';
import 'package:notes/features/home/widget/search_field_widget.dart';
import 'package:notes/features/home/widget/sort_notes_button.dart';
import 'package:notes/features/initialization/widget/app_dependencies_scope.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final NotesListBloc notesListBloc;

  late final AnimationController searchAnimationController;
  late final Animation<double> searchScaleAnimation;

  final searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final appDependenciesContainer = AppDependenciesScope.of(context);
    notesListBloc = NotesListBloc(
      notesRepository: appDependenciesContainer.notesRepository,
      notesChangesListener: appDependenciesContainer.notesChangesListener,
      notesChangesReporter: appDependenciesContainer.notesChangesReporter,
    );

    searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    searchScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: searchAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    notesListBloc.close();
    searchAnimationController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void searchChanged(String value) {
    notesListBloc.add(NotesListEvent.searchQueryChanged(searchQuery: value.trim()));
  }

  void onSearchPressed() {
    searchAnimationController.forward();
    searchFocusNode.requestFocus();
  }

  void onSearchClosed() {
    searchAnimationController.reverse();
    searchFocusNode.unfocus();
    notesListBloc.add(const NotesListEvent.searchQueryChanged(searchQuery: null));
  }

  void onSortModeChanged(NotesSortMode newSortMode) {
    notesListBloc.add(NotesListEvent.sortModeChanged(sortMode: newSortMode));
  }

  void onNoteTap(int noteId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => CreateNoteScreen(noteId: noteId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: notesListBloc,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AppBar(
                title: const Text('Заметки'),
                actions: [
                  BlocSelector<NotesListBloc, NotesListState, NotesSortMode>(
                    selector: (state) => state.notesSortMode,
                    builder: (context, notesSortMode) {
                      return SortNotesButton(
                        currentSortMode: notesSortMode,
                        onNewSortMode: onSortModeChanged,
                      );
                    },
                  ),
                  IconButton(
                    onPressed: onSearchPressed,
                    icon: const Icon(Icons.search),
                    tooltip: 'Поиск',
                  ),
                ],
              ),
              Align(
                alignment: const AlignmentDirectional(1.0, 0.8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ValueListenableBuilder<double>(
                    valueListenable: searchScaleAnimation,
                    builder: (context, scale, child) {
                      final scaleY = switch (scale) {
                        > 0.6 => clampDouble(scale * 1.05, 0.0, 1.0),
                        _ => scale,
                      };
                      return Transform.scale(
                        scaleX: scale,
                        scaleY: scaleY,
                        alignment: const FractionalOffset(1, 0.5),
                        child: child,
                      );
                    },
                    child: BlocSelector<NotesListBloc, NotesListState, NotesSortMode>(
                      selector: (state) => state.notesSortMode,
                      builder: (context, notesSortMode) {
                        return SearchFieldWidget(
                          focusNode: searchFocusNode,
                          notesSortMode: notesSortMode,
                          onQueryChanged: searchChanged,
                          onSortModeChanged: onSortModeChanged,
                          onClose: onSearchClosed,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const CreateNoteScreen(noteId: null),
                allowSnapshotting: false,
              ),
            );
          },
          tooltip: 'Создать заметку',
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<NotesListBloc, NotesListState>(
          builder: (context, state) {
            return PagedListView<int, Note>.separated(
              state: state.notesPagingState,
              fetchNextPage: () => notesListBloc.add(const NotesListEvent.loadNotes()),
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: MediaQuery.paddingOf(context).bottom + 15,
              ),
              shrinkWrap: true, // prevents first page indicators from scrolling, has no effect on the list
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, note, index) {
                  return Dismissible(
                    key: ValueKey(note.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => notesListBloc.add(NotesListEvent.deleteNote(noteId: note.id)),
                    background: ColoredBox(
                      color: theme.colorScheme.errorContainer,
                      child: const Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.delete_outline),
                        ),
                      ),
                    ),
                    child: NoteListItemWidget(
                      noteTitle: note.title,
                      noteContent: note.content,
                      creationDate: note.creationDate,
                      onTap: () => onNoteTap(note.id),
                    ),
                  );
                },
                noItemsFoundIndicatorBuilder: (context) {
                  return const Center(
                    child: Text('Нет заметок'),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
