import 'package:weario/blocs/splash/splash_cubit.dart';
import 'package:weario/blocs/splash/splash_state.dart';
import 'package:weario/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..initApp(),
      child: BlocConsumer<SplashCubit, SplashState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is SplashGoToLogin) {
            Get.offAllNamed(Routes.loginPage);
          } else if (state is SplashGoToHome) {
            Get.offAllNamed(Routes.homePage);
          }
        },
      ),
    );
  }
}
