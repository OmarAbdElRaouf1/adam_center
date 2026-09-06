import 'package:hive_flutter/hive_flutter.dart';

import '../helper/logger.dart';
part 'user_cache_interface.dart';
part 'paginated_cache_interface.dart';

class HiveServiceImpl implements IUserCache {
  static const String userBoxName = 'user_box';

  static const String currentUserKey = 'current_user';
  static const String orderBoxName = 'order_box';
  static Box<String>? _orderBox;
  static const String selectedAreaBoxName = 'selected_area_box';

  static const String settingsBoxName = 'settings_box';
  static Box<String>? _settingsBox;
  static const String themeModeKey = 'theme_mode';
  HiveServiceImpl._();

  static final HiveServiceImpl instance = HiveServiceImpl._();

  static Future<void> init() async {
    await Hive.initFlutter();
    // Hive.registerAdapter(CustomerModelAdapter());

    //_userBox = await Hive.openBox<CustomerModel>(userBoxName);
    _orderBox = await Hive.openBox<String>(orderBoxName);

    _settingsBox = await Hive.openBox<String>(settingsBoxName);
  }

  // @override
  // Future<void> cacheUserModel(CustomerModel user) async {
  //   await _userBox?.put(currentUserKey, user);
  // }

  // @override
  // CustomerModel? getUserModel() {
  //   final user = _userBox?.get(currentUserKey);
  //   if (user != null) {
  //   }
  //   return user;
  // }

  // @override
  // Future<void> clearUserModel() async {
  //   await _userBox?.delete(currentUserKey);
  // }

  // @override
  // Future updateCachedUserModel(CustomerModel user) async {
  //   await _userBox?.put(currentUserKey, user);
  //   logger('Updated user in cache: ${user.toJson()}');
  // }

  Future<void> _cachePage<T>(List<T> items, {String? cacheKey}) async {
    final box = await Hive.openBox<T>(cacheKey!);
    await box.putAll(items.asMap());
  }

  Future<List<T>> _getCachedPage<T>({String? cacheKey}) {
    throw UnimplementedError();
  }

  @override
  Future<void> cacheOrderId(String orderId) async {
    await _orderBox?.put('current_order_id', orderId);
  }

  @override
  Future<void> upDateOrderId(String orderId) async {
    await _orderBox?.put('current_order_id', orderId);
  }

  @override
  String? getOrderId() {
    return _orderBox?.get('current_order_id');
  }

  // New methods for delivery addition
  static const String deliveryAdditionKey = 'delivery_addition';
  static const String selectedBranchIdKey = 'selected_branch_id';

  // Future<void> cacheDeliveryAddition(AreasModel area) async {
  //   await _selectedAreaBox?.put(deliveryAdditionKey, area);
  //   logger('Cached delivery addition area: ${area.districtName}');
  // }

  // AreasModel? getDeliveryAddition() {
  //   return _selectedAreaBox?.get(deliveryAdditionKey);
  // }

  // Future<void> clearDeliveryAddition() async {
  //   await _selectedAreaBox?.delete(deliveryAdditionKey);
  // }

  Future<void> cacheBranchId(int branchId) async {
    await _settingsBox?.put(selectedBranchIdKey, branchId.toString());
    logger('Cached branch ID: $branchId');
  }

  String? getBranchId() {
    return _settingsBox?.get(selectedBranchIdKey);
  }

  @override
  Future<void> saveThemeMode(String mode) async {
    await _settingsBox?.put(themeModeKey, mode);
  }

  @override
  String? getThemeMode() {
    return _settingsBox?.get(themeModeKey);
  }

  @override
  Future<void> cacheUserModel(userModel) {
    // TODO: implement cacheUserModel
    throw UnimplementedError();
  }

  @override
  Future<void> clearUserModel() {
    // TODO: implement clearUserModel
    throw UnimplementedError();
  }

  @override
  void getUserModel() {
    // TODO: implement getUserModel
    throw UnimplementedError();
  }

  @override
  Future<void> updateCachedUserModel(userModel) {
    // TODO: implement updateCachedUserModel
    throw UnimplementedError();
  }
}
