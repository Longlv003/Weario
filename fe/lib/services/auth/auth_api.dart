import 'package:logger/web.dart';
import 'package:weario/models/account_model.dart';
import 'package:weario/services/api_service.dart';

var logger = Logger();

class AuthApi {
  final ApiService _api;

  AuthApi(String token) : _api = ApiService(token: token);

  Future<AccountModel?> verifyFirebaseToken() async {
    try {
      final String path = '/auth/firebase';
      final res = await _api.post(path, {});
      logger.d(res);
      final data = res['data'];
      if (data != null) {
        return AccountModel.fromMap(res['data']);
      } else {
        logger.e("Verify Firebase failed: ${res['msg']}");
        return null;
      }
    } catch (e) {
      logger.e("Error verifyFirebaseToken: $e");
      return null;
    }
  }
}
