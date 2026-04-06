class VariantModel {
  final String id;
  final String sku;
  final String productId;
  final String color;
  final String size;
  final int quantity;
  final double price;
  final String imageProductVariant;

  VariantModel({
    required this.id,
    required this.sku,
    required this.productId,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    required this.imageProductVariant,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['_id'] ?? '',
      sku: json['sku'] ?? '',
      productId: json['productId'] ?? '',
      color: json['color'] ?? '',
      size: json['size'] ?? '',
      quantity: (json['quantity'] ?? 0) is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,
      price: (json['price'] ?? 0) is double
          ? json['price']
          : double.tryParse(json['price'].toString()) ?? 0.0,
      imageProductVariant: json['imageProductVariant'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sku': sku,
      'productId': productId,
      'color': color,
      'size': size,
      'quantity': quantity,
      'price': price,
      'imageProductVariant': imageProductVariant,
    };
  }
}
