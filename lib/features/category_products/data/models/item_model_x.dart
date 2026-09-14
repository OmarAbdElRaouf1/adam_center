import 'package:the_one_test/core/models/item_model.dart';

/// Shared shape used by every product card/list across the app (Home,
/// Category, Favorites, Product Details) — was previously duplicated inline
/// in four different view files.
extension ItemModelProductMapX on ItemModel {
  Map<String, String> toProductMap() {
    return {
      'id': productId.toString(),
      'barCode': barCode,
      'isFavorite': isFavorite.toString(),
      'image': productImage ?? '',
      'name': productArName,
      'description': description1 ?? '',
      'price': price.toString(),
      'categoryId': categoryId ?? '',
      'code': productCode,
      'quantity': stockQuantity.toString(),
    };
  }
}
