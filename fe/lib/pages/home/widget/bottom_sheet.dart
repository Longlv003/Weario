import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weario/blocs/cart_bottom_sheet/bottom_sheet_cubit.dart';
import 'package:weario/blocs/cart_bottom_sheet/bottom_sheet_state.dart';

import 'package:weario/models/product/product_model.dart';

class AddToCartBottomSheet extends StatelessWidget {
  final ProductModel product;

  static final _formatter = NumberFormat('#,###', 'vi_VN');

  const AddToCartBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBottomSheetCubit(product),
      child: _AddToCartBottomSheetView(product: product, formatter: _formatter),
    );
  }
}

class _AddToCartBottomSheetView extends StatelessWidget {
  final ProductModel product;
  final NumberFormat formatter;

  const _AddToCartBottomSheetView({
    required this.product,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartBottomSheetCubit>();
    final sizes = product.variantModels.map((v) => v.size).toSet().toList();
    final colors = product.variantModels.map((v) => v.color).toSet().toList();

    return BlocBuilder<CartBottomSheetCubit, CartBottomSheetState>(
      builder: (context, state) {
        final variant = state.selectedVariant;
        final stock = state.stock;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Thêm vào giỏ hàng",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Product info
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        variant?.imageProductVariant ?? product.image ?? "",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          // Giá đơn vị
                          // Text(
                          //   variant != null
                          //       ? "${formatter.format(variant.price)}đ"
                          //       : product.priceFormatted,
                          //   style: const TextStyle(
                          //     fontSize: 12,
                          //     color: Colors.grey,
                          //     decoration: TextDecoration.lineThrough,
                          //   ),
                          // ),

                          // Tổng tiền
                          Text(
                            variant != null
                                ? "${formatter.format(variant.price * state.quantity)}đ"
                                : product.priceFormatted,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),

                          const SizedBox(height: 2),
                          Text(
                            stock > 0 ? "Còn $stock sản phẩm" : "Hết hàng",
                            style: TextStyle(
                              fontSize: 12,
                              color: stock > 0 ? Colors.grey : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Size picker
              _SectionPicker(
                label: "Kích thước",
                items: sizes,
                selected: state.selectedSize,
                selectedColor: Colors.blue,
                selectedBgColor: Colors.blue.shade50,
                onTap: cubit.selectSize,
              ),

              const SizedBox(height: 16),

              // Color picker
              _SectionPicker(
                label: "Màu sắc",
                items: colors,
                selected: state.selectedColor,
                selectedColor: Colors.orange,
                selectedBgColor: Colors.orange.shade50,
                onTap: cubit.selectColor,
              ),

              const SizedBox(height: 16),

              // Quantity
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      "Số lượng",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: cubit.decreaseQuantity,
                            icon: const Icon(Icons.remove),
                            iconSize: 18,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              "${state.quantity}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: cubit.increaseQuantity,
                            icon: const Icon(Icons.add),
                            iconSize: 18,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Button
              // Button row
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                child: Row(
                  children: [
                    // Nút yêu thích
                    GestureDetector(
                      onTap: cubit.toggleFavorite,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          state.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: state.isFavorite ? Colors.red : Colors.grey,
                          size: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Nút thêm vào giỏ
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state.isOutOfStock
                              ? null
                              : () {
                                  // TODO: xử lý thêm vào giỏ
                                  Navigator.pop(context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            state.isOutOfStock
                                ? "Hết hàng"
                                : "Thêm vào giỏ • ${formatter.format(variant!.price * state.quantity)}đ",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget picker tái sử dụng cho size và color
class _SectionPicker extends StatelessWidget {
  final String label;
  final List<String> items;
  final String selected;
  final Color selectedColor;
  final Color selectedBgColor;
  final void Function(String) onTap;

  const _SectionPicker({
    required this.label,
    required this.items,
    required this.selected,
    required this.selectedColor,
    required this.selectedBgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              final isSelected = selected == item;
              return GestureDetector(
                onTap: () => onTap(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? selectedBgColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? selectedColor : Colors.grey.shade300,
                      width: isSelected ? 1.5 : 0.5,
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isSelected ? selectedColor : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
