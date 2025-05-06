import 'package:flutter/material.dart';
import 'package:notes/core/models/notes_sort_mode.dart';
import 'package:notes/features/home/widget/sort_notes_button.dart';
import 'package:notes/theme/search_field_theme.dart';

class SearchFieldWidget extends StatefulWidget {
  const SearchFieldWidget({
    required this.focusNode,
    required this.notesSortMode,
    required this.onQueryChanged,
    required this.onSortModeChanged,
    required this.onClose,
    super.key,
  });

  final FocusNode focusNode;
  final NotesSortMode notesSortMode;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<NotesSortMode> onSortModeChanged;
  final VoidCallback onClose;

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  final controller = TextEditingController();
  String previousValue = '';

  @override
  void initState() {
    super.initState();
    controller.addListener(searchChanged);
  }

  @override
  void dispose() {
    controller
      ..removeListener(searchChanged)
      ..dispose();
    super.dispose();
  }

  void searchChanged() {
    final currentValue = controller.text;
    if (currentValue == previousValue) {
      return;
    }
    previousValue = currentValue;
    widget.onQueryChanged(currentValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchFieldTheme = theme.searchFieldTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: searchFieldTheme.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: TextField(
        controller: controller,
        focusNode: widget.focusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Поиск',
          contentPadding: const EdgeInsetsDirectional.only(start: 20),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SortNotesButton(
                currentSortMode: widget.notesSortMode,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                onNewSortMode: widget.onSortModeChanged,
              ),
              IconButton(
                onPressed: widget.onClose,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
