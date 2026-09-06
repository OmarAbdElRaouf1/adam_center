import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/datasource/governorate_datasource.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';

part 'governorate_event.dart';

class GovernorateBloc
    extends Bloc<GovernorateEvent, BaseState<GovernorateModel>> {
  final GovernorateDatasource governorateDatasource;

  GovernorateBloc(this.governorateDatasource)
    : super(BaseState<GovernorateModel>()) {
    on<GetGovernoratesEvent>(_onGetGovernorates);
  }

  Future<void> _onGetGovernorates(
    GetGovernoratesEvent event,
    Emitter<BaseState<GovernorateModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));

    final result = await governorateDatasource.getGovernorates();

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: Status.failure, errorMessage: failure.message),
        );
      },
      (governorates) {
        emit(state.copyWith(status: Status.success, items: governorates));
      },
    );
  }
}
