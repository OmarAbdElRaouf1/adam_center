import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/home/data/models/banner_model.dart';

abstract class BannerDatasource {
  Future<Either<Failure, List<BannerModel>>> getBanner(String endpoint);
}

class BannerDatasourceImpl implements BannerDatasource {
  final GenericDataSource genericDataSource;
  BannerDatasourceImpl(this.genericDataSource);

  @override
  Future<Either<Failure, List<BannerModel>>> getBanner(String endpoint) {
    return genericDataSource.fetchData<BannerModel>(
      endpoint: endpoint,
      fromJson: BannerModel.fromJson,
    );
  }
}
