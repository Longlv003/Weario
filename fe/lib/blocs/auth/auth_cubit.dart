import 'package:weario/blocs/auth/auth_helper.dart';
import 'package:weario/models/account_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:weario/services/auth/auth_api.dart';
import 'auth_state.dart';

var logger = Logger();

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google
  Future<void> handleGoogleAuth() async {
    User? user;
    try {
      emit(AuthLoading());

      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        emit(AuthInitial());
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final OAuthCredential googleCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential credential = await _auth.signInWithCredential(
        googleCredential,
      );

      user = credential.user;
      if (user == null) {
        emit(AuthFailure("Không lấy được thông tin người dùng"));
        return;
      }

      final bool isNewUser = credential.additionalUserInfo?.isNewUser ?? false;

      final idToken = await user.getIdToken();
      if (idToken == null) {
        emit(AuthFailure("Không lấy được token Firebase"));
        return;
      }

      final account = await AuthApi(idToken).verifyFirebaseToken();
      if (account == null) {
        await user.delete();
        emit(AuthFailure("Đăng ký thất bại"));
        return;
      }

      if (isNewUser) {
        await AuthHelper.saveUserToFirestore(
          AccountModel(
            firebaseUid: user.uid,
            fullName: googleUser.displayName ?? '',
            email: googleUser.email,
            provider: 'google',
            avatarUrl: googleUser.photoUrl ?? '',
            // role tự default là 'user'
          ),
        );
      }

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (user != null) {
        try {
          await user.delete();
        } catch (_) {}
      }
      logger.e('FirebaseAuthException: ${e.code} - ${e.message}');
      emit(AuthFailure(AuthHelper.mapFirebaseError(e.code)));
    } catch (e) {
      if (user != null) {
        try {
          await user.delete();
        } catch (_) {}
      }
      logger.e('Google Auth Error: $e');
      emit(AuthInitial());
    }
  }

  // Facebook
  Future<void> handleFacebookAuth() async {
    User? user;
    try {
      emit(AuthLoading());

      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      // print('Facebook status: ${loginResult.status}');
      // print('Facebook message: ${loginResult.message}');

      if (loginResult.status == LoginStatus.cancelled) {
        emit(AuthInitial());
        return;
      }

      if (loginResult.status != LoginStatus.success ||
          loginResult.accessToken == null) {
        emit(AuthFailure("Đăng nhập Facebook thất bại"));
        return;
      }

      final OAuthCredential facebookCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

      final UserCredential credential = await _auth.signInWithCredential(
        facebookCredential,
      );

      user = credential.user;
      if (user == null) {
        emit(AuthFailure("Không lấy được thông tin người dùng"));
        return;
      }

      final bool isNewUser = credential.additionalUserInfo?.isNewUser ?? false;

      final idToken = await user.getIdToken();
      if (idToken == null) {
        emit(AuthFailure("Không lấy được token Firebase"));
        return;
      }

      final account = await AuthApi(idToken).verifyFirebaseToken();
      if (account == null) {
        await user.delete();
        emit(AuthFailure("Đăng ký thất bại"));
        return;
      }

      if (isNewUser) {
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture",
        );
        await AuthHelper.saveUserToFirestore(
          AccountModel(
            firebaseUid: user.uid,
            fullName: userData['name'] ?? user.displayName ?? '',
            email: userData['email'] ?? user.email ?? '',
            provider: 'facebook',
            avatarUrl:
                userData['picture']?['data']?['url'] ?? user.photoURL ?? '',
            // role tự default là 'user'
          ),
        );
      }

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (user != null) {
        try {
          await user.delete();
        } catch (_) {}
      }
      logger.e('FirebaseAuthException: ${e.code} - ${e.message}');
      emit(AuthFailure(AuthHelper.mapFirebaseError(e.code)));
    } catch (e) {
      if (user != null) {
        try {
          await user.delete();
        } catch (_) {}
      }
      logger.e('Facebook Auth Error: $e');
      emit(AuthInitial());
    }
  }

  Future<void> handleLogout() async {
    try {
      emit(AuthLoading());

      await _auth.signOut();

      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {}

      try {
        await FacebookAuth.instance.logOut();
      } catch (_) {}

      emit(AuthInitial());
    } catch (e) {
      logger.e('Logout Error: $e');
      emit(AuthFailure("Logout failed"));
    }
  }
}
