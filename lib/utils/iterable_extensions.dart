extension IterableExtensions<T> on Iterable<T> {
  int? firstIndexWhereOrNull(bool Function(T) predicate) {
    for (final (index, item) in indexed) {
      if (predicate(item)) {
        return index;
      }
    }
    return null;
  }

  bool containsWhere(bool Function(T) predicate) {
    for (final item in this) {
      if (predicate(item)) {
        return true;
      }
    }
    return false;
  }
}

extension ListExtensions<T> on List<T> {
  bool removeFirstWhere(bool Function(T) predicate) {
    for (final (index, item) in indexed) {
      if (predicate(item)) {
        removeAt(index);
        return true;
      }
    }
    return false;
  }
}
