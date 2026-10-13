import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/admin/presentation/components/dashboard/admin_dashboard_screen.dart';
import 'package:fitlink/features/admin/presentation/cubits/users_cubit.dart';
import 'package:fitlink/features/admin/screens/dashboard_page.dart';
import 'package:fitlink/features/admin/screens/previleges_page.dart';
import 'package:fitlink/features/admin/screens/recent_activities.dart';
import 'package:fitlink/features/admin/screens/roles_page.dart';
import 'package:fitlink/features/admin/screens/user_page.dart';
import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UsersCubit(token: context.read<UserProvider>().userToken)
            ..loadUsers(),
      child: Scaffold(
        backgroundColor: navyBlue,
        appBar: AppBar(
          backgroundColor: navyBlue,
          foregroundColor: Colors.white,
          title: const Text(
            'FitLink Admin',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              tooltip: 'Log out',
              onPressed: () {
                // Logout will be added later.
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: navyBlueLight,
          surfaceTintColor: Colors.transparent,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 184,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accentBlue, navyBlueMid],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'FitLink Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Management console',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _AdminDrawerTile(
                icon: Icons.dashboard_outlined,
                title: 'Dashboard',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DashboardPage()),
                  );
                },
              ),
              _AdminDrawerTile(
                icon: Icons.people_outline,
                title: 'Users',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => UsersCubit(
                          token: context.read<UserProvider>().userToken,
                        )..loadUsers(),
                        child: const UserPage(),
                      ),
                    ),
                  );
                },
              ),
              _AdminDrawerTile(
                icon: Icons.workspace_premium_outlined,
                title: 'Privileges',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PrevilegesPage()),
                  );
                },
              ),
              _AdminDrawerTile(
                icon: Icons.badge_outlined,
                title: 'Roles',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RolesPage()),
                  );
                },
              ),
              _AdminDrawerTile(
                icon: Icons.history_rounded,
                title: 'Recent Activity',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RecentActivities()),
                  );
                },
              ),
            ],
          ),
        ),
        body: const AdminDashboardScreenComponent(),
      ),
    );
  }
}

class _AdminDrawerTile extends StatelessWidget {
  const _AdminDrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: ListTile(
        minVerticalPadding: 10,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: accentBlue.withOpacity(0.16),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF91C5FF), size: 21),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white38,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}
