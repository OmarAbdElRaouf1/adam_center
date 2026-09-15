import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/account/presentation/manager/account_cubit/account_cubit.dart';
import 'package:the_one_test/features/checkout/data/datasource/add_address_datasource.dart';
import 'package:the_one_test/features/checkout/data/models/address_model.dart';
import 'package:the_one_test/features/checkout/data/models/address_text.dart';

part 'choose_address_event.dart';

class ChooseAddressBloc
    extends Bloc<ChooseAddressEvent, BaseState<AddressModel>> {
  final AddAddressDatasource _addAddressDatasource;
  final AccountCubit _accountCubit;

  ChooseAddressBloc(this._addAddressDatasource, this._accountCubit)
    : super(const BaseState<AddressModel>()) {
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
    final address = event.address.copyWith(
      districtName:
          districtFromCustomerAddress(event.address.customerAddress) ??
          event.address.districtName,
    );
    await _accountCubit.applyAddress(address);
    emit(
      state.copyWith(status: Status.success, metadata: {'action': 'select'}),
    );
  }
}
