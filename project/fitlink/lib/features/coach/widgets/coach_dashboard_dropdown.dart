import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/coach/cubit/coach_roster_cubit.dart';

class PlayerDropdown extends StatefulWidget {
  final List<CoachRosterPlayer> players;
  final String? selectedPlayerId;
  final ValueChanged<String> onChanged;

  const PlayerDropdown({
    super.key,
    required this.players,
    required this.selectedPlayerId,
    required this.onChanged,
  });

  @override
  State<PlayerDropdown> createState() => _PlayerDropdownState();
}

class _PlayerDropdownState extends State<PlayerDropdown> {
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocus = FocusNode();

  Timer? _debounce;

  bool _isExpanded = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  CoachRosterPlayer? get _selectedPlayer {
    for (final player in widget.players) {
      if (player.playerId == widget.selectedPlayerId) {
        return player;
      }
    }
    return null;
  }

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _searchController.clear();
      context.read<CoachRosterCubit>().search('');
    } else {
      _debounce?.cancel();
      context.read<CoachRosterCubit>().search('');
    }
  }

  void _searchPlayers(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;

      context.read<CoachRosterCubit>().search(value);
    });
  }

  void _selectPlayer(CoachRosterPlayer player) {
    widget.onChanged(player.playerId);

    setState(() {
      _isExpanded = false;
      _searchController.clear();
    });

    context.read<CoachRosterCubit>().search('');
  }

  Widget _avatar(String name, {double radius = 20}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF1E4770),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }

  Widget _buildSelectedPlayer() {
    final player = _selectedPlayer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: navyBlueMid,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _isExpanded
              ? const Color(0xFF5090D3)
              : Colors.white.withValues(alpha: .08),
          width: _isExpanded ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          if (player != null)
            _avatar(player.username)
          else
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF1E4770),
              child: Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF79B8FF),
              ),
            ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player?.username ?? 'Select Athlete',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  player != null
                      ? '${player.sport} · ${player.playerId}'
                      : 'Choose a player to view analytics',
                  style: const TextStyle(
                    color: Color(0xFF9DB7D0),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            _isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
            size: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(bool searching) {
    return TextField(
      controller: _searchController,
      onChanged: _searchPlayers,
      autofocus: false,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Search athlete by name...',
        hintStyle: const TextStyle(color: Color(0xFF8299B4), fontSize: 13),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF79B8FF),
          size: 20,
        ),
        suffixIcon: searching
            ? const Padding(
                padding: EdgeInsets.all(13),
                child: SizedBox(
                  height: 17,
                  width: 17,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  context.read<CoachRosterCubit>().search('');
                  setState(() {});
                },
                icon: const Icon(Icons.close_rounded, color: Color(0xFF9DB6D5)),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF0B1D34),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPlayerItem(CoachRosterPlayer player) {
    final selected = player.playerId == widget.selectedPlayerId;

    return InkWell(
      onTap: () => _selectPlayer(player),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1B4268)
              : Colors.white.withValues(alpha: .035),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF5090D3)
                : Colors.white.withValues(alpha: .04),
          ),
        ),
        child: Row(
          children: [
            _avatar(player.username, radius: 19),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    player.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF9DB6D5),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${player.sport} · ${player.playerId}',
                    style: const TextStyle(
                      color: Color(0xFF79B8FF),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? const Color(0xFF55B8FF) : Colors.white38,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return BlocBuilder<CoachRosterCubit, CoachRosterState>(
      builder: (context, state) {
        final query = _searchController.text.trim();

        // Show search results when searching.
        // Otherwise show the complete coach roster.
        final players = query.length >= 2 ? state.matches : state.roster;

        return Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFF102846),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: .08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchField(state.searching),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Text(
                    'AVAILABLE ATHLETES',
                    style: TextStyle(
                      color: Color(0xFF8299B4),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${players.length} players',
                    style: const TextStyle(
                      color: Color(0xFF79B8FF),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              if (state.loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (query.length >= 2 && state.searching)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Searching players...',
                      style: TextStyle(color: Color(0xFF9DB6D5)),
                    ),
                  ),
                )
              else if (players.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      query.length >= 2
                          ? 'No players found.'
                          : 'No players available in your roster.',
                      style: const TextStyle(
                        color: Color(0xFF9DB6D5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      return _buildPlayerItem(players[index]);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECT ATHLETE',
          style: TextStyle(
            color: Color(0xFF9DB6D5),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(height: 9),

        GestureDetector(onTap: _toggleDropdown, child: _buildSelectedPlayer()),

        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _buildExpandedContent(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
