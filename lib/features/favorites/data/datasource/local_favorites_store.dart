import 'package:shared_preferences/shared_preferences.dart';

// The backend's dedicated "list my favorite products" actions
// (Customer/GetCustomerProducts and Customer/GetCustomerProductsByID) are
// both confirmed broken on the server — one ignores its filter parameter
// entirely and always returns an empty list, the other throws a raw
// FormatException for any input — and the IsFavorite flag embedded in
// general product-listing endpoints doesn't reflect adds either. Add/remove
// themselves do work, so this store tracks favorited product IDs locally as
// the actual source of truth for what's displayed, independent of those
// broken read paths.
class LocalFavoritesStore {
  static const _key = 'local_favorite_product_ids';

  final SharedPreferences _prefs;

  LocalFavoritesStore(this._prefs);

  Set<int> getIds() {
    final stored = _prefs.getStringList(_key) ?? const [];
    return stored.map(int.parse).toSet();
  }

  bool isFavorite(int productId) => getIds().contains(productId);

  Future<void> add(int productId) async {
    final ids = getIds()..add(productId);
    await _prefs.setStringList(_key, ids.map((id) => id.toString()).toList());
  }

  Future<void> remove(int productId) async {
    final ids = getIds()..remove(productId);
    await _prefs.setStringList(_key, ids.map((id) => id.toString()).toList());
  }
}
