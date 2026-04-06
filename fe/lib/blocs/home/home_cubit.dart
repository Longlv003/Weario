import 'package:bloc/bloc.dart';
import 'package:weario/blocs/home/home_state.dart';
import 'package:weario/main.dart';
import 'package:weario/services/api_service.dart';
import 'package:weario/services/banner/banner_api.dart';
import 'package:weario/services/category/category_api.dart';
import 'package:weario/services/product/product_api.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiService apiService;

  HomeCubit(this.apiService) : super(HomeState());

  Future<void> fetchBanner() async {
    try {
      emit(state.copyWith(status: Status.loading));
      final bannerApi = BannerApi(apiService);
      final banners = await bannerApi.getBanner();
      emit(state.copyWith(banners: banners, status: Status.success));
    } catch (e) {
      logger.e("fetch api banner: $e");
      emit(state.copyWith(status: Status.error));
    }
  }

  Future<void> fetchCategories() async {
    try {
      emit(state.copyWith(status: Status.loading));
      final categoryApi = CategoryApi(apiService);
      final categories = await categoryApi.getCategory();
      emit(state.copyWith(categories: categories, status: Status.success));
    } catch (e) {
      logger.e("fetch api category: $e");
      emit(state.copyWith(status: Status.error));
    }
  }

  Future<void> fetchProducts() async {
    try {
      emit(state.copyWith(status: Status.loading));
      final productApi = ProductApi(apiService);
      final products = await productApi.getProduct();
      emit(state.copyWith(products: products, status: Status.success));
    } catch (e) {
      logger.e("fetch api product: $e");
      emit(state.copyWith(status: Status.error));
    }
  }

  Future<void> refreshAll() async {
    if (state.isRefreshing) return;

    emit(state.copyWith(isRefreshing: true));

    await fetchBanner();
    await fetchCategories();
    await fetchProducts();

    emit(state.copyWith(isRefreshing: false));
  }

  void scrollToTop() {
    emit(state.copyWith(scrollToTop: true));
  }

  void resetScroll() {
    emit(state.copyWith(scrollToTop: false));
  }
}
