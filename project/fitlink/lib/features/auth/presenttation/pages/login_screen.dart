import 'package:flutter/material.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitlink/features/auth/presenttation/cubits/auth_cubit.dart';
import 'package:fitlink/features/auth/presenttation/cubits/auth_state.dart';
import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'register_screen.dart';
import 'package:fitlink/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:fitlink/features/coach/presentation/screens/coachdashboard_screen.dart';
import 'package:fitlink/features/auth/presenttation/cubits/role_check_cubit.dart';
import 'package:fitlink/features/auth/presenttation/cubits/role_check_state.dart';
import 'role_landing_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoleCheckCubit, RoleCheckState>(
      listener: (context, roleState) {
        if (roleState is RoleCheckResolved) {
          final roleId = roleState.role.roleId.trim().toUpperCase();
          final roleName = roleState.role.roleName.trim().toLowerCase();
          final Widget destination;
          if (roleId == 'ROLE_ADMIN' ||
              roleName == 'admin' ||
              roleName == 'administrator') {
            destination = AdminDashboardScreen();
          } else if (roleId == 'ROLE_COACH' || roleName == 'coach') {
            destination = const CoachdashboardScreen();
          } else if (roleId == 'ROLE_PLAYER' || roleName == 'player') {
            destination = RoleLandingScreen(roleName: roleState.role.roleName);
          } else {
            context.read<UserProvider>().clearSession();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Role "${roleState.role.roleName}" has no frontend destination yet.',
                ),
              ),
            );
            return;
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        } else if (roleState is RoleCheckError) {
          context.read<UserProvider>().clearSession();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(roleState.message)));
        }
      },
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccessState) {
            context.read<UserProvider>().setSession(state.user);
            context.read<RoleCheckCubit>().resolve(
              token: state.user.accessToken,
              roleId: state.user.user.roleId,
            );
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // App title
                    const Text(
                      'FitLink',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: accentBlue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Connect. Track. Perform.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),

                    const SizedBox(height: 50),

                    // Login heading
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Login to continue to FitLink',
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),

                    const SizedBox(height: 30),

                    // Email
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: navyBlueLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Password
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: navyBlueLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Login button
                    SizedBox(
                      //                 height: 52,
                      //                 child: ElevatedButton(
                      //                   onPressed: () {
                      //                   //  We will connect AuthCubit here next
                      //                    print("BUTTON CLICKED");
                      //                      context.read<AuthCubit>().login(
                      //   email: emailController.text.trim(),
                      //   password: passwordController.text,
                      //                    );

                      // //   onPressed: () {
                      // // print("BUTTON CLICKED");
                      // //                     };
                      // },
                      //                   style: ElevatedButton.styleFrom(
                      //                     backgroundColor: accentBlue,
                      //                     foregroundColor: Colors.white,
                      //                     shape: RoundedRectangleBorder(
                      //                       borderRadius: BorderRadius.circular(14),
                      //                     ),
                      //                   ),
                      //                   child: const Text(
                      //                     'Login',
                      //                     style: TextStyle(
                      //                       fontSize: 17,
                      //                       fontWeight: FontWeight.bold,
                      //                     ),
                      //                   ),
                      //                 ),
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          print("BUTTON CLICKED");

                          context.read<AuthCubit>().login(
                            email: emailController.text.trim(),
                            password: passwordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            // We will navigate to RegisterScreen later
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                                //AdminDashboardScreen()
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: accentBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
