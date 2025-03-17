import 'package:flutter/material.dart';
import 'dart:math';

class RandomConnectionScreen extends StatelessWidget {
  final List<String> users = [
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
              style: const TextStyle(color: Colors.greenAccent, fontSize: 24),
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
                  ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
              child: Text('연결 종료'),
            ),
          ],
        ),
      ),
    );
  }
}
