import 'package:flutter/material.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitlink/features/auth/presenttation/cubits/auth_cubit.dart';
import 'package:fitlink/features/auth/presenttation/cubits/auth_state.dart';
import 'register_screen.dart';
import 'package:fitlink/features/auth/presenttation/screens/admin_dashboard_screen.dart';
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
     print("LOGIN SCREEN BUILDING");
    return BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      print("LOGIN SUCCESS: ${state.message}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }

    if (state is AuthError) {
      print("LOGIN ERROR: ${state.message}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }
  },
   child:  Scaffold(
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
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
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const 
                        RegisterScreen()
                        //AdminDashboardScreen()
                        ));
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
     ) );
  }
}