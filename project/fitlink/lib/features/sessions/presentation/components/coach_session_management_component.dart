import 'package:fitlink/features/sessions/data/models/session_models.dart';
import 'package:fitlink/features/sessions/presentation/cubit/session_cubit.dart';
import 'package:fitlink/features/sessions/presentation/cubit/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachSessionManagementComponent extends StatelessWidget {
  const CoachSessionManagementComponent({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<SessionCubit, SessionState>(
    builder: (context, state) {
      if (state is SessionLoading || state is SessionInitial) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is SessionLoadFailure) {
        return _LoadError(message: state.message);
      }
      final loaded = state as SessionLoaded;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CoachSessionsHero(
            isBusy: loaded.actionInProgress,
            canCreate: loaded.players.isNotEmpty,
            onRefresh: context.read<SessionCubit>().load,
            onCreate: () => _openComposer(context, loaded),
          ),
          if (loaded.actionInProgress) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(minHeight: 2, borderRadius: BorderRadius.all(Radius.circular(4))),
          ],
          if (loaded.actionError != null) ...[
            const SizedBox(height: 12),
            _SessionActionError(
              message: loaded.actionError!,
              onRetry: context.read<SessionCubit>().load,
            ),
          ],
          const SizedBox(height: 18),
          _SessionOverview(
            total: loaded.sessions.length,
            published: loaded.sessions.where((s) => s.status == 'PUBLISHED').length,
            roster: loaded.players.length,
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your sessions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${loaded.sessions.length} total',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: loaded.sessions.isEmpty
                ? _EmptySessions(
                    canCreate: loaded.players.isNotEmpty,
                    onCreate: () => _openComposer(context, loaded),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: loaded.sessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) => _SessionCard(
                      session: loaded.sessions[index],
                      busy: loaded.actionInProgress,
                      onPublish: () => context
                          .read<SessionCubit>()
                          .publishSession(loaded.sessions[index].sessionId),
                      onCancel: () => context
                          .read<SessionCubit>()
                          .cancelSession(loaded.sessions[index].sessionId),
                    ),
                  ),
          ),
        ],
      );
    },
  );

  Future<void> _openComposer(BuildContext context, SessionLoaded loaded) async {
    final cubit = context.read<SessionCubit>();
    await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _SessionComposerDialog(
          players: loaded.players,
          workouts: loaded.workouts,
          exercises: loaded.exercises,
        ),
      ),
    );
  }
}

class _CoachSessionsHero extends StatelessWidget {
  const _CoachSessionsHero({
    required this.isBusy,
    required this.canCreate,
    required this.onRefresh,
    required this.onCreate,
  });

  final bool isBusy;
  final bool canCreate;
  final VoidCallback onRefresh;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF194A78), Color(0xFF102846), Color(0xFF10233D)],
      ),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFF6CA7E8).withValues(alpha: .25)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF071322).withValues(alpha: .28),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.event_available_rounded,
                color: Color(0xFF9ED2FF),
                size: 24,
              ),
            ),
            const SizedBox(width: 13),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COACH WORKSPACE',
                    style: TextStyle(
                      color: Color(0xFF9ED2FF),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Plan the work. Build momentum.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        const Text(
          'Create focused training plans, bring your roster together, and keep every workout moving.',
          style: TextStyle(color: Color(0xFFD0E0F2), height: 1.45, fontSize: 13),
        ),
        const SizedBox(height: 17),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: isBusy || !canCreate ? null : onCreate,
              icon: const Icon(Icons.add_rounded, size: 19),
              label: const Text('Create session'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF82C5FF),
                foregroundColor: const Color(0xFF08213A),
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: isBusy ? null : onRefresh,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Refresh'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: .25)),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        if (!canCreate) ...[
          const SizedBox(height: 10),
          const Text(
            'Your roster is empty. Open Players in the sidebar to search and add registered players.',
            style: TextStyle(color: Color(0xFFFFD38C), fontSize: 12),
          ),
        ],
      ],
    ),
  );
}

class _SessionOverview extends StatelessWidget {
  const _SessionOverview({
    required this.total,
    required this.published,
    required this.roster,
  });

  final int total;
  final int published;
  final int roster;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth < 560 ? 2 : 3;
      final gap = 10.0;
      final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          SizedBox(
            width: width,
            child: _OverviewTile(
              label: 'All sessions',
              value: '$total',
              icon: Icons.calendar_month_rounded,
              tint: const Color(0xFF8BC5FF),
            ),
          ),
          SizedBox(
            width: width,
            child: _OverviewTile(
              label: 'Published',
              value: '$published',
              icon: Icons.rocket_launch_rounded,
              tint: const Color(0xFF5FE0B2),
            ),
          ),
          SizedBox(
            width: width,
            child: _OverviewTile(
              label: 'Players in roster',
              value: '$roster',
              icon: Icons.groups_rounded,
              tint: const Color(0xFFFFC66E),
            ),
          ),
        ],
      );
    },
  );
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
      color: const Color(0xFF102A49),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: .07)),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: tint.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: tint),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SessionActionError extends StatelessWidget {
  const _SessionActionError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 11, 8, 11),
    decoration: BoxDecoration(
      color: const Color(0xFF5A2833).withValues(alpha: .55),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFFF8C8C).withValues(alpha: .3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Color(0xFFFFA0A0)),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: const TextStyle(fontSize: 13))),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: const Color(0xFF102A49),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFFF9B9B).withValues(alpha: .2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9B9B).withValues(alpha: .1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_rounded, size: 29, color: Color(0xFFFFA0A0)),
            ),
            const SizedBox(height: 16),
            const Text(
              'We couldn’t load your sessions',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, height: 1.45)),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: context.read<SessionCubit>().load,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _EmptySessions extends StatelessWidget {
  const _EmptySessions({required this.onCreate, required this.canCreate});
  final VoidCallback onCreate;
  final bool canCreate;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF102A49),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: .08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFF8BC5FF).withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_note_rounded,
                size: 36,
                color: Color(0xFF8BC5FF),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Your next great session starts here',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              canCreate
                  ? 'Build a focused plan, choose the players who need it, and line up their workouts in order.'
                  : 'Your player roster is empty. Ask an administrator to assign players before creating a session.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, height: 1.5),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: canCreate ? onCreate : null,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create your first session'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    required this.busy,
    required this.onPublish,
    required this.onCancel,
  });

  final TrainingSessionModel session;
  final bool busy;
  final VoidCallback onPublish;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (session.status) {
      'PUBLISHED' => const Color(0xFF52D6A2),
      'COMPLETED' => const Color(0xFF8BC5FF),
      'CANCELLED' => const Color(0xFFFF8C8C),
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
                width: 44,
                height: 44,
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
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
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
              _SessionStatusBadge(status: session.status, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SessionMetaPill(
                icon: Icons.groups_rounded,
                label: '${session.playerIds.length} players',
              ),
              _SessionMetaPill(
                icon: Icons.fitness_center_rounded,
                label: '${session.workouts.length} workouts',
              ),
              if (session.scheduledAt != null)
                _SessionMetaPill(
                  icon: Icons.calendar_month_rounded,
                  label: _formatDate(session.scheduledAt!),
                ),
            ],
          ),
          if (session.workouts.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.route_rounded, size: 17, color: Color(0xFF8BC5FF)),
                const SizedBox(width: 7),
                const Text(
                  'WORKOUT FLOW',
                  style: TextStyle(
                    color: Color(0xFF9DB6D5),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: session.workouts
                  .map((workout) => _WorkoutTag(
                    order: workout.order,
                    label: '${workout.name} · ${workout.exerciseType}',
                  ))
                  .toList(),
            ),
          ],
          if (session.status == 'DRAFT' || session.status == 'PUBLISHED') ...[
            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.white.withValues(alpha: .09)),
            const SizedBox(height: 11),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 6,
              children: [
                TextButton.icon(
                  onPressed: busy ? null : onCancel,
                  icon: const Icon(Icons.close_rounded, size: 17),
                  label: const Text('Cancel'),
                ),
                if (session.status == 'DRAFT')
                  FilledButton.icon(
                    onPressed: busy || session.playerIds.isEmpty || session.workouts.isEmpty
                        ? null
                        : onPublish,
                    icon: const Icon(Icons.rocket_launch_rounded, size: 17),
                    label: const Text('Publish session'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(DateTime value) {
    final date = value.toLocal();
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _SessionStatusBadge extends StatelessWidget {
  const _SessionStatusBadge({required this.status, required this.color});
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: color.withValues(alpha: .28)),
    ),
    child: Text(
      status.toLowerCase(),
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800),
    ),
  );
}

class _SessionMetaPill extends StatelessWidget {
  const _SessionMetaPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .045),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF8BC5FF)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    ),
  );
}

class _WorkoutTag extends StatelessWidget {
  const _WorkoutTag({required this.order, required this.label});
  final int order;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 260),
    padding: const EdgeInsets.fromLTRB(7, 6, 10, 6),
    decoration: BoxDecoration(
      color: const Color(0xFF8BC5FF).withValues(alpha: .08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFF8BC5FF).withValues(alpha: .15)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: const Color(0xFF8BC5FF).withValues(alpha: .18),
          child: Text('$order', style: const TextStyle(fontSize: 10, color: Color(0xFFB7DDFF))),
        ),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}

class _SessionComposerDialog extends StatefulWidget {
  const _SessionComposerDialog({
    required this.players,
    required this.workouts,
    required this.exercises,
  });
  final List<SessionPlayerModel> players;
  final List<WorkoutTemplateModel> workouts;
  final List<ExerciseCatalogModel> exercises;

  @override
  State<_SessionComposerDialog> createState() => _SessionComposerDialogState();
}

class _SessionComposerDialogState extends State<_SessionComposerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final Set<String> _selectedPlayers = {};
  final List<WorkoutTemplateModel> _availableWorkouts = [];
  final List<String> _selectedWorkouts = [];
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _availableWorkouts.addAll(widget.workouts);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    title: const Row(
      children: [
        Icon(Icons.event_available_rounded, color: Color(0xFF8BC5FF)),
        SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create a session', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
              SizedBox(height: 3),
              Text('Set up players and workout order', style: TextStyle(fontSize: 12, color: Colors.white60)),
            ],
          ),
        ),
      ],
    ),
    content: SizedBox(
      width: MediaQuery.sizeOf(context).width < 720
          ? MediaQuery.sizeOf(context).width - 72
          : 620,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                maxLength: 120,
                decoration: const InputDecoration(
                  labelText: 'Session name',
                  prefixIcon: Icon(Icons.event_note_outlined),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Enter a session name'
                    : null,
              ),
              TextFormField(
                controller: _description,
                maxLines: 2,
                maxLength: 2000,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 12),
              _SectionTitle(
                title: 'Assign players',
                trailing: Text(
                  '${_selectedPlayers.length} player${_selectedPlayers.length == 1 ? '' : 's'} selected',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
              const SizedBox(height: 6),
              if (widget.players.isEmpty)
                const Text(
                  'No players are on your roster yet. Add registered players from the Players section first.',
                  style: TextStyle(color: Colors.white60),
                )
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 190),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.players.length,
                    itemBuilder: (context, index) {
                      final player = widget.players[index];
                      return CheckboxListTile(
                        dense: true,
                        value: _selectedPlayers.contains(player.playerId),
                        title: Text(
                          player.username?.isNotEmpty == true
                              ? player.username!
                              : player.playerId,
                        ),
                        subtitle: Text(
                          '${player.playerId}${player.sport == null ? '' : ' · ${player.sport}'}',
                        ),
                        onChanged: (selected) => setState(() {
                          if (selected == true) {
                            _selectedPlayers.add(player.playerId);
                          } else {
                            _selectedPlayers.remove(player.playerId);
                          }
                        }),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 18),
              _SectionTitle(
                title: 'Ordered workout plan',
                trailing: TextButton.icon(
                  onPressed: _saving || widget.exercises.isEmpty
                      ? null
                      : _createWorkout,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('New workout'),
                ),
              ),
              if (_availableWorkouts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Create a workout template before publishing this session.',
                    style: TextStyle(color: Colors.white60),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableWorkouts.map((workout) {
                    final selected = _selectedWorkouts.contains(
                      workout.workoutId,
                    );
                    return FilterChip(
                      selected: selected,
                      avatar: selected
                          ? const Icon(Icons.check_circle, size: 18)
                          : const Icon(Icons.fitness_center, size: 18),
                      label: Text('${workout.name} · ${workout.exerciseType}'),
                      onSelected: (value) => setState(() {
                        if (value) {
                          if (!_selectedWorkouts.contains(workout.workoutId)) {
                            _selectedWorkouts.add(workout.workoutId);
                          }
                        } else {
                          _selectedWorkouts.remove(workout.workoutId);
                        }
                      }),
                    );
                  }).toList(),
                ),
              if (_selectedWorkouts.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  _selectedWorkouts
                      .asMap()
                      .entries
                      .map((entry) {
                        final workout = _availableWorkouts.firstWhere(
                          (item) => item.workoutId == entry.value,
                        );
                        return '${entry.key + 1}. ${workout.name}';
                      })
                      .join('  →  '),
                  style: const TextStyle(
                    color: Color(0xFF8BC5FF),
                    fontSize: 12,
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Color(0xFFFF8C8C))),
              ],
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: const Text('Close'),
      ),
      FilledButton.icon(
        onPressed: _saving || widget.players.isEmpty ? null : _submit,
        icon: _saving
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.publish_rounded),
        label: Text(_saving ? 'Publishing…' : 'Create and publish'),
      ),
    ],
  );

  Future<void> _createWorkout() async {
    final cubit = context.read<SessionCubit>();
    final workout = await showDialog<WorkoutTemplateModel>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _WorkoutTemplateDialog(exercises: widget.exercises),
      ),
    );
    if (workout != null && mounted) {
      setState(() {
        _availableWorkouts.insert(0, workout);
        _selectedWorkouts.add(workout.workoutId);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPlayers.isEmpty || _selectedWorkouts.isEmpty) {
      setState(() => _error = 'Select at least one player and one workout.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final ok = await context.read<SessionCubit>().createAndPublishSession(
      name: _name.text,
      description: _description.text,
      playerIds: _selectedPlayers.toList(),
      workoutIds: List.of(_selectedWorkouts),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
    } else {
      final state = context.read<SessionCubit>().state;
      setState(() {
        _saving = false;
        _error = state is SessionLoaded
            ? state.actionError
            : 'Could not publish the session.';
      });
    }
  }
}

class _WorkoutTemplateDialog extends StatefulWidget {
  const _WorkoutTemplateDialog({required this.exercises});
  final List<ExerciseCatalogModel> exercises;

  @override
  State<_WorkoutTemplateDialog> createState() => _WorkoutTemplateDialogState();
}

class _WorkoutTemplateDialogState extends State<_WorkoutTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _sets = TextEditingController();
  final _reps = TextEditingController();
  final _duration = TextEditingController();
  ExerciseCatalogModel? _exercise;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _sets.dispose();
    _reps.dispose();
    _duration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    title: const Row(
      children: [
        Icon(Icons.fitness_center_rounded, color: Color(0xFF8BC5FF)),
        SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New workout', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
              SizedBox(height: 3),
              Text('Add an exercise to the session plan', style: TextStyle(fontSize: 12, color: Colors.white60)),
            ],
          ),
        ),
      ],
    ),
    content: SizedBox(
      width: MediaQuery.sizeOf(context).width < 580
          ? MediaQuery.sizeOf(context).width - 72
          : 480,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                maxLength: 120,
                decoration: const InputDecoration(labelText: 'Workout name'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a workout name'
                    : null,
              ),
              DropdownButtonFormField<ExerciseCatalogModel>(
                value: _exercise,
                decoration: const InputDecoration(
                  labelText: 'Approved exercise',
                ),
                items: widget.exercises
                    .map(
                      (exercise) => DropdownMenuItem(
                        value: exercise,
                        child: Text('${exercise.name} · ${exercise.id}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _exercise = value),
                validator: (value) =>
                    value == null ? 'Choose an exercise' : null,
              ),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sets,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Sets'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _reps,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Reps'),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _duration,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (seconds, optional)',
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Color(0xFFFF8C8C)),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: const Text('Close'),
      ),
      FilledButton(
        onPressed: _saving ? null : _save,
        child: _saving
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Save workout'),
      ),
    ],
  );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final workout = await context.read<SessionCubit>().createWorkout(
      name: _name.text,
      exerciseTypeId: _exercise!.id,
      description: _description.text,
      sets: int.tryParse(_sets.text),
      reps: int.tryParse(_reps.text),
      durationSeconds: int.tryParse(_duration.text),
    );
    if (!mounted) return;
    if (workout != null) {
      Navigator.pop(context, workout);
    } else {
      final state = context.read<SessionCubit>().state;
      setState(() {
        _saving = false;
        _error = state is SessionLoaded
            ? state.actionError
            : 'Could not save workout.';
      });
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.trailing});
  final String title;
  final Widget trailing;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      trailing,
    ],
  );
}
