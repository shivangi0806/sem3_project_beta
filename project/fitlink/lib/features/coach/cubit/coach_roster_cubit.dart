import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitlink/features/coach/data/services/coach_roster_service.dart';

class CoachRosterPlayer {
  const CoachRosterPlayer({
    required this.playerId,
    required this.userId,
    required this.username,
    required this.email,
    required this.sport,
  });

  final String playerId;
  final String userId;
  final String username;
  final String email;
  final String sport;

  factory CoachRosterPlayer.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'] as Map)
        : <String, dynamic>{};
    return CoachRosterPlayer(
      playerId: '${json['playerId'] ?? ''}',
      userId: '${json['userId'] ?? user['userId'] ?? ''}',
      username: '${user['username'] ?? json['username'] ?? 'Player'}',
      email: '${user['email'] ?? json['email'] ?? ''}',
      sport: '${json['sport'] ?? 'general'}',
    );
  }
}

class CoachRosterState {
  const CoachRosterState({
    this.loading = false,
    this.searching = false,
    this.workingPlayerId,
    this.roster = const [],
    this.matches = const [],
    this.error,
    this.notice,
  });

  final bool loading;
  final bool searching;
  final String? workingPlayerId;
  final List<CoachRosterPlayer> roster;
  final List<CoachRosterPlayer> matches;
  final String? error;
  final String? notice;

  CoachRosterState copyWith({
    bool? loading,
    bool? searching,
    String? workingPlayerId,
    bool clearWorkingPlayer = false,
    List<CoachRosterPlayer>? roster,
    List<CoachRosterPlayer>? matches,
    String? error,
    bool clearError = false,
    String? notice,
    bool clearNotice = false,
  }) => CoachRosterState(
    loading: loading ?? this.loading,
    searching: searching ?? this.searching,
    workingPlayerId: clearWorkingPlayer ? null : workingPlayerId ?? this.workingPlayerId,
    roster: roster ?? this.roster,
    matches: matches ?? this.matches,
    error: clearError ? null : error ?? this.error,
    notice: clearNotice ? null : notice ?? this.notice,
  );
}

class CoachRosterCubit extends Cubit<CoachRosterState> {
  CoachRosterCubit(this._service) : super(const CoachRosterState(loading: true));
  final CoachRosterService _service;
  int _searchGeneration = 0;

  @override
  Future<void> close() {
    _service.dispose();
    return super.close();
  }

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true, clearNotice: true));
    try {
      final response = await _service.getRoster();
      final data = response['data'];
      final raw = data is Map ? data['players'] : data;
      emit(state.copyWith(
        loading: false,
        roster: _players(raw),
        matches: const [],
      ));
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> search(String query) async {
    final generation = ++_searchGeneration;
    if (query.trim().length < 2) {
      emit(state.copyWith(searching: false, matches: const [], clearError: true));
      return;
    }
    emit(state.copyWith(searching: true, clearError: true));
    try {
      final response = await _service.searchPlayers(query.trim());
      if (generation != _searchGeneration) return;
      emit(state.copyWith(searching: false, matches: _players(response['data'])));
    } catch (error) {
      if (generation != _searchGeneration) return;
      emit(state.copyWith(searching: false, error: error.toString()));
    }
  }

  Future<bool> add(String userId) async {
    emit(state.copyWith(workingPlayerId: userId, clearError: true, clearNotice: true));
    try {
      await _service.addPlayer(userId);
      final response = await _service.getRoster();
      final data = response['data'];
      emit(state.copyWith(
        clearWorkingPlayer: true,
        roster: _players(data is Map ? data['players'] : data),
        matches: state.matches.where((player) => player.userId != userId).toList(),
        notice: 'Player added to your roster. They are now available for sessions.',
      ));
      return true;
    } catch (error) {
      emit(state.copyWith(clearWorkingPlayer: true, error: error.toString()));
      return false;
    }
  }

  Future<bool> remove(String playerId) async {
    emit(state.copyWith(workingPlayerId: playerId, clearError: true, clearNotice: true));
    try {
      await _service.removePlayer(playerId);
      emit(state.copyWith(
        clearWorkingPlayer: true,
        roster: state.roster.where((player) => player.playerId != playerId).toList(),
        notice: 'Player removed from your roster.',
      ));
      return true;
    } catch (error) {
      emit(state.copyWith(clearWorkingPlayer: true, error: error.toString()));
      return false;
    }
  }

  List<CoachRosterPlayer> _players(dynamic value) => value is List
      ? value.whereType<Map>().map((item) => CoachRosterPlayer.fromJson(Map<String, dynamic>.from(item))).toList()
      : const [];
}
