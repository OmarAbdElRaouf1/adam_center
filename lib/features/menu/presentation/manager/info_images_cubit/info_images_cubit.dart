import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/menu/data/models/info_image_model.dart';

typedef InfoImagesFetcher =
    Future<Either<Failure, List<InfoImageModel>>> Function();

class InfoImagesCubit extends Cubit<BaseState<InfoImageModel>> {
  final InfoImagesFetcher _fetcher;

  InfoImagesCubit(this._fetcher) : super(const BaseState<InfoImageModel>());

  Future<void> fetch() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _fetcher();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(state.copyWith(status: Status.success, items: items)),
    );
  }
}
