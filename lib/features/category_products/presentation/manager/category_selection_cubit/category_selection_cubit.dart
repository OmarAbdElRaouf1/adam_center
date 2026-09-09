import 'package:the_one_test/core/helper/helper.dart';

/// Shared between Home and the Categories tab. The Categories tab is a
/// persistent page inside RootView's IndexedStack — it's built once and
/// never rebuilt on tab switches, so passing data through its constructor
/// when Home navigates to it isn't possible. Home stashes the tapped
/// category's id here right before switching tabs; the Categories tab reads
/// it once its own category list has loaded, to select that category
/// instead of always defaulting to the first one.
class CategorySelectionCubit extends Cubit<int?> {
  CategorySelectionCubit() : super(null);

  void select(int? categoryId) => emit(categoryId);

  void clear() => emit(null);
}
