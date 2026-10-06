// ============================================================
// DATA MODEL
// ============================================================

class PlayerData {
  final String id;
  final int bpm;
  final int steps;
  final int calories;
  final String status;
  final List<double> heartRate;

  const PlayerData({
    required this.id,
    required this.bpm,
    required this.steps,
    required this.calories,
    required this.status,
    required this.heartRate,
  });
}