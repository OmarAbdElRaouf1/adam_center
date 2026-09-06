part of "hive_service_impl.dart";

abstract interface class IUserCache {
  //Future<void> cacheUserModel(CustomerModel userModel);
  /// CustomerModel? getUserModel();
  Future<void> clearUserModel();
  // Future<void> updateCachedUserModel(CustomerModel userModel);
  Future<void> cacheOrderId(String orderId);
  Future<void> upDateOrderId(String orderId);
  String? getOrderId();
  Future<void> saveThemeMode(String mode);
  String? getThemeMode();
}
