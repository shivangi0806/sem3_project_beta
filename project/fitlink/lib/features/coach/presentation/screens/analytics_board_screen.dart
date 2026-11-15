
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:fitlink/features/coach/cubit/coach_roster_cubit.dart';
import 'package:fitlink/features/coach/data/services/coach_roster_service.dart';
import 'package:fitlink/features/coach/analytics/widgets/period_selector.dart';
import 'package:fitlink/features/coach/analytics/widgets/player_selector.dart';
import 'package:fitlink/features/coach/analytics/widgets/performance_overview.dart';
import 'package:fitlink/features/coach/analytics/widgets/analytics_dashboard_grid.dart';
import 'package:fitlink/features/coach/analytics/services/analytics_service.dart';
class AnalyticsBoardScreen extends StatelessWidget {
  const AnalyticsBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserProvider>();

    if (!session.isAuthenticated ||
        session.user?.roleId != 'ROLE_COACH') {
      return const Center(
        child: Text('Sign in with a coach account to view analytics.'),
      );
    }

    return BlocProvider(
      key: ValueKey('analytics-roster:${session.userToken}'),
      create: (_) => CoachRosterCubit(
        CoachRosterService(token: session.userToken),
      )..load(),
      child:  AnalyticsBoardContent( token: session.userToken,),
    );
  }
}

class AnalyticsBoardContent extends StatefulWidget {
  //const AnalyticsBoardContent({super.key});
  final String token;

  const AnalyticsBoardContent({
    super.key,
    required this.token,
  });

  @override
  State<AnalyticsBoardContent> createState() =>
      _AnalyticsBoardContentState();
}

class _AnalyticsBoardContentState
    extends State<AnalyticsBoardContent> {

  String selectedPeriod = 'This Week';
  String? selectedPlayerId;
  String get apiPeriod {
  switch (selectedPeriod) {
    case 'Today':
      return 'daily';

    case 'This Week':
      return 'weekly';

    case 'This Month':
      return 'monthly';

    case 'Custom Range':
      return 'custom';

    default:
      return 'weekly';
  }
}
late final AnalyticsService _analyticsService;

@override
void initState() {
  super.initState();

  _analyticsService = AnalyticsService(
    token: widget.token,
  );
}
Map<String, dynamic>? analyticsReport;
bool isLoading = false;
@override
void dispose() {
  _analyticsService.dispose();
  super.dispose();
}
Future<void> fetchAnalytics() async {
  if (selectedPlayerId == null) return;

  setState(() {
    isLoading = true;
  });

  try {
    final response = await _analyticsService.getPlayerReport(
      playerId: selectedPlayerId!,
      period: apiPeriod,
    );
debugPrint('SELECTED PLAYER: $selectedPlayerId');
debugPrint('SELECTED PERIOD: $apiPeriod');
debugPrint('ANALYTICS API RESPONSE: $response');
    if (!mounted) return;

    setState(() {
      analyticsReport = response['data'];
      isLoading = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
      analyticsReport = null;
    });

    debugPrint('Analytics error: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyBlueLight,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<CoachRosterCubit, CoachRosterState>(
          builder: (context, state) {
            return ListView(
  padding: EdgeInsets.zero,
  children: [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PlayerSelector(
            players: state.roster,
            selectedPlayerId: selectedPlayerId,
            onChanged: (value) {
              setState(() {
                selectedPlayerId = value;
              });
              fetchAnalytics();
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 190,
          child: PeriodSelector(
            selectedPeriod: selectedPeriod,
            onChanged: (value) {
              setState(() {
                selectedPeriod = value;
              });
              fetchAnalytics();
            },
          ),
        ),
      ],
    ),
    const SizedBox(height: 20),
    // const PerformanceOverview(
    //   totalSteps: '--',
    //   distance: '--',
    //   calories: '--',
    //   duration: '--',
    // ),
     AnalyticsDashboardGrid(analyticsReport: analyticsReport,),
  ],
);
          },
        ),
      ),
    );
  }
}
