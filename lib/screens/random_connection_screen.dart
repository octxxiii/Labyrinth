import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user.dart';
import '../services/random_connection_service.dart';

class RandomConnectionScreen extends StatefulWidget {
  const RandomConnectionScreen({super.key});

  @override
  _RandomConnectionScreenState createState() => _RandomConnectionScreenState();
}

class _RandomConnectionScreenState extends State<RandomConnectionScreen> {
  final RandomConnectionService _service = RandomConnectionService();
  User? _currentUser;
  User? _matchedUser;
  bool _isLoading = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() {
    // 실제로는 로그인된 사용자 정보를 가져오는 로직이 들어갈 자리
    _currentUser = User(
      id: 'user_1',
      name: '현재 사용자',
      interests: ['시', '에세이', '철학'],
      bio: '문학을 사랑하는 사람',
      isOnline: true,
      lastActive: DateTime.now(),
      points: 1000,
    );
  }

  void _findMatch() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      final match = _service.findMatch(_currentUser!);
      setState(() {
        _matchedUser = match;
        _isLoading = false;
      });
      _showMatchDialog();
    });
  }

  void _showMatchDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('매칭 성공!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(_matchedUser!.name[0]),
            ),
            const SizedBox(height: 16),
            Text(
              _matchedUser!.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _matchedUser!.bio ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _matchedUser!.interests.map((interest) {
                return Chip(
                  label: Text(interest),
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  labelStyle: const TextStyle(color: AppTheme.primaryColor),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _blockUser(_matchedUser!.id);
            },
            child: const Text(
              '차단하기',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startChat();
            },
            child: const Text('대화 시작하기'),
          ),
        ],
      ),
    );
  }

  void _startChat() {
    setState(() {
      _isConnected = true;
    });
  }

  void _blockUser(String userId) {
    _service.blockUser(_currentUser!.id, userId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('사용자를 차단했습니다.'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _endChat() {
    setState(() {
      _isConnected = false;
      _matchedUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('순간 연결'),
        actions: [
          if (_isConnected)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _endChat,
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    '매칭 중...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : _isConnected
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: Text(_matchedUser!.name[0]),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _matchedUser!.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _matchedUser!.bio ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: _matchedUser!.interests.map((interest) {
                          return Chip(
                            label: Text(interest),
                            backgroundColor:
                                AppTheme.primaryColor.withOpacity(0.1),
                            labelStyle:
                                const TextStyle(color: AppTheme.primaryColor),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _endChat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                        ),
                        child: const Text('대화 종료'),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.people,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '새로운 대화를 시작하세요',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '관심사가 비슷한 사람들과 대화를 나누세요',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _findMatch,
                        child: const Text('매칭 시작'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
