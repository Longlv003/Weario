import 'package:bloc/bloc.dart';
import 'package:weario/blocs/cart_bottom_sheet/bottom_sheet_state.dart';
import 'package:weario/models/product/product_model.dart';
import 'package:weario/models/product/variant_model.dart';

class CartBottomSheetCubit extends Cubit<CartBottomSheetState> {
  final ProductModel product;

  CartBottomSheetCubit(this.product) : super(const CartBottomSheetState()) {
    _init();
  }

  void _init() {
    if (product.variantModels.isEmpty) return;
    final first = product.variantModels.first;
    emit(
      state.copyWith(
        selectedSize: first.size,
        selectedColor: first.color,
        selectedVariant: first,
      ),
    );
  }

  VariantModel? _findVariant(String size, String color) {
    try {
      return product.variantModels.firstWhere(
        (v) => v.size == size && v.color == color,
      );
    } catch (_) {
      return null;
    }
  }

  void selectSize(String size) {
    final variant = _findVariant(size, state.selectedColor);
    emit(
      state.copyWith(
        selectedSize: size,
        selectedVariant: variant,
        clearVariant: variant == null,
        quantity: 1,
      ),
    );
  }

  void selectColor(String color) {
    final variant = _findVariant(state.selectedSize, color);
    emit(
      state.copyWith(
        selectedColor: color,
        selectedVariant: variant,
        clearVariant: variant == null,
        quantity: 1,
      ),
    );
  }

  void increaseQuantity() {
    if (state.quantity < state.stock) {
      emit(state.copyWith(quantity: state.quantity + 1));
    }
  }

  void decreaseQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }
}
