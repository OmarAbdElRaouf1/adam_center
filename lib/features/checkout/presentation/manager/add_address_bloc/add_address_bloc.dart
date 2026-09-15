import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/checkout/data/datasource/add_address_datasource.dart';
import 'package:the_one_test/features/checkout/data/models/address_model.dart';

part 'add_address_event.dart';

class AddAddressBloc extends Bloc<AddAddressEvent, BaseState<void>> {
  final AddAddressDatasource _addAddressDatasource;
  final AccountCubit _accountCubit;

  AddAddressBloc(this._addAddressDatasource, this._accountCubit)
    : super(const BaseState<void>()) {
    on<SaveAddress>(_onSaveAddress);
  }

  Future<void> _onSaveAddress(
    SaveAddress event,
    Emitter<BaseState<void>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await _addAddressDatasource.addAddress(
      governorateId: event.governorateId,
      areaId: event.areaId,
      districtName: event.districtName,
      street: event.street,
      houseNumber: event.houseNumber,
      block: event.block,
      floor: event.floor,
      apartment: event.apartment,
      notes: event.notes,
      fullAddress: event.fullAddress,
      isMainAddress: true,
    );

    final failure = result.fold((failure) => failure, (_) => null);
    if (failure != null) {
      emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      );
      return;
    }

    // Re-fetch the address from the server rather than trusting what was
    // just sent, so the cached value matches what the backend actually
    // stored (e.g. any normalization it applies) instead of a client-side
    // reconstruction. However region_id/RegionName/DistrictName come back
    // static per customer profile rather than per address (see
    // districtFromCustomerAddress's doc comment), so getMainAddress() can't
    // be trusted for governorate/district — those are overridden below with
    // what the user actually just picked in this form, which is known with
    // certainty client-side.
    final addressResult = await _addAddressDatasource.getMainAddress();
    final fetchedAddress = addressResult.fold((_) => null, (address) => address);
    final address = (fetchedAddress ?? const AddressModel()).copyWith(
      regionName: event.governorateName,
      districtName: event.districtName,
    );
    await _accountCubit.applyAddress(address);

    emit(state.copyWith(status: Status.success));
  }
}
