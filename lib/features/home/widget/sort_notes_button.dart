import 'package:flutter/material.dart';
import 'package:notes/core/models/notes_sort_mode.dart';

class SortNotesButton extends StatelessWidget {
  const SortNotesButton({
    required this.currentSortMode,
    this.visualDensity,
    this.padding,
    required this.onNewSortMode,
    super.key,
  });

  final NotesSortMode currentSortMode;
  final VisualDensity? visualDensity;
  final EdgeInsets? padding;
  final ValueChanged<NotesSortMode> onNewSortMode;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onNewSortMode(currentSortMode.getNext()),
      tooltip: 'Сортировать',
      visualDensity: visualDensity,
      padding: padding,
      icon: Transform.flip(
        flipY: switch (currentSortMode) {
          NotesSortMode.dateDesc => false,
          NotesSortMode.dateAsc => true,
        },
        child: const Icon(Icons.sort),
      ),
    );
  }
}
