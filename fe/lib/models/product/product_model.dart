import 'package:intl/intl.dart';
import 'package:weario/models/product/variant_model.dart';

class ProductModel {
  final String id;
  final String categoryId;
  final String productCode;
  final String productName;
  final String? description;

  final double minPrice;
  final double maxPrice;

  final List<VariantModel> variantModels;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.productCode,
    required this.productName,
    required this.description,
    required this.minPrice,
    required this.maxPrice,
    this.variantModels = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? "",
      categoryId: json['categoryId'],
      productCode: json['productCode'],
      productName: json['productName'],
      description: json['description'],
      minPrice: (json['minPrice'] as num).toDouble(),
      maxPrice: (json['maxPrice'] as num).toDouble(),
      variantModels:
          (json['variants'] as List?)
              ?.map((e) => VariantModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Formatter dùng chung
  static final _formatter = NumberFormat('#,###', 'vi_VN');

  /// Giá hiển thị chuẩn
  String get priceFormatted {
    if (minPrice == maxPrice) {
      return "${_formatter.format(minPrice)}đ";
    }

    return "${_formatter.format(minPrice)} - ${_formatter.format(maxPrice)}đ";
  }

  /// Ảnh
  String? get image {
    if (variantModels.isEmpty) return null;
    return variantModels.first.imageProductVariant;
  }
}
