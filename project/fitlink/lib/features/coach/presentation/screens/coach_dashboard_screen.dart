import 'package:fitlink/features/coach/cubit/coach_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitlink/core/services/coach_service.dart';
import 'package:fitlink/features/coach/data/model/coach_dashboard_model.dart';

class CoachDashboardPage extends StatefulWidget {
  final String token;

  const CoachDashboardPage({super.key, required this.token});

  @override
  State<CoachDashboardPage> createState() => _CoachDashboardPageState();
}

class _CoachDashboardPageState extends State<CoachDashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDashboard();
      }
    });
  }

  void _loadDashboard() {
    context.read<CoachCubitCubit>().getDashboardData(token: widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: SafeArea(
        child: BlocConsumer<CoachCubitCubit, CoachCubitState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is CoachLoading || state is CoachCubitInitial) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
              );
            }

            if (state is CoachError) {
              return _buildError(state.message);
            }

            if (state is CoachDashboardSuccessState) {
              return _buildDashboard(state.data);
            }

            return _buildError('Unable to display dashboard data.');
          },
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.redAccent,
              size: 55,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadDashboard,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(CoachDashboardModel data) {
    return RefreshIndicator(
      color: const Color(0xFF3B82F6),
      backgroundColor: const Color(0xFF172033),
      onRefresh: () async {
        await context.read<CoachCubitCubit>().getDashboardData(
          token: widget.token,
        );
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(data.coach),
                const SizedBox(height: 28),

                _sectionTitle('Team Overview', 'Your team at a glance'),
                const SizedBox(height: 16),

                _buildMembersSection(data.members),

                const SizedBox(height: 28),

                _sectionTitle(
                  'Training Overview',
                  'Training and session statistics',
                ),
                const SizedBox(height: 16),

                _buildTrainingSection(data.training),

                const SizedBox(height: 28),

                _sectionTitle(
                  'Player Performance',
                  'Team performance indicators',
                ),
                const SizedBox(height: 16),

                _buildPerformanceSection(data.performance),

                const SizedBox(height: 28),

                _sectionTitle(
                  'Wearable Analytics',
                  'Connected devices and activity',
                ),
                const SizedBox(height: 16),

                _buildWearableSection(data.wearable),

                const SizedBox(height: 28),

                _buildAttentionSection(data.attention),

                const SizedBox(height: 30),

                Center(
                  child: Text(
                    'FITLINK • COACH DASHBOARD',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // HEADER

  Widget _buildHeader(CoachProfileModel coach) {
    final username = coach.username.isEmpty ? 'Coach' : coach.username;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WELCOME BACK,',
                style: TextStyle(
                  color: Color(0xFF60A5FA),
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Here is your team performance today.',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF3B82F6)),
          ),
          child: const Icon(
            Icons.sports_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ],
    );
  }

  // SECTION TITLE

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  // TEAM OVERVIEW

  Widget _buildMembersSection(CoachMembersModel members) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                title: 'Total Players',
                value: '${members.total}',
                icon: Icons.groups_rounded,
                color: const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: 'Active Players',
                value: '${members.active}',
                icon: Icons.check_circle_rounded,
                color: const Color(0xFF22C55E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _statCard(
                title: 'Inactive Players',
                value: '${members.inactive}',
                icon: Icons.person_off_rounded,
                color: const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: 'Activity Rate',
                value: '${members.activityRate}%',
                icon: Icons.trending_up_rounded,
                color: const Color(0xFFA78BFA),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // TRAINING

  Widget _buildTrainingSection(CoachTrainingModel training) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                title: 'Upcoming Sessions',
                value: _display(training.upcomingSessions),
                icon: Icons.event_available_rounded,
                color: const Color(0xFF38BDF8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: 'Completed Sessions',
                value: _display(training.completedSessions),
                icon: Icons.task_alt_rounded,
                color: const Color(0xFF22C55E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _progressCard(
          title: 'Workout Completion',
          value: training.workoutCompletionRate,
          icon: Icons.fitness_center_rounded,
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 12),
        _progressCard(
          title: 'Attendance Rate',
          value: training.attendanceRate,
          icon: Icons.how_to_reg_rounded,
          color: const Color(0xFF22C55E),
        ),
      ],
    );
  }

  // PERFORMANCE

  Widget _buildPerformanceSection(CoachPerformanceModel performance) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                title: 'Players Progressing',
                value: _display(performance.membersShowingProgress),
                icon: Icons.trending_up_rounded,
                color: const Color(0xFF22C55E),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: 'Personal Records',
                value: _display(performance.personalRecords),
                icon: Icons.emoji_events_rounded,
                color: const Color(0xFFFBBF24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _statCard(
          title: 'Average Training Time',
          value: performance.averageTrainingTime == null
              ? '—'
              : '${performance.averageTrainingTime}',
          subtitle: 'As reported by the backend',
          icon: Icons.timer_rounded,
          color: const Color(0xFF38BDF8),
        ),
      ],
    );
  }

  // WEARABLE ANALYTICS

  Widget _buildWearableSection(CoachWearableModel wearable) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                title: 'Connected Devices',
                value: _display(wearable.connectedDevices),
                icon: Icons.watch_rounded,
                color: const Color(0xFF38BDF8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: 'Active Devices',
                value: _display(wearable.activeDevices),
                icon: Icons.bluetooth_connected_rounded,
                color: const Color(0xFF22C55E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _statCard(
                title: 'Average Steps',
                value: wearable.averageSteps == null
                    ? '—'
                    : _formatNumber(wearable.averageSteps!),
                icon: Icons.directions_walk_rounded,
                color: const Color(0xFFA78BFA),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: 'Avg. Heart Rate',
                value: wearable.averageHeartRate == null
                    ? '—'
                    : '${wearable.averageHeartRate!.toStringAsFixed(0)} BPM',
                icon: Icons.favorite_rounded,
                color: const Color(0xFFFB7185),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _progressCard(
          title: 'Wearable Sync Success',
          value: wearable.syncSuccessRate,
          icon: Icons.sync_rounded,
          color: const Color(0xFF38BDF8),
        ),
      ],
    );
  }

  // ATTENTION

  Widget _buildAttentionSection(CoachAttentionModel attention) {
    final count = attention.membersNeedingAttention;

    final hasAttention = count != null && count > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasAttention
              ? const Color(0xFFF59E0B).withOpacity(0.6)
              : const Color(0xFF263449),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: hasAttention
                  ? const Color(0xFFF59E0B).withOpacity(0.15)
                  : const Color(0xFF22C55E).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              hasAttention
                  ? Icons.warning_amber_rounded
                  : Icons.verified_rounded,
              color: hasAttention
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF22C55E),
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Members Needing Attention',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  count == null
                      ? 'Information unavailable'
                      : hasAttention
                      ? 'Some members may need your attention.'
                      : 'No members currently flagged.',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            _display(count),
            style: TextStyle(
              color: hasAttention ? const Color(0xFFF59E0B) : Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // REUSABLE STATISTICS CARD

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 125),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFF263449)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 21),
              const Spacer(),
              Container(
                height: 7,
                width: 7,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ],
      ),
    );
  }

  // REUSABLE PROGRESS CARD

  Widget _progressCard({
    required String title,
    required num? value,
    required IconData icon,
    required Color color,
  }) {
    final percentage = value == null
        ? null
        : value.toDouble().clamp(0.0, 100.0);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFF263449)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 21),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                percentage == null ? '—' : '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage == null ? null : percentage / 100,
              minHeight: 7,
              backgroundColor: const Color(0xFF263449),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  String _display(num? value) {
    return value?.toString() ?? '—';
  }

  String _formatNumber(num value) {
    final number = value.toStringAsFixed(0);
    final buffer = StringBuffer();

    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);

      final remaining = number.length - i - 1;

      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write(',');
      }
    }

    return buffer.toString();
  }
}
