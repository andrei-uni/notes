import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'note_list_item_theme.tailor.dart';

@TailorMixin()
class NoteListItemTheme extends ThemeExtension<NoteListItemTheme> with _$NoteListItemThemeTailorMixin {
  const NoteListItemTheme({
    required this.backgroundColor,
  });

  @override
  final Color backgroundColor;
}
