import 'package:flutter/material.dart';
import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:provider/provider.dart';

/// Safe landing page for an assigned role whose full dashboard is not yet built.
class RoleLandingScreen extends StatelessWidget {
  const RoleLandingScreen({super.key, required this.roleName});

  final String roleName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FitLink')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user_outlined, size: 48),
              const SizedBox(height: 16),
              Text('$roleName access confirmed', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text(
                'Your account role was verified. This dashboard is not available yet.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.read<UserProvider>().clearSession();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
