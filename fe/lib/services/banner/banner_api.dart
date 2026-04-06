import 'package:weario/main.dart';
import 'package:weario/models/banner/banner_model.dart';
import 'package:weario/services/api_service.dart';

class BannerApi {
  final ApiService api;

  BannerApi(this.api);

  Future<List<BannerModel>> getBanner() async {
    try {
      final String path = '/banner/sale/get-list';
      final res = await api.get(path);
      logger.d("fetch banner: $res");
      final List data = res['data'] ?? [];
      logger.d("data: $data");

      return data.map((e) => BannerModel.fromJson(e)).toList();
    } catch (e) {
      logger.e("Fetch api category error: $e");
      return [];
    }
  }
}
