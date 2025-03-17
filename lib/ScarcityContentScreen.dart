import 'package:flutter/material.dart';
import 'dart:async';

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
          style: TextStyle(color: Colors.greenAccent, fontSize: 24),
        )
            : Text(
          '콘텐츠가 준비되지 않았습니다. 잠시만 기다려 주세요.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
