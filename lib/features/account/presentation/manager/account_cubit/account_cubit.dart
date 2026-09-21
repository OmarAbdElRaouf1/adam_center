import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_one_test/core/local/user_session_datasource.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';
import 'package:the_one_test/features/checkout/data/models/address_model.dart';

// Registered as a singleton (see AccountServiceLocator) and read via
// getIt<AccountCubit>() everywhere rather than through a per-screen
// BlocProvider, so any screen that updates the user (e.g. picking a
// different delivery address) is reflected immediately by every other
// screen already showing it — Home and Cart in particular.
class AccountCubit extends Cubit<UserModel?> {
  final UserSessionCache _userSessionCache;

  AccountCubit(UserSessionCache userSessionCache)
    : _userSessionCache = userSessionCache,
      super(userSessionCache.getUser());

  Future<void> updateUser(UserModel user) async {
    await _userSessionCache.saveUser(user);
    emit(user);
  }

  Future<void> logout() async {
    await _userSessionCache.clearUser();
    emit(null);
  }

  // Applies a saved/newly-added address to the current user profile. Shared
  // by ChooseAddressCubit and AddAddressCubit so the raw-address-fields →
  // UserModel mapping lives in one place instead of being duplicated in
  // each screen.
  Future<void> applyAddress(AddressModel address) async {
    final currentUser = state;
    if (currentUser == null) return;
    await updateUser(
      currentUser.copyWith(
        regionId: address.regionId,
        regionName: address.regionName,
        districtName: address.districtName,
        streetName: address.streetName,
        houseNo: address.houseNo,
        block: address.block,
        floor: address.floor,
        apartment: address.apartment,
        addressNotes: address.addressNotes,
        customerAddress: address.customerAddress,
        addressId: address.addressId,
      ),
    );
  }
}
