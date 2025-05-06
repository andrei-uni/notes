import 'package:flutter/material.dart';
import 'package:notes/theme/note_list_item_theme.dart';
import 'package:notes/theme/search_field_theme.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return _baseTheme(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 68, 134, 255),
        brightness: Brightness.light,
      ),
      noteListItemTheme: const NoteListItemTheme(
        backgroundColor: Color.fromARGB(255, 235, 238, 252),
      ),
      searchFieldTheme: const SearchFieldTheme(
        backgroundColor: Color.fromARGB(255, 207, 220, 243),
      ),
    );
  }

  static ThemeData get dark {
    return _baseTheme(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 22, 57, 122),
        brightness: Brightness.dark,
      ),
      noteListItemTheme: const NoteListItemTheme(
        backgroundColor: Color.fromARGB(255, 29, 40, 51),
      ),
      searchFieldTheme: const SearchFieldTheme(
        backgroundColor: Color.fromARGB(255, 20, 37, 68),
      ),
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme colorScheme,
    required NoteListItemTheme noteListItemTheme,
    required SearchFieldTheme searchFieldTheme,
  }) {
    return ThemeData(
      colorScheme: colorScheme,
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) {
          return const Icon(Icons.arrow_back_ios);
        },
      ),
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      extensions: [
        noteListItemTheme,
        searchFieldTheme,
      ],
    );
  }
}
