import 'package:weario/blocs/auth/auth_helper.dart';
import 'package:weario/blocs/auth/register/register_state.dart';
import 'package:weario/models/account/account_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weario/services/auth/auth_api.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _fullName = '';
  String _email = '';
  String _pass = '';
  String _confirmPass = '';

  void onNameChanged(String name) => _fullName = name.trim();
  void onEmailChanged(String email) => _email = email.trim();
  void onPassChanged(String pass) => _pass = pass.trim();
  void onConfirmPassChanged(String confirmPass) =>
      _confirmPass = confirmPass.trim();

  // Email & Pass
  Future<void> handleRegister() async {
    if (_fullName.isEmpty ||
        _email.isEmpty ||
        _pass.isEmpty ||
        _confirmPass.isEmpty) {
      emit(RegisterFailure("Vui lòng điền đầy đủ thông tin"));
      return;
    }

    if (_pass != _confirmPass) {
      emit(RegisterFailure("Mật khẩu xác nhận không khớp"));
      return;
    }

    if (_pass.length < 6) {
      emit(RegisterFailure("Mật khẩu phải có ít nhất 6 ký tự"));
      return;
    }

    User? user;

    try {
      emit(RegisterLoading());

      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
            email: _email.trim(),
            password: _pass.trim(),
          );

      user = credential.user;
      if (user == null) {
        emit(RegisterFailure("Đăng ký thất bại, thử lại"));
        return;
      }

      await user.updateDisplayName(_fullName.trim());

      final idToken = await user.getIdToken();
      if (idToken == null) {
        emit(RegisterFailure("Không lấy được token Firebase"));
        return;
      }

      final account = await AuthApi(idToken).verifyFirebaseToken();
      if (account == null) {
        await user.delete();
        emit(RegisterFailure("Đăng ký thất bại"));
        return;
      }

      await AuthHelper.saveUserToFirestore(
        AccountModel(
          firebaseUid: user.uid,
          fullName: _fullName.trim(),
          email: _email.trim(),
          provider: 'email',
        ),
      );

      emit(RegisterSuccess(account));
    } on FirebaseAuthException catch (e) {
      if (user != null) {
        try {
          await user.delete();
        } catch (_) {}
      }
      logger.e('FirebaseAuthException: ${e.code} - ${e.message}');
      emit(RegisterFailure(AuthHelper.mapFirebaseError(e.code)));
    } catch (e) {
      if (user != null) {
        try {
          await user.delete();
        } catch (_) {}
      }
      logger.e('Register Error: $e');
      emit(RegisterFailure("Đã có lỗi xảy ra, thử lại"));
    }
  }
}
