class CoachDashboardModel {
  const CoachDashboardModel({
    required this.coach,
    required this.members,
    required this.training,
    required this.performance,
    required this.wearable,
    required this.attention,
  });

  final CoachProfileModel coach;
  final CoachMembersModel members;
  final CoachTrainingModel training;
  final CoachPerformanceModel performance;
  final CoachWearableModel wearable;
  final CoachAttentionModel attention;

  factory CoachDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    return CoachDashboardModel(
      coach: CoachProfileModel.fromJson(_map(data['coach'])),
      members: CoachMembersModel.fromJson(_map(data['members'])),
      training: CoachTrainingModel.fromJson(_map(data['training'])),
      performance: CoachPerformanceModel.fromJson(_map(data['performance'])),
      wearable: CoachWearableModel.fromJson(_map(data['wearable'])),
      attention: CoachAttentionModel.fromJson(_map(data['attention'])),
    );
  }

  Map<String, dynamic> toJson() => {
        'coach': coach.toJson(),
        'members': members.toJson(),
        'training': training.toJson(),
        'performance': performance.toJson(),
        'wearable': wearable.toJson(),
        'attention': attention.toJson(),
      };
}

class CoachProfileModel {
  const CoachProfileModel({
    this.userId = '',
    this.username = '',
    this.email = '',
    this.mobileNo,
    this.roleId = '',
  });

  final String userId;
  final String username;
  final String email;
  final String? mobileNo;
  final String roleId;

  factory CoachProfileModel.fromJson(Map<String, dynamic> json) =>
      CoachProfileModel(
        userId: _string(json['userId']),
        username: _string(json['username']),
        email: _string(json['email']),
        mobileNo: json['mobileNo']?.toString(),
        roleId: _string(json['roleId']),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'email': email,
        'mobileNo': mobileNo,
        'roleId': roleId,
      };
}

class CoachMembersModel {
  const CoachMembersModel({
    this.total = 0,
    this.active = 0,
    this.inactive = 0,
    this.activityRate = 0,
  });

  final int total;
  final int active;
  final int inactive;
  final num activityRate;

  factory CoachMembersModel.fromJson(Map<String, dynamic> json) =>
      CoachMembersModel(
        total: _int(json['total']),
        active: _int(json['active']),
        inactive: _int(json['inactive']),
        activityRate: _num(json['activityRate']),
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'active': active,
        'inactive': inactive,
        'activityRate': activityRate,
      };
}

class CoachTrainingModel {
  const CoachTrainingModel({
    this.workoutCompletionRate,
    this.attendanceRate,
    this.upcomingSessions,
    this.completedSessions,
  });

  final num? workoutCompletionRate;
  final num? attendanceRate;
  final int? upcomingSessions;
  final int? completedSessions;

  factory CoachTrainingModel.fromJson(Map<String, dynamic> json) =>
      CoachTrainingModel(
        workoutCompletionRate: _nullableNum(json['workoutCompletionRate']),
        attendanceRate: _nullableNum(json['attendanceRate']),
        upcomingSessions: _nullableInt(json['upcomingSessions']),
        completedSessions: _nullableInt(json['completedSessions']),
      );

  Map<String, dynamic> toJson() => {
        'workoutCompletionRate': workoutCompletionRate,
        'attendanceRate': attendanceRate,
        'upcomingSessions': upcomingSessions,
        'completedSessions': completedSessions,
      };
}

class CoachPerformanceModel {
  const CoachPerformanceModel({
    this.membersShowingProgress,
    this.personalRecords,
    this.averageTrainingTime,
  });

  final int? membersShowingProgress;
  final int? personalRecords;
  final num? averageTrainingTime;

  factory CoachPerformanceModel.fromJson(Map<String, dynamic> json) =>
      CoachPerformanceModel(
        membersShowingProgress: _nullableInt(json['membersShowingProgress']),
        personalRecords: _nullableInt(json['personalRecords']),
        averageTrainingTime: _nullableNum(json['averageTrainingTime']),
      );

  Map<String, dynamic> toJson() => {
        'membersShowingProgress': membersShowingProgress,
        'personalRecords': personalRecords,
        'averageTrainingTime': averageTrainingTime,
      };
}

class CoachWearableModel {
  const CoachWearableModel({
    this.connectedDevices,
    this.activeDevices,
    this.averageSteps,
    this.averageHeartRate,
    this.syncSuccessRate,
  });

  final int? connectedDevices;
  final int? activeDevices;
  final num? averageSteps;
  final num? averageHeartRate;
  final num? syncSuccessRate;

  factory CoachWearableModel.fromJson(Map<String, dynamic> json) =>
      CoachWearableModel(
        connectedDevices: _nullableInt(json['connectedDevices']),
        activeDevices: _nullableInt(json['activeDevices']),
        averageSteps: _nullableNum(json['averageSteps']),
        averageHeartRate: _nullableNum(json['averageHeartRate']),
        syncSuccessRate: _nullableNum(json['syncSuccessRate']),
      );

  Map<String, dynamic> toJson() => {
        'connectedDevices': connectedDevices,
        'activeDevices': activeDevices,
        'averageSteps': averageSteps,
        'averageHeartRate': averageHeartRate,
        'syncSuccessRate': syncSuccessRate,
      };
}

class CoachAttentionModel {
  const CoachAttentionModel({this.membersNeedingAttention});

  final int? membersNeedingAttention;

  factory CoachAttentionModel.fromJson(Map<String, dynamic> json) =>
      CoachAttentionModel(
        membersNeedingAttention: _nullableInt(json['membersNeedingAttention']),
      );

  Map<String, dynamic> toJson() => {
        'membersNeedingAttention': membersNeedingAttention,
      };
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};
String _string(dynamic value) => value?.toString() ?? '';
num _num(dynamic value) => value is num ? value : num.tryParse('$value') ?? 0;
int _int(dynamic value) => value is num ? value.toInt() : int.tryParse('$value') ?? 0;
num? _nullableNum(dynamic value) => value is num ? value : num.tryParse('$value');
int? _nullableInt(dynamic value) => value is num ? value.toInt() : int.tryParse('$value');
