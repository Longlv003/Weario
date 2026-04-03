import 'package:weario/blocs/auth/auth_cubit.dart';
import 'package:weario/blocs/auth/auth_state.dart';
import 'package:weario/blocs/auth/login/login_cubit.dart';
import 'package:weario/blocs/auth/login/login_state.dart';
import 'package:weario/common/widgets/button_app.dart';
import 'package:weario/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                Get.offAllNamed(Routes.homePage);
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Get.offAllNamed(Routes.homePage);
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            final loginCubit = context.read<LoginCubit>();
            final authCubit = context.read<AuthCubit>();

            return BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                final isLoading = state is LoginLoading;
                final errorMessage = state is LoginFailure
                    ? state.message
                    : null;

                return Scaffold(
                  backgroundColor: Colors.white,
                  resizeToAvoidBottomInset: true,
                  body: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Header Image
                          ClipPath(
                            clipper: CustomHeaderClipper(),
                            child: Image.asset(
                              'assets/images/logo_welcome.png',
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                const Text(
                                  "Chào mừng bạn",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Đăng nhập tài khoản",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // Input Email
                                TextFormField(
                                  cursorColor: const Color(0xFF1B8E42),
                                  onChanged: loginCubit.onEmailChanged,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "Email",
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    floatingLabelStyle: const TextStyle(
                                      color: Color(0xFF1B8E42),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1B8E42),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // Input Password
                                TextFormField(
                                  obscureText: _obscureText,
                                  cursorColor: const Color(0xFF1B8E42),
                                  onChanged: loginCubit.onPassChanged,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    floatingLabelStyle: const TextStyle(
                                      color: Color(0xFF1B8E42),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1B8E42),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscureText = !_obscureText,
                                      ),
                                    ),
                                  ),
                                ),

                                // Error message
                                if (errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        errorMessage,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                // Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "Quên mật khẩu ?",
                                      style: TextStyle(
                                        color: Color(0xFF1B8E42),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),

                                // Nút Đăng nhập
                                isLoading
                                    ? const CircularProgressIndicator(
                                        color: Color(0xFF1B8E42),
                                      )
                                    : AppButton(
                                        title: "Đăng nhập",
                                        onPressed: loginCubit.handleLogin,
                                      ),

                                const SizedBox(height: 30),

                                // Divider
                                Row(
                                  children: const [
                                    Expanded(child: Divider(thickness: 1)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        "Hoặc",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Expanded(child: Divider(thickness: 1)),
                                  ],
                                ),

                                const SizedBox(height: 30),

                                // Social Login
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          authCubit.handleFacebookAuth(),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Ink(
                                        child: Image.asset(
                                          'assets/images/logo_facebook.png',
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () => authCubit.handleGoogleAuth(),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Ink(
                                        child: Image.asset(
                                          'assets/images/logo_google.png',
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 40),

                                // Sign up
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Bạn không có tài khoản "),
                                    GestureDetector(
                                      onTap: () =>
                                          Get.offAllNamed(Routes.registerPage),
                                      child: const Text(
                                        "Tạo tài khoản",
                                        style: TextStyle(
                                          color: Color(0xFF62C063),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.7);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    var secondControlPoint = Offset(size.width * 0.8, size.height * 0.9);
    var secondEndPoint = Offset(size.width, size.height * 0.5);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
