import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/data/models/banner_model.dart';

abstract interface class BannerDatasource {
  Future<Either<Failure, List<BannerModel>>> getBanner(String endpoint);
}

class BannerDatasourceImpl implements BannerDatasource {
  final GenericDataSource _genericDataSource;
  BannerDatasourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<BannerModel>>> getBanner(String endpoint) {
    return _genericDataSource.fetchData<BannerModel>(
      endpoint: endpoint,
      fromJson: BannerModel.fromJson,
    );
  }
}
