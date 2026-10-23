class Privilege {
  final String id;
  final int privilegeId;
  final String name;
  final String description;
  final String category;
  final bool isSystemPrivilege;
  final int version;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Privilege({
    required this.id,
    required this.privilegeId,
    required this.name,
    required this.description,
    this.category = '',
    this.isSystemPrivilege = false,
    this.version = 0,
    this.createdAt,
    this.updatedAt,
  });

  Privilege copyWith({
    int? privilegeId,
    String? name,
    String? description,
    String? category,
    bool? isSystemPrivilege,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Privilege(
      id: id,
      privilegeId: privilegeId ?? this.privilegeId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isSystemPrivilege: isSystemPrivilege ?? this.isSystemPrivilege,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Privilege.fromJson(Map<String, dynamic> json) {
    return Privilege(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      privilegeId: _toInt(json['privilegeId']),
      name: (json['privilegeName'] ?? json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      isSystemPrivilege: json['isSystemPrivilege'] as bool? ?? false,
      version: _toInt(json['__v'] ?? json['version']),
      createdAt: _toDateTime(json['createdAt']),
      updatedAt: _toDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'privilegeId': privilegeId,
    '__v': version,
    'createdAt': createdAt?.toIso8601String(),
    'description': description,
    'isSystemPrivilege': isSystemPrivilege,
    'privilegeName': name,
    'updatedAt': updatedAt?.toIso8601String(),
    'category': category,
  };

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
