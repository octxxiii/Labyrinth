import 'dart:math';
import '../models/secret_message.dart';

class SecretRoomService {
  final List<SecretMessage> _messages = [];
  final List<String> _availableTags = [
    '일상',
    '고민',
    '행복',
    '성장',
    '희망',
    '사랑',
    '친구',
    '가족',
    '취미',
    '꿈',
  ];

  List<SecretMessage> getMessages() {
    return _messages;
  }

  List<SecretMessage> getMessagesByTag(String tag) {
    return _messages.where((message) => message.tags.contains(tag)).toList();
  }

  List<String> getAvailableTags() {
    return _availableTags;
  }

  void generateDummyData() {
    _messages.clear();
    final random = Random();
    final now = DateTime.now();

    for (var i = 0; i < 10; i++) {
      final tags = _availableTags.toList()..shuffle(random);
      final messageTags = tags.take(random.nextInt(3) + 1).toList();

      _messages.add(
        SecretMessage(
          id: 'message_$i',
          content: '이것은 테스트 메시지 $i입니다. 비밀의 방에서 공유되는 메시지입니다.',
          createdAt: now.subtract(Duration(hours: i)),
          likes: random.nextInt(100),
          tags: messageTags,
        ),
      );
    }
  }

  void likeMessage(String messageId) {
    final message = _messages.firstWhere((m) => m.id == messageId);
    message.likes++;
  }

  List<SecretMessage> getTrendingMessages() {
    final sortedMessages = List<SecretMessage>.from(_messages)
      ..sort((a, b) => b.likes.compareTo(a.likes));
    return sortedMessages.take(5).toList();
  }

  List<String> getSuggestedTags() {
    final tagCounts = <String, int>{};
    for (var message in _messages) {
      for (var tag in message.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedTags.take(5).map((e) => e.key).toList();
  }
}
