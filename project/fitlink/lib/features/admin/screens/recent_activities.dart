import 'package:fitlink/features/admin/presentation/components/dashboard/admin_recent_activity_component.dart';
import 'package:fitlink/features/admin/presentation/cubits/admin_activity_cubit.dart';
import 'package:fitlink/features/admin/presentation/cubits/admin_activity_state.dart';
import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({super.key});

  @override
  Widget build(BuildContext context) {
    final token = context.read<UserProvider>().userToken;
    return BlocProvider(
      create: (_) => AdminActivityCubit(token: token)..loadRecentActivity(),
      child: const _RecentActivitiesView(),
    );
  }
}

class _RecentActivitiesView extends StatelessWidget {
  const _RecentActivitiesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Activity'),
        actions: [
          IconButton(
            tooltip: 'Refresh activity',
            onPressed: () =>
                context.read<AdminActivityCubit>().loadRecentActivity(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<AdminActivityCubit, AdminActivityState>(
        builder: (context, state) {
          if (state is AdminActivityInitial || state is AdminActivityLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdminActivityError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 40),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => context
                          .read<AdminActivityCubit>()
                          .loadRecentActivity(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is! AdminActivityLoaded) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(child: RecentActivityComponent(logs: state.logs)),
                if (state.hasMore || state.loadMoreError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.loadMoreError != null) ...[
                          Flexible(
                            child: Text(
                              state.loadMoreError!,
                              style: const TextStyle(color: Colors.redAccent),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        TextButton.icon(
                          onPressed: state.isLoadingMore
                              ? null
                              : () => context
                                    .read<AdminActivityCubit>()
                                    .loadMore(),
                          icon: state.isLoadingMore
                              ? const SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.expand_more),
                          label: Text(
                            state.loadMoreError == null ? 'Load more' : 'Retry',
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
