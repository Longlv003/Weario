import 'package:weario/models/product/variant_model.dart';

class CartBottomSheetState {
  final String selectedSize;
  final String selectedColor;
  final VariantModel? selectedVariant;
  final int quantity;
  final bool isFavorite;

  const CartBottomSheetState({
    this.selectedSize = '',
    this.selectedColor = '',
    this.selectedVariant,
    this.quantity = 1,
    this.isFavorite = false,
  });

  CartBottomSheetState copyWith({
    String? selectedSize,
    String? selectedColor,
    VariantModel? selectedVariant,
    bool clearVariant = false,
    int? quantity,
    bool? isFavorite,
  }) {
    return CartBottomSheetState(
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedVariant: clearVariant
          ? null
          : (selectedVariant ?? this.selectedVariant),
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  int get stock => selectedVariant?.quantity ?? 0;
  bool get isOutOfStock => selectedVariant == null || stock == 0;
}
