import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard = [
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
            title: Text('${leaderboard[index]['name']}'),
            trailing: Text('${leaderboard[index]['points']} 포인트'),
          );
        },
      ),
    );
  }
}
