import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/models/district_model.dart';

abstract class DistrictDatasource {
  Future<Either<Failure, List<DistrictModel>>> getDistrictsByGovernorateId(
    int governorateId,
  );
}

class DistrictDatasourceImpl implements DistrictDatasource {
  final GenericDataSource genericDataSource;
  DistrictDatasourceImpl(this.genericDataSource);

  @override
  Future<Either<Failure, List<DistrictModel>>> getDistrictsByGovernorateId(
    int governorateId,
  ) {
    return genericDataSource.fetchData<DistrictModel>(
      endpoint: EndPoints.getAreaByGovernorateId,
      queryParameters: {'GovernorateID': governorateId},
      fromJson: DistrictModel.fromJson,
    );
  }
}
