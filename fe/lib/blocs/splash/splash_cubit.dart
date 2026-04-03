import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> initApp() async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2));

    // emit(SplashGoToLogin());

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        emit(SplashGoToLogin());
        return;
      }

      // Force refresh token để đảm bảo token còn hợp lệ
      await currentUser.getIdToken(true);

      emit(SplashGoToHome());
    } catch (e) {
      // Token hết hạn hoặc lỗi → về Login
      await FirebaseAuth.instance.signOut();
      emit(SplashGoToLogin());
    }
  }
}
