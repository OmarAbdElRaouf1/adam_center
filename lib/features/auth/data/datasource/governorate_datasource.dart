import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/helper/helper.dart';
import 'package:the_one_test/features/auth/data/models/governorate_model.dart';

abstract class GovernorateDatasource {
  Future<Either<Failure, List<GovernorateModel>>> getGovernorates();
}

class GovernorateDatasourceImpl implements GovernorateDatasource {
  final GenericDataSource genericDataSource;
  GovernorateDatasourceImpl(this.genericDataSource);

  @override
  Future<Either<Failure, List<GovernorateModel>>> getGovernorates() {
    return genericDataSource.fetchData<GovernorateModel>(
      endpoint: EndPoints.governorates,
      fromJson: GovernorateModel.fromJson,
    );
  }
}
