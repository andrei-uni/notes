import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/core/models/note.dart';
import 'package:notes/features/edit_note/bloc/edit_note_bloc.dart';
import 'package:notes/features/initialization/widget/app_dependencies_scope.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({
    required this.noteId,
    super.key,
  });

  final int? noteId;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late final EditNoteBloc editNoteBloc;
  late final StreamSubscription<EditNoteState> blocSub;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final titleFocusNode = FocusNode();

  bool get isCreatingNote => widget.noteId == null;

  @override
  void initState() {
    super.initState();
    final appDependenciesContainer = AppDependenciesScope.of(context);
    editNoteBloc = EditNoteBloc(
      notesRepository: appDependenciesContainer.notesRepository,
      notesChangesReporter: appDependenciesContainer.notesChangesReporter,
    );
    if (widget.noteId != null) {
      editNoteBloc.add(EditNoteEvent.loadNote(noteId: widget.noteId!));
    }
    blocSub = editNoteBloc.stream.listen(blocListener);

    if (isCreatingNote) {
      titleFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    titleFocusNode.dispose();
    blocSub.cancel();
    editNoteBloc.close();
    super.dispose();
  }

  void blocListener(EditNoteState state) {
    switch (state) {
      case EditNoteState_LoadedNote(:final Note loadedNote):
        titleController.text = loadedNote.title;
        contentController.text = loadedNote.content;

      case EditNoteState_LoadedNoteFailure():
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (alertContext) {
            return AlertDialog(
              title: const Text('Ошибка загрузки заметки'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(alertContext);
                    Navigator.pop(context);
                  },
                  child: const Text('ОК'),
                ),
              ],
            );
          },
        );

      case EditNoteState_Success():
        Navigator.pop(context);

      default:
        break;
    }
  }

  void savePressed() {
    if (titleController.text.trim().isEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (alertContext) {
          return AlertDialog(
            title: const Text('Заголовок не может быть пустым'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(alertContext);
                },
                child: const Text('ОК'),
              ),
            ],
          );
        },
      );
      return;
    }

    editNoteBloc.add(EditNoteEvent.saveNote(
      title: titleController.text.trim(),
      content: contentController.text.trim(),
    ));
  }

  void deletePressed() async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (alertContext) {
        return AlertDialog(
          title: const Text('Удалить заметку?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(alertContext, false);
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(alertContext, true);
              },
              child: Text(
                'Да',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      editNoteBloc.add(const EditNoteEvent.deleteNote());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isCreatingNote ? 'Новая заметка' : 'Изменить заметку'),
        actions: [
          IconButton(
            onPressed: savePressed,
            icon: const Icon(Icons.check),
            tooltip: 'Сохранить',
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: isCreatingNote
          ? null
          : FloatingActionButton.small(
              onPressed: deletePressed,
              heroTag: null,
              tooltip: 'Удалить',
              child: const Icon(Icons.delete_outline),
            ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 10,
          left: 15,
          right: 15,
          bottom: MediaQuery.paddingOf(context).bottom + 15,
        ),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              focusNode: titleFocusNode,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Заголовок',
                hintFadeDuration: Duration.zero,
                border: InputBorder.none,
              ),
              style: textTheme.titleLarge,
            ),
            TextField(
              controller: contentController,
              minLines: 15,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Текст',
                hintFadeDuration: Duration.zero,
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
