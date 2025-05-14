import 'package:collection/collection.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:notes/utils/iterable_extensions.dart';

base class CustomPagingState<PageKeyType, ItemType> extends PagingStateBase<PageKeyType, ItemType> {
  CustomPagingState({
    super.pages,
    super.keys,
    super.error,
    super.hasNextPage = true,
    super.isLoading = false,
  });

  List<ItemType>? firstPageWhereOrNull(bool Function(List<ItemType> item) predicate) {
    return pages?.firstWhereOrNull(predicate);
  }

  (ItemType item, List<ItemType> page, int itemIndex)? whereOrNull(bool Function(ItemType item) predicate) {
    for (final page in pages ?? <List<ItemType>>[]) {
      for (final (index, item) in page.indexed) {
        if (predicate(item)) {
          return (item, page, index);
        }
      }
    }
    return null;
  }

  bool removeFirstItemWhere(bool Function(ItemType item) predicate) {
    for (final page in pages ?? <List<ItemType>>[]) {
      final didRemove = page.removeFirstWhere(predicate);
      if (didRemove) {
        return true;
      }
    }
    return false;
  }

  int get length {
    return (pages ?? List.empty()).fold(0, (prev, page) => prev + page.length);
  }

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => identityHashCode(this);

  @override
  CustomPagingState<PageKeyType, ItemType> reset() => CustomPagingState(
        pages: null,
        keys: null,
        error: null,
        hasNextPage: true,
        isLoading: false,
      );

  @override
  CustomPagingState<PageKeyType, ItemType> copyWith({
    Defaulted<List<List<ItemType>>?>? pages = const Omit(),
    Defaulted<List<PageKeyType>?>? keys = const Omit(),
    Defaulted<Object?>? error = const Omit(),
    Defaulted<bool>? hasNextPage = const Omit(),
    Defaulted<bool>? isLoading = const Omit(),
  }) =>
      CustomPagingState(
        pages: pages is Omit ? this.pages : pages as List<List<ItemType>>?,
        keys: keys is Omit ? this.keys : keys as List<PageKeyType>?,
        error: error is Omit ? this.error : error as Object?,
        hasNextPage: hasNextPage is Omit ? this.hasNextPage : hasNextPage as bool,
        isLoading: isLoading is Omit ? this.isLoading : isLoading as bool,
      );
}
