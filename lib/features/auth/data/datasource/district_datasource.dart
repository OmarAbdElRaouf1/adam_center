import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';

abstract interface class DistrictDatasource {
  Future<Either<Failure, List<DistrictModel>>> getDistrictsByGovernorateId(
    int governorateId,
  );
}

class DistrictDatasourceImpl implements DistrictDatasource {
  final GenericDataSource _genericDataSource;
  DistrictDatasourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<DistrictModel>>> getDistrictsByGovernorateId(
    int governorateId,
  ) {
    return _genericDataSource.fetchData<DistrictModel>(
      endpoint: EndPoints.getAreaByGovernorateId,
      queryParameters: {'GovernorateID': governorateId},
      fromJson: DistrictModel.fromJson,
    );
  }
}
