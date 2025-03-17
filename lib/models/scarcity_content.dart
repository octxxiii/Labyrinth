class ScarcityContent {
  final String id;
  final String title;
  final String description;
  final String content;
  final DateTime startTime;
  final DateTime endTime;
  final int maxViews;
  int currentViews;
  final String category;
  final List<String> tags;
  final bool isExclusive;

  ScarcityContent({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.startTime,
    required this.endTime,
    required this.maxViews,
    this.currentViews = 0,
    required this.category,
    this.tags = const [],
    this.isExclusive = false,
  });

  bool get isAvailable {
    final now = DateTime.now();
    return now.isAfter(startTime) &&
        now.isBefore(endTime) &&
        currentViews < maxViews;
  }

  Duration get remainingTime {
    final now = DateTime.now();
    return endTime.difference(now);
  }

  double get viewProgress {
    return currentViews / maxViews;
  }

  factory ScarcityContent.fromJson(Map<String, dynamic> json) {
    return ScarcityContent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      maxViews: json['maxViews'],
      currentViews: json['currentViews'] ?? 0,
      category: json['category'],
      tags: List<String>.from(json['tags'] ?? []),
      isExclusive: json['isExclusive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'maxViews': maxViews,
      'currentViews': currentViews,
      'category': category,
      'tags': tags,
      'isExclusive': isExclusive,
    };
  }

  ScarcityContent copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    DateTime? startTime,
    DateTime? endTime,
    int? maxViews,
    int? currentViews,
    String? category,
    List<String>? tags,
    bool? isExclusive,
  }) {
    return ScarcityContent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      maxViews: maxViews ?? this.maxViews,
      currentViews: currentViews ?? this.currentViews,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isExclusive: isExclusive ?? this.isExclusive,
    );
  }
}
