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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes',
      theme: AppTheme.theme,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final List<FeatureCard> features = [
    FeatureCard(
      title: '익명 미션',
      description: '매일 새로운 미션을 수행하고 포인트를 획득하세요',
      icon: Icons.task_alt,
      screen: AnonymousMissionScreen(),
    ),
    FeatureCard(
      title: '비밀의 방',
      description: '익명으로 당신의 이야기를 공유하세요',
      icon: Icons.lock,
      screen: SecretRoomScreen(),
    ),
    FeatureCard(
      title: '희귀 콘텐츠',
      description: '한정된 시간 동안만 볼 수 있는 특별한 콘텐츠',
      icon: Icons.star,
      screen: ScarcityContentScreen(),
    ),
    FeatureCard(
      title: '순간 연결',
      description: '관심사가 비슷한 사람들과 대화를 나누세요',
      icon: Icons.people,
      screen: RandomConnectionScreen(),
    ),
    FeatureCard(
      title: '리더보드',
      description: '포인트 순위를 확인하고 경쟁하세요',
      icon: Icons.leaderboard,
      screen: LeaderboardScreen(),
    ),
    FeatureCard(
      title: '테스트 채팅 1',
      description: '첫 번째 사용자의 채팅 화면',
      icon: Icons.chat,
      screen: TestChatScreen(
        userId: 'user_1',
        userName: '시인',
        interests: ['시', '에세이', '철학'],
        bio: '문학을 사랑하는 시인',
      ),
    ),
    FeatureCard(
      title: '테스트 채팅 2',
      description: '두 번째 사용자의 채팅 화면',
      icon: Icons.chat,
      screen: TestChatScreen(
        userId: 'user_2',
        userName: '철학자',
        interests: ['철학', '과학', '예술'],
        bio: '진리를 추구하는 철학자',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 설정 화면으로 이동
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: features[index],
          );
        },
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
          padding: EdgeInsets.all(16),
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
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        centerTitle: true,
      ),
      body: Center(
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('미션 완료! 트로피를 획득했습니다.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('익명 미션 수행'),
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
              child: Text('미션 시작'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          if (selectedMission != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('미션: $selectedMission',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _completeMission(selectedMission!),
                    child: Text('미션 완료'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
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
                      style: TextStyle(color: Colors.white)),
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
  final List<Map<String, dynamic>> leaderboard = [
    {'name': '사용자 A', 'points': 1000},
    {'name': '사용자 B', 'points': 800},
    {'name': '사용자 C', 'points': 600},
    {'name': '사용자 D', 'points': 500},
    {'name': '사용자 E', 'points': 300},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리더보드'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${leaderboard[index]['name']}',
                style: TextStyle(color: Colors.white)),
            trailing: Text('${leaderboard[index]['points']} 포인트',
                style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }
}

// 랜덤 연결 화면
class RandomConnectionScreen extends StatelessWidget {
  final List<String> users = [
    '사용자 A',
    '사용자 B',
    '사용자 C',
    '사용자 D',
    '사용자 E',
  ];

  @override
  Widget build(BuildContext context) {
    final randomUser = (users..shuffle()).first;

    return Scaffold(
      appBar: AppBar(
        title: Text('순간 연결'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '랜덤으로 연결된 사용자: $randomUser',
              style: TextStyle(color: Colors.blueAccent, fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$randomUser와 연결이 끊어졌습니다.'),
                ));
                Navigator.pop(context);
              },
              child: Text('연결 종료'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}

// 희소성 콘텐츠 화면
class ScarcityContentScreen extends StatefulWidget {
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
    _timer = Timer(Duration(seconds: 30), () {
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
        title: Text('희소성 콘텐츠'),
        centerTitle: true,
      ),
      body: Center(
        child: isContentAvailable
            ? Text(
                '독점 콘텐츠 공개!',
                style: TextStyle(color: Colors.blueAccent, fontSize: 24),
              )
            : Text(
                '콘텐츠가 준비되지 않았습니다. 잠시만 기다려 주세요.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
      ),
    );
  }
}

// 비밀의 방 화면
class SecretRoomScreen extends StatefulWidget {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('비밀이 공유되었습니다!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀의 방'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
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
            child: Text('비밀 제출'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: secrets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('비밀: ${secrets[index]}',
                      style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
