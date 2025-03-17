import 'package:flutter_test/flutter_test.dart';
import 'package:quotes/models/user.dart';
import 'package:quotes/screens/test_chat_screen.dart';
import 'package:quotes/services/random_connection_service.dart';

void main() {
  group('채팅 테스트', () {
    late RandomConnectionService service;
    late TestChatScreen screen1;
    late TestChatScreen screen2;

    setUp(() {
      service = RandomConnectionService();
      service.generateDummyData(); // 더미 데이터 생성
      screen1 = TestChatScreen(
        userId: 'user_1',
        userName: '시인',
        interests: ['시', '에세이', '철학'],
        bio: '문학을 사랑하는 시인',
      );
      screen2 = TestChatScreen(
        userId: 'user_2',
        userName: '철학자',
        interests: ['철학', '과학', '예술'],
        bio: '진리를 추구하는 철학자',
      );
    });

    test('사용자 매칭 테스트', () {
      final user1 = User(
        id: 'user_1',
        name: '시인',
        interests: ['시', '에세이', '철학'],
        bio: '문학을 사랑하는 시인',
        isOnline: true,
        lastActive: DateTime.now(),
        points: 1000,
      );

      final match = service.findMatch(user1);
      expect(match, isNotNull);
      expect(match!.id, isNot(user1.id));
      expect(
          match.interests.any((interest) => user1.interests.contains(interest)),
          isTrue);
    });

    test('UI 요소 테스트', () {
      // AppBar 타이틀 확인
      expect(screen1.userName, '시인');
      expect(screen2.userName, '철학자');

      // 관심사 확인
      expect(screen1.interests, contains('시'));
      expect(screen2.interests, contains('철학'));

      // 소개 확인
      expect(screen1.bio, '문학을 사랑하는 시인');
      expect(screen2.bio, '진리를 추구하는 철학자');
    });
  });
}
