import 'dart:math';
import '../models/anonymous_mission.dart';

class AnonymousMissionService {
  final List<AnonymousMission> _missions = [];
  final List<String> _missionTemplates = [
    '오늘 하루 가장 행복했던 순간을 공유하세요',
    '당신만의 특별한 취미를 소개해주세요',
    '최근에 새롭게 시도해본 것을 공유하세요',
    '당신의 일상에서 가장 소중한 물건을 소개하세요',
    '오늘 하루 가장 감사했던 순간을 공유하세요',
    '당신만의 특별한 습관을 공유하세요',
    '최근에 새롭게 배운 것을 공유하세요',
    '당신의 일상에서 가장 좋아하는 순간을 공유하세요',
    '오늘 하루 가장 힘들었던 순간을 공유하세요',
    '당신만의 특별한 취향을 공유하세요',
  ];

  List<AnonymousMission> getAvailableMissions() {
    return _missions;
  }

  void generateDummyData() {
    _missions.clear();
    final random = Random();
    final now = DateTime.now();

    for (var i = 0; i < 5; i++) {
      _missions.add(
        AnonymousMission(
          id: 'mission_$i',
          title: '일일 미션 ${i + 1}',
          description:
              _missionTemplates[random.nextInt(_missionTemplates.length)],
          points: 100 + (i * 50),
          timeLimit: const Duration(hours: 24),
          createdAt: now,
        ),
      );
    }
  }

  bool completeMission(String missionId) {
    final initialLength = _missions.length;
    _missions.removeWhere((mission) => mission.id == missionId);
    return _missions.length < initialLength;
  }

  AnonymousMission? getMissionById(String missionId) {
    try {
      return _missions.firstWhere((mission) => mission.id == missionId);
    } catch (e) {
      return null;
    }
  }
}
