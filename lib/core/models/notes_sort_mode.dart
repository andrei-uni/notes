enum NotesSortMode {
  dateDesc,
  dateAsc;

  NotesSortMode getNext() {
    final currentIndex = values.indexOf(this);
    return values[(currentIndex + 1) % values.length];
  }
}
