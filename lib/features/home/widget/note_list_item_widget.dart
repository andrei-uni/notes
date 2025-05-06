import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/theme/note_list_item_theme.dart';

class NoteListItemWidget extends StatelessWidget {
  const NoteListItemWidget({
    required this.noteTitle,
    required this.noteContent,
    required this.creationDate,
    required this.onTap,
    super.key,
  });

  final String noteTitle;
  final String noteContent;
  final DateTime creationDate;
  final VoidCallback onTap;

  static const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(15));

  String createDate(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    final time = DateFormat('jm', languageCode).format(creationDate);
    if (creationDate.isToday) {
      return 'Сегодня в $time';
    } else if (creationDate.isYesterday) {
      return 'Вчера в $time';
    }

    if (creationDate.isThisYear) {
      // "June 6"
      return DateFormat('MMMMd', languageCode).format(creationDate);
    }

    // "June 6, 2024"
    return DateFormat('yMMMMd', languageCode).format(creationDate);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final noteListItemTheme = theme.noteListItemTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: noteListItemTheme.backgroundColor,
        borderRadius: _borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: _borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noteTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
                if (noteContent.isNotEmpty)
                  Text(
                    noteContent,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    createDate(context),
                    style: textTheme.labelMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
