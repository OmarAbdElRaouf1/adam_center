import 'package:the_one_test/core/constant/end_points.dart';
import 'package:the_one_test/core/datasource/generic_data_source.dart';
import 'package:the_one_test/core/http/either.dart';
import 'package:the_one_test/core/http/failure.dart';
import 'package:the_one_test/features/menu/data/models/info_image_model.dart';

abstract interface class InfoPagesDatasource {
  Future<Either<Failure, List<InfoImageModel>>> getAboutUs();

  Future<Either<Failure, List<InfoImageModel>>> getPrivacyPolicy();
}

class InfoPagesDatasourceImpl implements InfoPagesDatasource {
  final GenericDataSource _genericDataSource;

  InfoPagesDatasourceImpl(this._genericDataSource);

  @override
  Future<Either<Failure, List<InfoImageModel>>> getAboutUs() {
    return _genericDataSource.fetchData<InfoImageModel>(
      endpoint: EndPoints.aboutUS,
      fromJson: InfoImageModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<InfoImageModel>>> getPrivacyPolicy() {
    return _genericDataSource.fetchData<InfoImageModel>(
      endpoint: EndPoints.privacyAndPlo,
      fromJson: InfoImageModel.fromJson,
    );
  }
}
