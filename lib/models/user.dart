class User {
  final String id;
  final String name;
  final List<String> interests;
  final String? bio;
  final bool isOnline;
  final DateTime lastActive;
  final int points;
  final List<String> blockedUsers;

  User({
    required this.id,
    required this.name,
    required this.interests,
    this.bio,
    required this.isOnline,
    required this.lastActive,
    required this.points,
    List<String>? blockedUsers,
  }) : this.blockedUsers = blockedUsers ?? [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      interests: List<String>.from(json['interests']),
      bio: json['bio'] as String?,
      isOnline: json['isOnline'] as bool,
      lastActive: DateTime.parse(json['lastActive'] as String),
      points: json['points'] as int,
      blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'interests': interests,
      'bio': bio,
      'isOnline': isOnline,
      'lastActive': lastActive.toIso8601String(),
      'points': points,
      'blockedUsers': blockedUsers,
    };
  }

  User copyWith({
    String? id,
    String? name,
    List<String>? interests,
    String? bio,
    bool? isOnline,
    DateTime? lastActive,
    int? points,
    List<String>? blockedUsers,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      interests: interests ?? this.interests,
      bio: bio ?? this.bio,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      points: points ?? this.points,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }
}
