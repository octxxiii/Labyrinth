import 'dart:math';
import '../models/scarcity_content.dart';

class ScarcityContentService {
  final List<ScarcityContent> _contents = [];
  final List<String> _categories = [
    '시',
    '에세이',
    '철학',
    '과학',
    '예술',
    '역사',
    '문학',
    '심리',
  ];

  List<ScarcityContent> getAvailableContents() {
    return _contents.where((content) => content.isAvailable).toList();
  }

  List<ScarcityContent> getContentsByCategory(String category) {
    return _contents
        .where((content) => content.isAvailable && content.category == category)
        .toList();
  }

  List<String> getCategories() {
    return _categories;
  }

  ScarcityContent? getContentById(String id) {
    try {
      return _contents.firstWhere((content) => content.id == id);
    } catch (e) {
      return null;
    }
  }

  void viewContent(String id) {
    final content = getContentById(id);
    if (content != null) {
      final index = _contents.indexWhere((c) => c.id == id);
      if (index != -1) {
        _contents[index] = content.copyWith(
          currentViews: content.currentViews + 1,
        );
      }
    }
  }

  List<ScarcityContent> getTrendingContents() {
    final sortedContents = List<ScarcityContent>.from(_contents)
      ..sort((a, b) => b.currentViews.compareTo(a.currentViews));
    return sortedContents.take(5).toList();
  }

  void generateDummyData() {
    _contents.clear();
    final random = Random();
    final now = DateTime.now();

    for (var i = 0; i < 10; i++) {
      final category = _categories[random.nextInt(_categories.length)];
      final isExclusive = random.nextBool();
      final maxViews = isExclusive ? 50 : 100;
      final currentViews = random.nextInt(maxViews);
      final startTime = now.subtract(Duration(hours: random.nextInt(24)));
      final endTime = startTime.add(Duration(hours: 24));

      _contents.add(
        ScarcityContent(
          id: 'content_$i',
          title: '${category} 콘텐츠 ${i + 1}',
          description:
              '이것은 ${category} 카테고리의 ${isExclusive ? '독점' : '일반'} 콘텐츠입니다.',
          content: '이것은 테스트 콘텐츠 $i입니다. ${category} 카테고리의 콘텐츠입니다.',
          startTime: startTime,
          endTime: endTime,
          maxViews: maxViews,
          currentViews: currentViews,
          category: category,
          isExclusive: isExclusive,
        ),
      );
    }
  }
}
