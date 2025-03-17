class SecretMessage {
  final String id;
  final String content;
  final DateTime createdAt;
  int likes;
  final List<String> tags;
  final String? userId;
  final bool isAnonymous;

  SecretMessage({
    required this.id,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.tags = const [],
    this.userId,
    this.isAnonymous = true,
  });

  factory SecretMessage.fromJson(Map<String, dynamic> json) {
    return SecretMessage(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      likes: json['likes'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      userId: json['userId'],
      isAnonymous: json['isAnonymous'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'tags': tags,
      'userId': userId,
      'isAnonymous': isAnonymous,
    };
  }

  SecretMessage copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    int? likes,
    List<String>? tags,
    String? userId,
    bool? isAnonymous,
  }) {
    return SecretMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      tags: tags ?? this.tags,
      userId: userId ?? this.userId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
