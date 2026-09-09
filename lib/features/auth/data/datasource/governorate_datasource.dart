import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';

abstract interface class GovernorateDatasource {
  Future<Either<Failure, List<GovernorateModel>>> getGovernorates();
}

class GovernorateDatasourceImpl implements GovernorateDatasource {
  final GenericDataSource _genericDataSource;
  GovernorateDatasourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<GovernorateModel>>> getGovernorates() {
    return _genericDataSource.fetchData<GovernorateModel>(
      endpoint: EndPoints.governorates,
      fromJson: GovernorateModel.fromJson,
    );
  }
}
