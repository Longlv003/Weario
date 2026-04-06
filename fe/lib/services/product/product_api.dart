import 'package:weario/main.dart';
import 'package:weario/models/product/product_model.dart';
import 'package:weario/services/api_service.dart';

class ProductApi {
  final ApiService api;

  ProductApi(this.api);

  Future<List<ProductModel>> getProduct() async {
    try {
      final String path = '/product/get-list';
      final res = await api.get(path);
      final List data = res['data'] ?? [];
      logger.d(data);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      logger.e("Fetch api product error: $e");
      return [];
    }
  }
}
