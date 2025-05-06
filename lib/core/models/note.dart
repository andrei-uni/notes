class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
  });

  final int id;
  final String title;
  final String content;
  final DateTime creationDate;
}
