import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'search_field_theme.tailor.dart';

@TailorMixin()
class SearchFieldTheme extends ThemeExtension<SearchFieldTheme> with _$SearchFieldThemeTailorMixin {
  const SearchFieldTheme({
    required this.backgroundColor,
  });

  @override
  final Color backgroundColor;
}
