import 'package:fitlink/features/sessions/data/models/session_models.dart';
import 'package:fitlink/features/sessions/presentation/cubit/session_cubit.dart';
import 'package:fitlink/features/sessions/presentation/cubit/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerSessionListComponent extends StatelessWidget {
  const PlayerSessionListComponent({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<SessionCubit, SessionState>(
    builder: (context, state) {
      if (state is SessionLoading || state is SessionInitial) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is SessionLoadFailure) {
        return _PlayerMessage(
          message: state.message,
          actionLabel: 'Try again',
          onAction: () => context.read<SessionCubit>().load(playerMode: true),
        );
      }
      final loaded = state as SessionLoaded;
      final joinedCount = loaded.sessions
          .where((session) => session.participationStatus == 'JOINED')
          .length;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PlayerSessionsHero(
            total: loaded.sessions.length,
            joined: joinedCount,
            busy: loaded.actionInProgress,
            onRefresh: () => context.read<SessionCubit>().load(playerMode: true),
          ),
          if (loaded.actionInProgress) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(minHeight: 2),
          ],
          if (loaded.actionError != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFF5A2833).withValues(alpha: .55),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFFF8C8C).withValues(alpha: .25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: Color(0xFFFFA0A0), size: 20),
                  const SizedBox(width: 9),
                  Expanded(child: Text(loaded.actionError!, style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Your training plan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: loaded.sessions.isEmpty
                ? const _PlayerMessage(message: 'No sessions have been assigned to you yet.')
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: loaded.sessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) => _PlayerSessionCard(
                      session: loaded.sessions[index],
                      busy: loaded.actionInProgress,
                      executions: loaded.executions,
                    ),
                  ),
          ),
        ],
      );
    },
  );
}

class _PlayerSessionsHero extends StatelessWidget {
  const _PlayerSessionsHero({
    required this.total,
    required this.joined,
    required this.busy,
    required this.onRefresh,
  });

  final int total;
  final int joined;
  final bool busy;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF194A78), Color(0xFF102846), Color(0xFF10233D)],
      ),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFF6CA7E8).withValues(alpha: .23)),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.sports_gymnastics_rounded, color: Color(0xFF9ED2FF)),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YOUR TRAINING',
                style: TextStyle(
                  color: Color(0xFF9ED2FF),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Show up. Get stronger.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(
                '$joined joined  ·  $total assigned',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: 'Refresh sessions',
          onPressed: busy ? null : onRefresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    ),
  );
}

class _PlayerSessionCard extends StatelessWidget {
  const _PlayerSessionCard({required this.session, required this.busy, required this.executions});
  final TrainingSessionModel session;
  final bool busy;
  final Map<String, WorkoutExecutionModel> executions;

  @override
  Widget build(BuildContext context) {
    final participation = session.participationStatus ?? 'INVITED';
    final statusColor = switch (participation) {
      'JOINED' => const Color(0xFF5FE0B2),
      'DECLINED' => const Color(0xFFFF9B9B),
      _ => const Color(0xFFFFC66E),
    };
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF122F50), Color(0xFF0E2540)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC5FF).withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.bolt_rounded, color: Color(0xFF8BC5FF)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    if (session.description?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 5),
                      Text(
                        session.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white60, height: 1.35),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ParticipationBadge(label: participation, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.route_rounded, size: 17, color: Color(0xFF8BC5FF)),
              const SizedBox(width: 7),
              const Text(
                'YOUR WORKOUT FLOW',
                style: TextStyle(
                  color: Color(0xFF9DB6D5),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              Text(
                '${session.workouts.length} steps',
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 9),
          if (session.workouts.isEmpty)
            const Text('No workouts have been added to this plan yet.', style: TextStyle(color: Colors.white54))
          else
            ...session.workouts.map((workout) {
              final execution = executions['${session.sessionId}:${workout.workoutId}'];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.fromLTRB(10, 10, 8, 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .035),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: .055)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: const Color(0xFF8BC5FF).withValues(alpha: .14),
                          child: Text('${workout.order}', style: const TextStyle(fontSize: 11, color: Color(0xFFB7DDFF))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            workout.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (workout.sets != null || workout.reps != null)
                          _WorkoutDetail('${workout.sets ?? '–'} × ${workout.reps ?? '–'}'),
                        if (workout.durationSeconds != null)
                          _WorkoutDetail('${workout.durationSeconds}s'),
                      ],
                    ),
                    if (participation == 'JOINED')
                      Align(
                        alignment: Alignment.centerRight,
                        child: _ExecutionAction(
                          status: execution?.status,
                          busy: busy,
                          onStart: () => context.read<SessionCubit>().startWorkout(session.sessionId, workout.workoutId),
                          onPause: () => context.read<SessionCubit>().updateExecution(session.sessionId, workout.workoutId, 'pause'),
                          onResume: () => context.read<SessionCubit>().updateExecution(session.sessionId, workout.workoutId, 'resume'),
                          onComplete: () => context.read<SessionCubit>().updateExecution(session.sessionId, workout.workoutId, 'complete'),
                        ),
                      ),
                  ],
                ),
              );
            }),
          if (participation == 'INVITED') ...[
            const SizedBox(height: 6),
            Divider(height: 1, color: Colors.white.withValues(alpha: .09)),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 6,
              children: [
                TextButton(
                  onPressed: busy ? null : () => context.read<SessionCubit>().joinSession(session.sessionId, decline: true),
                  child: const Text('Decline'),
                ),
                FilledButton.icon(
                  onPressed: busy ? null : () => context.read<SessionCubit>().joinSession(session.sessionId),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Join session'),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 9),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .035),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sync_rounded, size: 16, color: Color(0xFF8BC5FF)),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Plan sync · ${(session.syncStatus ?? 'NOT_SYNCED').toLowerCase().replaceAll('_', ' ')}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                  const Icon(Icons.watch_outlined, size: 15, color: Colors.white38),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ParticipationBadge extends StatelessWidget {
  const _ParticipationBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: color.withValues(alpha: .24)),
    ),
    child: Text(label.toLowerCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
  );
}

class _WorkoutDetail extends StatelessWidget {
  const _WorkoutDetail(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 6),
    child: Text(text, style: const TextStyle(color: Colors.white60, fontSize: 11)),
  );
}

class _ExecutionAction extends StatelessWidget {
  const _ExecutionAction({
    required this.status,
    required this.busy,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
  });

  final String? status;
  final bool busy;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    if (status == 'COMPLETED') {
      return const Text('Done', style: TextStyle(color: Color(0xFF52D6A2), fontSize: 12));
    }
    if (status == 'SKIPPED') {
      return const Text('Skipped', style: TextStyle(color: Colors.white54, fontSize: 12));
    }
    final action = status == 'IN_PROGRESS'
        ? onPause
        : status == 'PAUSED'
        ? onResume
        : onStart;
    final label = status == 'IN_PROGRESS'
        ? 'Pause'
        : status == 'PAUSED'
        ? 'Resume'
        : 'Start';
    return Wrap(
      spacing: 4,
      children: [
        TextButton(onPressed: busy ? null : action, child: Text(label)),
        if (status == 'IN_PROGRESS' || status == 'PAUSED')
          IconButton(
            tooltip: 'Complete workout',
            onPressed: busy ? null : onComplete,
            icon: const Icon(Icons.check_circle_outline_rounded, size: 19),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }
}

class _PlayerMessage extends StatelessWidget {
  const _PlayerMessage({required this.message, this.actionLabel, this.onAction});
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF102A49),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: .07)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFF8BC5FF).withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                actionLabel == null ? Icons.event_available_outlined : Icons.cloud_off_rounded,
                size: 29,
                color: const Color(0xFF8BC5FF),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              actionLabel == null ? 'You’re all caught up' : 'Sessions are unavailable',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, height: 1.45),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
