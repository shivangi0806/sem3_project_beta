
import 'package:flutter/material.dart';
import 'package:fitlink/features/coach/cubit/coach_roster_cubit.dart';
import 'package:fitlink/core/theme/app_theme.dart';
class PlayerSelector extends StatelessWidget {
  final List<CoachRosterPlayer> players;
  final String? selectedPlayerId;
  final ValueChanged<String?> onChanged;

  const PlayerSelector({
    super.key,
    required this.players,
    required this.selectedPlayerId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedPlayerId,
      isExpanded: true,
      dropdownColor: const Color(0xFF132F4C),
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: 'Select Player',
        labelStyle: const TextStyle(
          color: Color(0xFF9DB7D0),
          fontSize: 12,
        ),
        filled: true,
        fillColor: navyBlueMid,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: players.map((player) {
        return DropdownMenuItem<String>(
          value: player.playerId,
          child: Text(player.username),
        );
      }).toList(),
      onChanged: players.isEmpty ? null : onChanged,
    );
  }
}
