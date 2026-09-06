part of 'district_bloc.dart';

class DistrictEvent extends Equatable {
  const DistrictEvent();

  @override
  List<Object> get props => [];
}

class GetDistrictsByGovernorateEvent extends DistrictEvent {
  const GetDistrictsByGovernorateEvent(this.governorateId);

  final int governorateId;

  @override
  List<Object> get props => [governorateId];
}
