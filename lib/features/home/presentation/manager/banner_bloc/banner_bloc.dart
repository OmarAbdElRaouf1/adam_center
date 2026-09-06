import 'package:equatable/equatable.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/data/datasource/banner_datasource.dart';
import 'package:the_one_test/features/home/data/models/banner_model.dart';

part 'banner_event.dart';

class BannerBloc extends Bloc<BannerEvent, BaseState<BannerModel>> {
  final BannerDatasource bannerDatasource;
  final String endpoint;

  BannerBloc(this.bannerDatasource, this.endpoint)
    : super(BaseState<BannerModel>()) {
    on<GetBannerEvent>(_onGetBanner);
  }

  Future<void> _onGetBanner(
    GetBannerEvent event,
    Emitter<BaseState<BannerModel>> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, errorMessage: null));

    final result = await bannerDatasource.getBanner(endpoint);

    result.fold(
      (failure) {
        emit(
          state.copyWith(status: Status.failure, errorMessage: failure.message),
        );
      },
      (banners) {
        emit(state.copyWith(status: Status.success, items: banners));
      },
    );
  }
}
