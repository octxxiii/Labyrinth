class Mission {
  final String id;
  final String title;
  final String description;
  final int points;
  final String difficulty;
  final Duration timeLimit;
  final List<String> tags;
  final bool isCompleted;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.difficulty,
    required this.timeLimit,
    required this.tags,
    this.isCompleted = false,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      points: json['points'],
      difficulty: json['difficulty'],
      timeLimit: Duration(seconds: json['timeLimit']),
      tags: List<String>.from(json['tags']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'difficulty': difficulty,
      'timeLimit': timeLimit.inSeconds,
      'tags': tags,
      'isCompleted': isCompleted,
    };
  }
}
