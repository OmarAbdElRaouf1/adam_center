import 'package:shared_preferences/shared_preferences.dart';

// Mirrors LocalFavoritesStore's rationale: the backend's per-address
// region_id/RegionName come back static per customer profile rather than
// per address (see choose_address_bloc's doc comment), and the
// CustomerAddress string it regenerates doesn't carry the governorate
// either — only district/block/street (see districtFromCustomerAddress).
// The governorate is only knowable with certainty client-side at the moment
// an address is added (the user picks it from a governorate -> district
// cascade), so this caches that value locally, keyed by the backend's
// addressId — not by district name, since some governorates have no
// district at all (that key would collide across every such address). It's
// also filled in lazily by resolving against the Governorates/Areas API
// when an existing address (saved before this cache existed) is selected —
// see ChooseAddressBloc.
class LocalAddressRegionStore {
  static const _prefix = 'local_address_region_';

  final SharedPreferences _prefs;

  LocalAddressRegionStore(this._prefs);

  String? getGovernorateName(String addressId) {
    return _prefs.getString('$_prefix$addressId');
  }

  Future<void> setGovernorateName(
    String addressId,
    String governorateName,
  ) async {
    await _prefs.setString('$_prefix$addressId', governorateName);
  }
}
