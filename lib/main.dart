import 'package:flutter/material.dart';
import 'dart:async';
import 'theme/app_theme.dart';
import 'screens/anonymous_mission_screen.dart';
import 'screens/secret_room_screen.dart';
import 'screens/scarcity_content_screen.dart';
import 'screens/random_connection_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/test_chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Labyrinth',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    AnonymousMissionScreen(),
    SecretRoomScreen(),
    RandomConnectionScreen(),
    ScarcityContentScreen(),
    LeaderboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment),
            label: '익명 미션',
          ),
          NavigationDestination(
            icon: Icon(Icons.lock),
            label: '비밀의 방',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: '순간 연결',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer),
            label: '희귀 콘텐츠',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard),
            label: '리더보드',
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Widget screen;

  const FeatureCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.screen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SettingsScreen 추가
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '설정 화면',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

// 익명 미션 화면
class AnonymousMissionScreen extends StatefulWidget {
  const AnonymousMissionScreen({super.key});

  @override
  _AnonymousMissionScreenState createState() => _AnonymousMissionScreenState();
}

class _AnonymousMissionScreenState extends State<AnonymousMissionScreen> {
  List<String> missions = [
    '가장 부끄러웠던 순간을 고백하세요.',
    '지난주에 했던 거짓말을 공유하세요.',
    '자신만 알고 있는 비밀을 털어놓으세요.'
  ];
  List<String> completedMissions = [];
  String? selectedMission;

  void _completeMission(String mission) {
    setState(() {
      completedMissions.add(mission);
      selectedMission = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('미션 완료! 트로피를 획득했습니다.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('익명 미션 수행'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (selectedMission == null)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedMission = (missions..shuffle()).first;
                });
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: Text('미션 시작'),
            ),
          if (selectedMission != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('미션: $selectedMission',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _completeMission(selectedMission!),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    child: Text('미션 완료'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: completedMissions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('완료된 미션: ${completedMissions[index]}',
                      style: const TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 리더보드 화면
class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard = const [
    {'name': '사용자 A', 'points': 1000},
    {'name': '사용자 B', 'points': 800},
    {'name': '사용자 C', 'points': 600},
    {'name': '사용자 D', 'points': 500},
    {'name': '사용자 E', 'points': 300},
  ];

  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리더보드'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${leaderboard[index]['name']}',
                style: const TextStyle(color: Colors.white)),
            trailing: Text('${leaderboard[index]['points']} 포인트',
                style: const TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}

// 랜덤 연결 화면
class RandomConnectionScreen extends StatelessWidget {
  final List<String> users = const [
    '사용자 A',
    '사용자 B',
    '사용자 C',
    '사용자 D',
    '사용자 E',
  ];

  const RandomConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final randomUser = (users..shuffle()).first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('순간 연결'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '랜덤으로 연결된 사용자: $randomUser',
              style: const TextStyle(color: Colors.blueAccent, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$randomUser와 연결이 끊어졌습니다.'),
                ));
                Navigator.pop(context);
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: Text('연결 종료'),
            ),
          ],
        ),
      ),
    );
  }
}

// 희소성 콘텐츠 화면
class ScarcityContentScreen extends StatefulWidget {
  const ScarcityContentScreen({super.key});

  @override
  _ScarcityContentScreenState createState() => _ScarcityContentScreenState();
}

class _ScarcityContentScreenState extends State<ScarcityContentScreen> {
  bool isContentAvailable = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 30), () {
      setState(() {
        isContentAvailable = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('희소성 콘텐츠'),
        centerTitle: true,
      ),
      body: Center(
        child: isContentAvailable
            ? const Text(
                '독점 콘텐츠 공개!',
                style: TextStyle(color: Colors.blueAccent, fontSize: 24),
              )
            : const Text(
                '콘텐츠가 준비되지 않았습니다. 잠시만 기다려 주세요.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
      ),
    );
  }
}

// 비밀의 방 화면
class SecretRoomScreen extends StatefulWidget {
  const SecretRoomScreen({super.key});

  @override
  _SecretRoomScreenState createState() => _SecretRoomScreenState();
}

class _SecretRoomScreenState extends State<SecretRoomScreen> {
  List<String> secrets = [];
  final TextEditingController _controller = TextEditingController();

  void _submitSecret(String secret) {
    if (secret.isNotEmpty) {
      setState(() {
        secrets.add(secret);
      });
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('비밀이 공유되었습니다!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀의 방'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: '비밀을 공유하세요',
                labelStyle: TextStyle(color: Colors.blueAccent),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _submitSecret(_controller.text),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: Text('비밀 제출'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: secrets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('비밀: ${secrets[index]}',
                      style: const TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
