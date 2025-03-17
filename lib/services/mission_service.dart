import 'dart:math';
import '../models/mission.dart';

class MissionService {
  final List<Mission> _missions = [
    Mission(
      id: '1',
      title: '일상의 고백',
      description: '오늘 하루 가장 부끄러웠던 순간을 고백하세요.',
      points: 100,
      difficulty: '쉬움',
      timeLimit: const Duration(minutes: 5),
      tags: ['일상', '고백'],
    ),
    Mission(
      id: '2',
      title: '거짓말 고백',
      description: '최근에 했던 거짓말을 고백하고 그 이유를 설명하세요.',
      points: 200,
      difficulty: '보통',
      timeLimit: const Duration(minutes: 10),
      tags: ['고백', '성장'],
    ),
    // 더 많은 미션 추가 가능
  ];

  List<Mission> getMissionsByDifficulty(String difficulty) {
    return _missions
        .where((mission) => mission.difficulty == difficulty)
        .toList();
  }

  List<Mission> getMissionsByTags(List<String> tags) {
    return _missions
        .where((mission) => mission.tags.any((tag) => tags.contains(tag)))
        .toList();
  }

  Mission getRandomMission() {
    final random = Random();
    return _missions[random.nextInt(_missions.length)];
  }

  Mission getMissionById(String id) {
    return _missions.firstWhere((mission) => mission.id == id);
  }

  List<Mission> getDailyMissions() {
    final random = Random();
    final dailyMissions = <Mission>[];
    final availableMissions = List<Mission>.from(_missions);

    for (var i = 0; i < 3; i++) {
      if (availableMissions.isEmpty) break;
      final index = random.nextInt(availableMissions.length);
      dailyMissions.add(availableMissions.removeAt(index));
    }

    return dailyMissions;
  }
}
