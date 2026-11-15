import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:fitlink/features/coach/analytics/bloc/analytics_bloc.dart';
import 'package:fitlink/features/coach/analytics/bloc/analytics_event.dart';
import 'package:fitlink/features/coach/analytics/bloc/analytics_state.dart';
import 'package:fitlink/features/coach/analytics/services/analytics_service.dart';
import 'package:fitlink/features/coach/analytics/widgets/analytics_dashboard_grid.dart';
import 'package:fitlink/features/coach/analytics/widgets/period_selector.dart';
import 'package:fitlink/features/coach/analytics/widgets/player_selector.dart';
import 'package:fitlink/features/coach/cubit/coach_roster_cubit.dart';
import 'package:fitlink/features/coach/data/services/coach_roster_service.dart';

class AnalyticsBoardScreen extends StatelessWidget {
  const AnalyticsBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserProvider>();
    if (!session.isAuthenticated || session.user?.roleId != 'ROLE_COACH') {
      return const Center(
        child: Text('Sign in with a coach account to view analytics.'),
      );
    }

    return BlocProvider(
      key: ValueKey('analytics-roster:${session.userToken}'),
      create: (_) =>
          CoachRosterCubit(CoachRosterService(token: session.userToken))
            ..load(),
      child: BlocProvider(
        key: ValueKey('analytics-report:${session.userToken}'),
        create: (_) => AnalyticsBloc(AnalyticsService()),
        child: const AnalyticsBoardContent(),
      ),
    );
  }
}

class AnalyticsBoardContent extends StatefulWidget {
  const AnalyticsBoardContent({super.key});

  @override
  State<AnalyticsBoardContent> createState() => _AnalyticsBoardContentState();
}

class _AnalyticsBoardContentState extends State<AnalyticsBoardContent> {
  String selectedPeriod = 'This Week';
  String? selectedPlayerId;
  DateTimeRange? customRange;

  String get apiPeriod => switch (selectedPeriod) {
    'Today' => 'daily',
    'This Month' => 'monthly',
    'Custom Range' => 'custom',
    _ => 'weekly',
  };

  String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  Future<void> _requestReport() async {
    final playerId = selectedPlayerId;
    if (playerId == null) return;

    if (selectedPeriod == 'Custom Range' && customRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a custom date range first.')),
      );
      return;
    }

    final now = DateTime.now();
    final token = context.read<UserProvider>().userToken;
    context.read<AnalyticsBloc>().add(
      AnalyticsReportRequested(
        token: token,
        playerId: playerId,
        period: apiPeriod,
        startDate: customRange != null && apiPeriod == 'custom'
            ? _date(customRange!.start)
            : _date(now),
        endDate: apiPeriod == 'custom' ? _date(customRange!.end) : null,
        timezone: 'Asia/Kolkata',
        groupBy: apiPeriod == 'custom' ? 'daily' : null,
      ),
    );
  }

  Future<void> _changePeriod(String value) async {
    setState(() {
      selectedPeriod = value;
      customRange = null;
    });
    context.read<AnalyticsBloc>().add(const AnalyticsReportCleared());
    if (value == 'Custom Range') {
      final now = DateTime.now();
      final range = await showDateRangePicker(
        context: context,
        firstDate: DateTime(now.year - 5),
        lastDate: now,
        initialDateRange: DateTimeRange(
          start: now.subtract(const Duration(days: 6)),
          end: now,
        ),
        helpText: 'Select analytics date range (up to 366 days)',
      );
      if (!mounted || range == null) return;
      if (range.end.difference(range.start).inDays > 365) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Custom ranges can include up to 366 days.'),
          ),
        );
        return;
      }
      setState(() => customRange = range);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyBlue,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: BlocBuilder<CoachRosterCubit, CoachRosterState>(
                builder: (context, rosterState) => ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1D4970), Color(0xFF163754)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF79B8FF,
                              ).withValues(alpha: .16),
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: const Icon(
                              Icons.query_stats_rounded,
                              color: Color(0xFF9DCEFF),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Team analytics',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -.4,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Review athlete performance and training consistency.',
                                  style: TextStyle(
                                    color: Color(0xFFBDD0E2),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: navyBlueLight,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .07),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                color: Color(0xFF79B8FF),
                                size: 19,
                              ),
                              SizedBox(width: 9),
                              Text(
                                'Report filters',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final player = PlayerSelector(
                                players: rosterState.roster,
                                selectedPlayerId: selectedPlayerId,
                                onChanged: (value) {
                                  setState(() => selectedPlayerId = value);
                                  context.read<AnalyticsBloc>().add(
                                    const AnalyticsReportCleared(),
                                  );
                                },
                              );
                              final period = PeriodSelector(
                                selectedPeriod: selectedPeriod,
                                onChanged: _changePeriod,
                              );
                              return constraints.maxWidth < 600
                                  ? Column(
                                      children: [
                                        player,
                                        const SizedBox(height: 12),
                                        period,
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(flex: 2, child: player),
                                        const SizedBox(width: 14),
                                        Expanded(child: period),
                                      ],
                                    );
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<AnalyticsBloc, AnalyticsState>(
                            builder: (context, analyticsState) {
                              final loading =
                                  analyticsState is AnalyticsLoading;
                              final canFetch =
                                  selectedPlayerId != null &&
                                  (selectedPeriod != 'Custom Range' ||
                                      customRange != null) &&
                                  !loading;
                              return Align(
                                alignment: Alignment.centerRight,
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF4F9BE8),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.white
                                        .withValues(alpha: .08),
                                    disabledForegroundColor: Colors.white38,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: canFetch ? _requestReport : null,
                                  icon: loading
                                      ? const SizedBox(
                                          width: 17,
                                          height: 17,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.insights_rounded,
                                          size: 19,
                                        ),
                                  label: Text(
                                    loading
                                        ? 'Building report…'
                                        : 'View analytics',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (rosterState.loading && rosterState.roster.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 56),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF79B8FF),
                          ),
                        ),
                      )
                    else if (rosterState.error != null &&
                        rosterState.roster.isEmpty)
                      _NoticeCard(
                        icon: Icons.error_outline,
                        message: rosterState.error!,
                        onRetry: () => context.read<CoachRosterCubit>().load(),
                      )
                    else if (rosterState.roster.isEmpty)
                      const _NoticeCard(
                        icon: Icons.group_outlined,
                        message:
                            'Your athlete roster is empty. Add an athlete to view analytics.',
                      )
                    else if (selectedPlayerId == null)
                      const _NoticeCard(
                        icon: Icons.query_stats_rounded,
                        message: 'Choose an athlete to view analytics.',
                      )
                    else
                      BlocBuilder<AnalyticsBloc, AnalyticsState>(
                        builder: (context, analyticsState) =>
                            switch (analyticsState) {
                              AnalyticsInitial() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      'Sample analytics data',
                                      style: TextStyle(
                                        color: Color(0xFFFFC66D),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const AnalyticsDashboardGrid(
                                    analyticsReport: null,
                                  ),
                                ],
                              ),
                              AnalyticsLoading() => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 70),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF79B8FF),
                                  ),
                                ),
                              ),
                              AnalyticsError(:final message) => _NoticeCard(
                                icon: Icons.error_outline,
                                message: message,
                              ),
                              AnalyticsSuccess(:final analyticsModel) =>
                                AnalyticsDashboardGrid(
                                  analyticsReport: analyticsModel,
                                ),
                            },
                      ),
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

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.icon, required this.message, this.onRetry});
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
    decoration: BoxDecoration(
      color: navyBlueLight,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.white.withValues(alpha: .07)),
    ),
    child: Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF79B8FF).withValues(alpha: .12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: const Color(0xFF79B8FF), size: 28),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFD5E2EF),
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ],
    ),
  );
}
