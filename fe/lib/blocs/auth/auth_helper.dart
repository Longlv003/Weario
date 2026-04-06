import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weario/models/account/account_model.dart';

class AuthHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveUserToFirestore(AccountModel user) async {
    await _firestore
        .collection('users')
        .doc(user.firebaseUid)
        .set(user.toMap());
  }

  static String mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email này đã được sử dụng';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu';
      case 'user-not-found':
        return 'Tài khoản không tồn tại';
      case 'wrong-password':
        return 'Sai mật khẩu';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng';
      case 'account-exists-with-difweariorent-credential':
        return 'Tài khoản đã tồn tại với phương thức đăng nhập khác';
      default:
        return 'Thất bại ($code)';
    }
  }
}
