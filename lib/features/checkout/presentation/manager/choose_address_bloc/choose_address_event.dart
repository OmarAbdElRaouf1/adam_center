part of 'choose_address_bloc.dart';

abstract class ChooseAddressEvent extends Equatable {
  const ChooseAddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddresses extends ChooseAddressEvent {
  const LoadAddresses();
}

class SelectAddress extends ChooseAddressEvent {
  final AddressModel address;

  const SelectAddress(this.address);

  @override
  List<Object?> get props => [address];
}
