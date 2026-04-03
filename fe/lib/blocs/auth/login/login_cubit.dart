import 'dart:async';
import 'package:weario/blocs/auth/auth_helper.dart';
import 'package:weario/blocs/auth/login/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weario/services/auth/auth_api.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _pass = '';

  void onEmailChanged(String email) => _email = email;
  void onPassChanged(String pass) => _pass = pass;

  void reset() => emit(LoginInitial());

  Future<void> handleLogin() async {
    try {
      emit(LoginLoading());

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _email.trim(),
        password: _pass.trim(),
      );

      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        emit(LoginFailure("Không lấy được token Firebase"));
        return;
      }

      final account = await AuthApi(idToken).verifyFirebaseToken();
      if (account == null) {
        emit(LoginFailure("Đăng nhập thất bại"));
        return;
      }

      emit(LoginSuccess(account));
    } on FirebaseAuthException catch (e) {
      logger.e('Login error: ${e.code} - ${e.message}');
      emit(LoginFailure(AuthHelper.mapFirebaseError(e.code)));
    } catch (e) {
      logger.e('Login Error: $e');
      emit(LoginInitial());
    }
  }
}
