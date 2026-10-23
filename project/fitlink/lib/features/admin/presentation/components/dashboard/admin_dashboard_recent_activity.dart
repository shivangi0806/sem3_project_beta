import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/admin/presentation/components/dashboard/admin_recent_activity_component.dart';
import 'package:fitlink/features/admin/presentation/cubits/admin_activity_cubit.dart';
import 'package:fitlink/features/admin/presentation/cubits/admin_activity_state.dart';
import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AdminDashboardRecentActivity extends StatelessWidget {
  const AdminDashboardRecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final token = context.read<UserProvider>().userToken;
    return Expanded(
      child: BlocProvider(
        create: (_) => AdminActivityCubit(token: token)..loadRecentActivity(),
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: navyBlueLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Recent Activity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Builder(
                    builder: (activityContext) => IconButton(
                      tooltip: 'Refresh activity',
                      onPressed: () => activityContext
                          .read<AdminActivityCubit>()
                          .loadRecentActivity(),
                      icon: const Icon(Icons.refresh, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Latest administrative events',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<AdminActivityCubit, AdminActivityState>(
                  builder: (context, state) {
                    if (state is AdminActivityInitial || state is AdminActivityLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is AdminActivityError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.message, textAlign: TextAlign.center),
                            TextButton(
                              onPressed: () => context.read<AdminActivityCubit>().loadRecentActivity(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is AdminActivityLoaded) {
                      return RecentActivityComponent(
                        logs: state.logs,
                        showSearch: false,
                        maxItems: 4,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
