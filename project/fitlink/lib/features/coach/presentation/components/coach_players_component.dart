import 'dart:async';

import 'package:fitlink/features/coach/cubit/coach_roster_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoachPlayersComponent extends StatefulWidget {
  const CoachPlayersComponent({super.key});

  @override
  State<CoachPlayersComponent> createState() => _CoachPlayersComponentState();
}

class _CoachPlayersComponentState extends State<CoachPlayersComponent> {
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<CoachRosterCubit, CoachRosterState>(
    builder: (context, state) {
      final cubit = context.read<CoachRosterCubit>();
      return LayoutBuilder(builder: (context, constraints) {
        final compact = constraints.maxWidth < 680;
        return SingleChildScrollView(
          padding: EdgeInsets.all(compact ? 2 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RosterHeader(count: state.roster.length, compact: compact, onRefresh: cubit.load),
              const SizedBox(height: 18),
              _SearchPanel(
                controller: _search,
                searching: state.searching,
                matches: state.matches,
                workingPlayerId: state.workingPlayerId,
                onChanged: (value) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 350), () => cubit.search(value));
                },
                onAdd: cubit.add,
              ),
              if (state.error != null) ...[
                const SizedBox(height: 12),
                _MessageBanner(message: state.error!, isError: true),
              ],
              if (state.notice != null) ...[
                const SizedBox(height: 12),
                _MessageBanner(message: state.notice!, isError: false),
              ],
              const SizedBox(height: 24),
              Row(children: [
                const Expanded(child: Text('Your roster', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700))),
                Text('${state.roster.length} players', style: const TextStyle(color: Color(0xFF9DB6D5), fontSize: 13)),
              ]),
              const SizedBox(height: 12),
              if (state.loading)
                const Center(child: Padding(padding: EdgeInsets.all(34), child: CircularProgressIndicator()))
              else if (state.roster.isEmpty)
                const _EmptyRoster()
              else
                LayoutBuilder(builder: (context, rosterConstraints) {
                  final columns = rosterConstraints.maxWidth >= 960 ? 3 : rosterConstraints.maxWidth >= 600 ? 2 : 1;
                  final gap = 12.0;
                  final cardWidth = (rosterConstraints.maxWidth - gap * (columns - 1)) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: state.roster.map((player) => SizedBox(
                      width: cardWidth,
                      child: _RosterPlayerCard(
                        player: player,
                        isWorking: state.workingPlayerId == player.playerId,
                        onRemove: () => _confirmRemove(context, player, cubit),
                      ),
                    )).toList(),
                  );
                }),
            ],
          ),
        );
      });
    },
  );

  Future<void> _confirmRemove(BuildContext context, CoachRosterPlayer player, CoachRosterCubit cubit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove player?'),
        content: Text('${player.username} will no longer be available when creating new sessions. Existing session history is kept.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Keep player')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirmed == true && mounted) await cubit.remove(player.playerId);
  }
}

class _RosterHeader extends StatelessWidget {
  const _RosterHeader({required this.count, required this.compact, required this.onRefresh});
  final int count;
  final bool compact;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(compact ? 18 : 24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF194A78), Color(0xFF10233D)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFF6CA7E8).withValues(alpha: .25)),
    ),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('PLAYER ROSTER', style: TextStyle(color: Color(0xFF9ED2FF), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
            const SizedBox(height: 7),
            Text('Build your team, one player at a time.', style: TextStyle(color: Colors.white, fontSize: compact ? 20 : 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 7),
            const Text('Search registered players by name. Added players will appear in your session planner.', style: TextStyle(color: Color(0xFFD0E0F2), height: 1.45, fontSize: 13)),
          ]),
        ),
        FilledButton.tonalIcon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: Text('$count on roster'),
          style: FilledButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.white.withValues(alpha: .12)),
        ),
      ],
    ),
  );
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({required this.controller, required this.searching, required this.matches, required this.workingPlayerId, required this.onChanged, required this.onAdd});
  final TextEditingController controller;
  final bool searching;
  final List<CoachRosterPlayer> matches;
  final String? workingPlayerId;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onAdd;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: const Color(0xFF102846), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: .08))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Find players', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
      const SizedBox(height: 5),
      const Text('Search by player name. Only registered player accounts are shown.', style: TextStyle(color: Color(0xFF9DB6D5), fontSize: 12)),
      const SizedBox(height: 13),
      TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Type a player name…',
          hintStyle: const TextStyle(color: Color(0xFF8299B4)),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF8BC5FF)),
          suffixIcon: searching ? const Padding(padding: EdgeInsets.all(13), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))) : controller.text.isEmpty ? null : IconButton(onPressed: () { controller.clear(); onChanged(''); }, icon: const Icon(Icons.close_rounded, color: Color(0xFF9DB6D5))),
          filled: true,
          fillColor: const Color(0xFF0B1D34),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: BorderSide.none),
        ),
      ),
      if (controller.text.trim().length < 2 && matches.isEmpty) ...[
        const SizedBox(height: 10),
        const Text('Enter at least 2 characters to search.', style: TextStyle(color: Color(0xFF8299B4), fontSize: 12)),
      ] else if (!searching && matches.isEmpty && controller.text.trim().length >= 2) ...[
        const SizedBox(height: 10),
        const Text('No available player accounts match that name.', style: TextStyle(color: Color(0xFF9DB6D5), fontSize: 12)),
      ],
      if (matches.isNotEmpty) ...[
        const SizedBox(height: 10),
        for (final player in matches)
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .045), borderRadius: BorderRadius.circular(13)),
              child: Row(children: [
                _Avatar(name: player.username),
                const SizedBox(width: 11),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(player.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('${player.email}  ·  ${player.sport}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF9DB6D5), fontSize: 11)),
                ])),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: workingPlayerId != null ? null : () => onAdd(player.userId),
                  icon: workingPlayerId == player.userId ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.person_add_alt_1_rounded, size: 17),
                  label: Text('Add'),
                ),
              ]),
            ),
          ),
      ],
    ]),
  );
}

class _RosterPlayerCard extends StatelessWidget {
  const _RosterPlayerCard({required this.player, required this.isWorking, required this.onRemove});
  final CoachRosterPlayer player;
  final bool isWorking;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: const Color(0xFF102846), borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.white.withValues(alpha: .07))),
    child: Row(children: [
      _Avatar(name: player.username, size: 43),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(player.username, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text(player.email.isEmpty ? player.playerId : player.email, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF9DB6D5), fontSize: 11)),
        const SizedBox(height: 6),
        Text('${player.sport.toUpperCase()}  ·  ${player.playerId}', style: const TextStyle(color: Color(0xFF8BC5FF), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .4)),
      ])),
      IconButton(
        tooltip: 'Remove from roster',
        onPressed: isWorking ? null : onRemove,
        icon: isWorking ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.person_remove_alt_1_rounded, color: Color(0xFFFFB4A9)),
      ),
    ]),
  );
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.size = 38});
  final String name;
  final double size;
  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: size / 2,
    backgroundColor: const Color(0xFF1E497A),
    child: Text(name.trim().isEmpty ? 'P' : name.trim()[0].toUpperCase(), style: const TextStyle(color: Color(0xFFBCE0FF), fontWeight: FontWeight.w800)),
  );
}

class _EmptyRoster extends StatelessWidget {
  const _EmptyRoster();
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(color: const Color(0xFF102846), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: .07))),
    child: const Column(children: [
      Icon(Icons.groups_2_outlined, size: 38, color: Color(0xFF8BC5FF)),
      SizedBox(height: 10),
      Text('Your roster is ready for its first player', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      SizedBox(height: 5),
      Text('Search for an existing player above, then add them to start planning sessions.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF9DB6D5), fontSize: 12, height: 1.4)),
    ]),
  );
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner({required this.message, required this.isError});
  final String message;
  final bool isError;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: (isError ? const Color(0xFF8E342F) : const Color(0xFF206244)).withValues(alpha: .45), borderRadius: BorderRadius.circular(12)),
    child: Row(children: [
      Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded, color: isError ? const Color(0xFFFFB4A9) : const Color(0xFF9AE6B4), size: 18),
      const SizedBox(width: 8),
      Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 12))),
    ]),
  );
}
