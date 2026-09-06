import 'package:equatable/equatable.dart';

class BannerModel extends Equatable {
  const BannerModel({required this.id, required this.imagePath});

  final String id;
  final String imagePath;

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['ID']?.toString() ?? '',
      imagePath: json['ImagePath'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, imagePath];
}
