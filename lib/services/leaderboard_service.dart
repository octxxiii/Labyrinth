import 'dart:math';
import '../models/user.dart';

class LeaderboardService {
  final List<User> _users = [];
  final List<String> _categories = [
    '전체',
    '시',
    '에세이',
    '일기',
    '편지',
    '시사',
    '철학',
    '예술'
  ];

  List<User> getLeaderboard({String? category}) {
    var users = List<User>.from(_users);

    if (category != null && category != '전체') {
      users = users.where((user) => user.interests.contains(category)).toList();
    }

    users.sort((a, b) => b.points.compareTo(a.points));
    return users;
  }

  List<User> getWeeklyTopUsers({int limit = 10}) {
    return getLeaderboard().take(limit).toList();
  }

  List<User> getMonthlyTopUsers({int limit = 10}) {
    return getLeaderboard().take(limit).toList();
  }

  List<User> getCategoryTopUsers(String category, {int limit = 10}) {
    return getLeaderboard(category: category).take(limit).toList();
  }

  void updateUserPoints(String userId, int points) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      final user = _users[index];
      _users[index] = user.copyWith(points: user.points + points);
    }
  }

  List<String> getCategories() {
    return List.from(_categories);
  }

  // 테스트용 더미 데이터 생성
  void generateDummyData() {
    final random = Random();
    final now = DateTime.now();

    for (var i = 0; i < 50; i++) {
      final interests = List<String>.from(_categories.skip(1))..shuffle(random);
      final interestCount = random.nextInt(5) + 1;

      _users.add(User(
        id: 'user_$i',
        name: '사용자 ${i + 1}',
        interests: interests.take(interestCount).toList(),
        bio: '안녕하세요! 저는 ${interests.take(2).join(", ")}에 관심이 있습니다.',
        isOnline: random.nextBool(),
        lastActive: now.subtract(Duration(minutes: random.nextInt(60))),
        points: random.nextInt(10000),
      ));
    }
  }
}
