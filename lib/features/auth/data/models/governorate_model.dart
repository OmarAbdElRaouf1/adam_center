import 'package:equatable/equatable.dart';

class GovernorateModel extends Equatable {
  const GovernorateModel({required this.id, required this.name});

  final int id;
  final String name;

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['GovernorateID'] ?? json['ID'] ?? json['Id'] ?? 0,
      name: json['GovernorateName'] ?? json['Name'] ?? json['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}
