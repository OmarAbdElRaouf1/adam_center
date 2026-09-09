import 'package:equatable/equatable.dart';

class InfoImageModel extends Equatable {
  final String id;
  final String imagePath;

  const InfoImageModel({required this.id, required this.imagePath});

  factory InfoImageModel.fromJson(Map<String, dynamic> json) {
    return InfoImageModel(
      id: json['ID']?.toString() ?? '',
      imagePath: json['ImagePath'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, imagePath];
}
