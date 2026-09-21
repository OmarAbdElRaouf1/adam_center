import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/auth/data/datasource/district_datasource.dart';
import 'package:the_one_test/features/auth/data/datasource/governorate_datasource.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';
import 'package:the_one_test/features/checkout/data/datasource/add_address_datasource.dart';
import 'package:the_one_test/features/checkout/data/datasource/local_address_region_store.dart';
import 'package:the_one_test/features/checkout/data/models/address_model.dart';
import 'package:the_one_test/features/checkout/data/models/address_text.dart';

part 'choose_address_event.dart';

class ChooseAddressBloc
    extends Bloc<ChooseAddressEvent, BaseState<AddressModel>> {
  final AddAddressDatasource _addAddressDatasource;
  final AccountCubit _accountCubit;
  final LocalAddressRegionStore _localAddressRegionStore;
  final GovernorateDatasource _governorateDatasource;
  final DistrictDatasource _districtDatasource;

  ChooseAddressBloc(
    this._addAddressDatasource,
    this._accountCubit,
    this._localAddressRegionStore,
    this._governorateDatasource,
    this._districtDatasource,
  ) : super(const BaseState<AddressModel>()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<SelectAddress>(_onSelectAddress);
  }

  Future<void> _onLoadAddresses(
    LoadAddresses event,
    Emitter<BaseState<AddressModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _addAddressDatasource.getAddresses();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
      (addresses) =>
          emit(state.copyWith(status: Status.success, items: addresses)),
    );
  }

  // Governorates aren't in the district-scoped Areas/GetAreaByGovernorateId
  // call, so a district name has to be matched against every governorate's
  // district list to find which one it belongs to — fetched in parallel
  // since there's no dedicated "governorate for this district" endpoint.
  // Only runs once per district: the result is cached in
  // LocalAddressRegionStore, and future adds populate it directly (see
  // AddAddressBloc) without ever needing this lookup.
  Future<String?> _resolveGovernorateName(String districtName) async {
    final governoratesResult = await _governorateDatasource.getGovernorates();
    final governorates = governoratesResult.fold(
      (_) => const <GovernorateModel>[],
      (items) => items,
    );

    final districtLists = await Future.wait(
      governorates.map(
        (g) => _districtDatasource.getDistrictsByGovernorateId(g.id),
      ),
    );

    for (var i = 0; i < governorates.length; i++) {
      final districts = districtLists[i].fold(
        (_) => const <DistrictModel>[],
        (items) => items,
      );
      final matches = districts.any(
        (d) => d.name.trim() == districtName.trim(),
      );
      if (matches) return governorates[i].name;
    }
    return null;
  }

  // Tags the resulting state with metadata: {'action': 'select'} rather than
  // a plain success, so the view's BlocListener can tell "an address was
  // selected, navigate back" apart from "the address list finished loading"
  // — both would otherwise be an indistinguishable Status.success.
  Future<void> _onSelectAddress(
    SelectAddress event,
    Emitter<BaseState<AddressModel>> emit,
  ) async {
    // DistrictName on the raw address comes back static per customer
    // profile rather than per address (see districtFromCustomerAddress's
    // doc comment) — CustomerAddress is the only field that actually
    // reflects the picked address, so the real district is pulled from
    // there instead of trusted as-is.
    final district =
        districtFromCustomerAddress(event.address.customerAddress) ??
        event.address.districtName;

    // RegionName is just as unreliable, and (unlike district) isn't
    // recoverable from CustomerAddress at all — the local cache (filled in
    // when the address was added, keyed by addressId) is the real source of
    // truth. Addresses saved before that cache existed fall back to a
    // one-time live lookup (only possible when there's a district to match
    // against — some governorates have none), which then fills the cache
    // in for next time.
    final addressId = event.address.addressId;
    String? regionName = addressId == null
        ? null
        : _localAddressRegionStore.getGovernorateName(addressId);
    if (regionName == null && district != null) {
      regionName = await _resolveGovernorateName(district);
      if (regionName != null && addressId != null) {
        await _localAddressRegionStore.setGovernorateName(
          addressId,
          regionName,
        );
      }
    }

    final address = event.address.copyWith(
      regionName: regionName ?? event.address.regionName,
      districtName: district,
    );
    await _accountCubit.applyAddress(address);
    emit(
      state.copyWith(status: Status.success, metadata: {'action': 'select'}),
    );
  }
}
