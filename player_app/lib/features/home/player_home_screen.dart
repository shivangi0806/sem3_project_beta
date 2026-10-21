import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/user.dart';
import '../auth/cubit/auth_cubit.dart';
import '../auth/screens/login_screen.dart';

class PlayerHomeScreen extends StatelessWidget {
  final UserSession session;

  const PlayerHomeScreen({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final player = session.user;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1929),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1929),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'FitLink',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Log out',
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'YOUR FITNESS JOURNEY',
                    style: TextStyle(
                      color: Color(0xFF75B8FF),
                      letterSpacing: 1.5,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome, ${player.username}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Track your activity and stay connected.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Player account card
                  _panel(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Color(0xFF294764),
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                player.email,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Wearable section
                  _panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.watch_rounded,
                              color: Color(0xFF75B8FF),
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'My Wearable',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Your activity readings will appear here '
                          'when wearable data is available.',
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(color: Color(0xFF294764)),
                        const SizedBox(height: 8),
                        _metric(
                          icon: Icons.favorite_outline,
                          label: 'Heart rate',
                          value: 'No data yet',
                        ),
                        _metric(
                          icon: Icons.directions_walk_rounded,
                          label: 'Steps',
                          value: 'No data yet',
                        ),
                        _metric(
                          icon: Icons.local_fire_department_outlined,
                          label: 'Calories',
                          value: 'No data yet',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Future connection and sync integration
                  _panel(
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.sync_rounded,
                          color: Color(0xFF75B8FF),
                          size: 28,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sync your activity',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Watch connection and Sync Now actions '
                          'will be connected to the existing '
                          'wearable service in the next step.',
                          style: TextStyle(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF132F4C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF294764)),
      ),
      child: child,
    );
  }

  Widget _metric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF75B8FF)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    context.read<AuthCubit>().reset();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
}