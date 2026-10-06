// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../cubits/auth_cubit.dart';
// import '../cubits/auth_state.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthCubit, AuthState>(
//       listener: (context, state) {
//         if (state is AuthSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }

//         if (state is AuthError) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Register"),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   labelText: "Name",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               BlocBuilder<AuthCubit, AuthState>(
//                 builder: (context, state) {
//                   if (state is AuthLoading) {
//                     return const CircularProgressIndicator();
//                   }

//                   return SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         context.read<AuthCubit>().register(
//                           name: nameController.text.trim(),
//                           email: emailController.text.trim(),
//                           password: passwordController.text,
//                         );
//                       },
//                       child: const Text("Register"),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class RegisterScreen extends StatefulWidget {
const RegisterScreen({super.key});

@override
State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
final nameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();

String? selectedRole;

@override
void dispose() {
nameController.dispose();
emailController.dispose();
passwordController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return BlocListener<AuthCubit, AuthState>(
listener: (context, state) {
if (state is AuthSuccess) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(state.message),
),
);
}


    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }
  },

  child: Scaffold(
    appBar: AppBar(
      title: const Text("Register"),
    ),

    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [

              // =========================
              // NAME
              // =========================

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // =========================
              // EMAIL
              // =========================

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // =========================
              // PASSWORD
              // =========================

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // =========================
              // ROLE DROPDOWN
              // =========================

              DropdownButtonFormField<String>(
                value: selectedRole,

                decoration: const InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(
                    value: "COACH",
                    child: Text("Coach"),
                  ),
                  DropdownMenuItem(
                    value: "ADMIN",
                    child: Text("Admin"),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // =========================
              // REGISTER BUTTON
              // =========================

              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ElevatedButton(
                    onPressed: () {
                      if (selectedRole == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content:
                                Text("Please select a role"),
                          ),
                        );
                        return;
                      }

                      context.read<AuthCubit>().register(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text,
                        roleId: selectedRole!,
                      );
                    },

                    child: const Text("Register"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);


}
}
