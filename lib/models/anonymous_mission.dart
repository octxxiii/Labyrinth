class AnonymousMission {
  final String id;
  final String title;
  final String description;
  final int points;
  final Duration timeLimit;
  final DateTime createdAt;

  AnonymousMission({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.timeLimit,
    required this.createdAt,
  });

  factory AnonymousMission.fromJson(Map<String, dynamic> json) {
    return AnonymousMission(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      points: json['points'],
      timeLimit: Duration(seconds: json['timeLimit']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'timeLimit': timeLimit.inSeconds,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
