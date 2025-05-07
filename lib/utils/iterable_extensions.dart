extension IterableExtensions<T> on Iterable<T> {
  int? firstIndexWhereOrNull(bool Function(T) predicate) {
    for (final (index, item) in indexed) {
      if (predicate(item)) {
        return index;
      }
    }
    return null;
  }
}
