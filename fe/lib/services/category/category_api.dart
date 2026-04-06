import 'package:weario/main.dart';
import 'package:weario/models/category/category_model.dart';
import 'package:weario/services/api_service.dart';

class CategoryApi {
  final ApiService api;

  CategoryApi(this.api);

  Future<List<CategoryModel>> getCategory() async {
    try {
      final String path = '/category/get-list';
      final res = await api.get(path);
      final List data = res['data'] ?? [];
      logger.d(data);
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      logger.e("Fetch api category error: $e");
      return [];
    }
  }
}
