
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
        labelText: 'Athlete',
        labelStyle: const TextStyle(color: Color(0xFF9DB7D0), fontSize: 12),
        prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF79B8FF), size: 20),
        filled: true,
        fillColor: navyBlueMid,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withValues(alpha: .08))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF5090D3), width: 1.4)),
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
