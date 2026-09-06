import 'package:equatable/equatable.dart';

class DistrictModel extends Equatable {
  const DistrictModel({required this.id, required this.name});

  final int id;
  final String name;

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['DistrictID'] ?? 0,
      name: json['DistrictName'] ?? json['DistrictEName'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}
