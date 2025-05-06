import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/core/models/note.dart';
import 'package:notes/features/create_note/bloc/create_note_bloc.dart';
import 'package:notes/features/initialization/widget/app_dependencies_scope.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({
    required this.noteId,
    super.key,
  });

  final int? noteId;

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  late final CreateNoteBloc createNoteBloc;
  late final StreamSubscription<CreateNoteState> blocSub;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final titleFocusNode = FocusNode();

  bool get isCreatingNote => widget.noteId == null;

  @override
  void initState() {
    super.initState();
    final appDependenciesContainer = AppDependenciesScope.of(context);
    createNoteBloc = CreateNoteBloc(
      notesRepository: appDependenciesContainer.notesRepository,
      notesChangesReporter: appDependenciesContainer.notesChangesReporter,
    );
    if (widget.noteId != null) {
      createNoteBloc.add(CreateNoteEvent.loadNote(noteId: widget.noteId!));
    }
    blocSub = createNoteBloc.stream.listen(blocListener);

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
    createNoteBloc.close();
    super.dispose();
  }

  void blocListener(CreateNoteState state) {
    switch (state) {
      case CreateNoteState_LoadedNote(:final Note loadedNote):
        titleController.text = loadedNote.title;
        contentController.text = loadedNote.content;

      case CreateNoteState_Success():
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

    createNoteBloc.add(CreateNoteEvent.saveNote(
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
      createNoteBloc.add(const CreateNoteEvent.deleteNote());
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
