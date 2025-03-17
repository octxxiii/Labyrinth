import 'dart:math';
import '../models/user.dart';

class RandomConnectionService {
  final List<User> _users = [];
  final List<String> _availableInterests = [
    '시',
    '에세이',
    '철학',
    '과학',
    '예술',
    '역사',
    '문학',
    '심리',
  ];

  List<User> getOnlineUsers() {
    return _users.where((user) => user.isOnline).toList();
  }

  User? findMatch(User currentUser) {
    final onlineUsers = _users
        .where((user) =>
            user.isOnline &&
            user.id != currentUser.id &&
            !currentUser.blockedUsers.contains(user.id) &&
            !user.blockedUsers.contains(currentUser.id))
        .toList();

    if (onlineUsers.isEmpty) return null;

    // 관심사가 일치하는 사용자 찾기
    final matchingUsers = onlineUsers
        .where((user) => user.interests
            .any((interest) => currentUser.interests.contains(interest)))
        .toList();

    if (matchingUsers.isNotEmpty) {
      return matchingUsers[Random().nextInt(matchingUsers.length)];
    }

    // 관심사가 일치하는 사용자가 없으면 무작위로 선택
    return onlineUsers[Random().nextInt(onlineUsers.length)];
  }

  void updateUserStatus(String userId, bool isOnline) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex != -1) {
      _users[userIndex] = _users[userIndex].copyWith(
        isOnline: isOnline,
        lastActive: DateTime.now(),
      );
    }
  }

  void blockUser(String userId, String blockedUserId) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex != -1) {
      final user = _users[userIndex];
      final updatedBlockedUsers = List<String>.from(user.blockedUsers)
        ..add(blockedUserId);
      _users[userIndex] = user.copyWith(blockedUsers: updatedBlockedUsers);
    }
  }

  void unblockUser(String userId, String blockedUserId) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex != -1) {
      final user = _users[userIndex];
      final updatedBlockedUsers = List<String>.from(user.blockedUsers)
        ..remove(blockedUserId);
      _users[userIndex] = user.copyWith(blockedUsers: updatedBlockedUsers);
    }
  }

  void generateDummyData() {
    _users.clear();
    final random = Random();

    for (int i = 0; i < 20; i++) {
      final interests = List<String>.from(_availableInterests)
        ..shuffle()
        ..take(random.nextInt(3) + 1);

      _users.add(User(
        id: 'user_${i + 1}',
        name: '사용자 ${i + 1}',
        interests: interests,
        bio: '사용자 ${i + 1}의 소개',
        isOnline: random.nextBool(),
        lastActive:
            DateTime.now().subtract(Duration(minutes: random.nextInt(60))),
        points: random.nextInt(1000),
      ));
    }
  }
}
