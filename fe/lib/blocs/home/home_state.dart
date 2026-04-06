import 'package:weario/models/banner/banner_model.dart';
import 'package:weario/models/category/category_model.dart';
import 'package:weario/models/product/product_model.dart';

enum Status { initial, loading, success, error }

class HomeState {
  final Status status;

  final bool isRefreshing;
  final bool scrollToTop;

  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<ProductModel> products;

  HomeState({
    this.status = Status.initial,
    this.isRefreshing = false,
    this.scrollToTop = false,
    this.banners = const [],
    this.categories = const [],
    this.products = const [],
  });

  HomeState copyWith({
    Status? status,
    bool? isRefreshing,
    bool? scrollToTop,
    List<BannerModel>? banners,
    List<CategoryModel>? categories,
    List<ProductModel>? products,
  }) {
    return HomeState(
      status: status ?? this.status,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      scrollToTop: scrollToTop ?? this.scrollToTop,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      products: products ?? this.products,
    );
  }
}
