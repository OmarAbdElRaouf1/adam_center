import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/datasource/district_datasource.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';

part 'district_event.dart';

class DistrictBloc extends Bloc<DistrictEvent, BaseState<DistrictModel>> {
  final DistrictDatasource districtDatasource;

  DistrictBloc(this.districtDatasource) : super(BaseState<DistrictModel>()) {
    on<GetDistrictsByGovernorateEvent>(_onGetDistricts);
  }

  Future<void> _onGetDistricts(
    GetDistrictsByGovernorateEvent event,
    Emitter<BaseState<DistrictModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));

    final result = await districtDatasource.getDistrictsByGovernorateId(
      event.governorateId,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: Status.failure, errorMessage: failure.message),
        );
      },
      (districts) {
        emit(state.copyWith(status: Status.success, items: districts));
      },
    );
  }
}
