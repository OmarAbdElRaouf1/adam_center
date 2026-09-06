class SubCategoryModel {
  const SubCategoryModel({
    this.id,
    required this.title,
    required this.image,
    required this.products,
  });

  final int? id;
  final String title;
  final String image;
  final List<Map<String, String>> products;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['CategoryId'],
      title: json['CategoryArName'] ?? json['CategoryEnName'] ?? '',
      image: json['CategoryImage'] ?? '',
      products: const [],
    );
  }
}

class ParentCategoryModel {
  const ParentCategoryModel({
    this.id,
    required this.title,
    required this.image,
    required this.subCategories,
  });

  final int? id;
  final String title;
  final String image;
  final List<SubCategoryModel> subCategories;

  factory ParentCategoryModel.fromJson(Map<String, dynamic> json) {
    return ParentCategoryModel(
      id: json['CategoryId'],
      title: json['CategoryArName'] ?? json['CategoryEnName'] ?? '',
      image: json['CategoryImage'] ?? '',
      subCategories: const [],
    );
  }
}
