class CategoryModel {
  final String id;
  final String categoryCode;
  final String categoryName;
  final String? imageCategory;

  CategoryModel({
    required this.id,
    required this.categoryCode,
    required this.categoryName,
    this.imageCategory,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      categoryCode: json['categoryCode'] ?? '',
      categoryName: json['categoryName'] ?? '',
      imageCategory: json['imageCategory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryCode': categoryCode,
      'categoryName': categoryName,
      'imageCategory': imageCategory,
    };
  }
}
