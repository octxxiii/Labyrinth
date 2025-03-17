import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/anonymous_mission.dart';
import '../services/anonymous_mission_service.dart';

class AnonymousMissionScreen extends StatefulWidget {
  const AnonymousMissionScreen({super.key});

  @override
  _AnonymousMissionScreenState createState() => _AnonymousMissionScreenState();
}

class _AnonymousMissionScreenState extends State<AnonymousMissionScreen> {
  final AnonymousMissionService _service = AnonymousMissionService();
  List<AnonymousMission> _missions = [];
  bool _isLoading = true;
  int _points = 0;

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  void _loadMissions() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      _service.generateDummyData();
      setState(() {
        _missions = _service.getAvailableMissions();
        _isLoading = false;
      });
    });
  }

  void _completeMission(AnonymousMission mission) {
    setState(() {
      _points += mission.points;
      _missions.remove(mission);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('미션 완료! ${mission.points}포인트를 획득했습니다.'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('익명 미션'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMissions,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 포인트',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '$_points',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.emoji_events,
                  color: AppTheme.primaryColor,
                  size: 48,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _missions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 64,
                              color: AppTheme.textSecondaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '오늘의 미션을 모두 완료했습니다!',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '내일 새로운 미션이 등장합니다.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _missions.length,
                        itemBuilder: (context, index) {
                          final mission = _missions[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '미션 ${index + 1}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${mission.points}포인트',
                                          style: const TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    mission.description,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          _completeMission(mission),
                                      child: const Text('미션 완료'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
