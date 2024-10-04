import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '명언 앱',
      home: QuoteApp(),
    );
  }
}

class QuoteApp extends StatefulWidget {
  @override
  _QuoteAppState createState() => _QuoteAppState();
}

class _QuoteAppState extends State<QuoteApp> {
  List<String> quotes = [
    '행복은 습관이다, 그것을 몸에 지니라. - 허버드',
    '성공은 열심히 노력하는 사람에게 찾아온다. - 아인슈타인',
    '꿈을 꾸지 않으면 미래도 없다. - 말콤 X',
  ];

  int index = 0;

  void _showNextQuote() {
    setState(() {
      index = (index + 1) % quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('명언 앱'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            quotes[index],
            style: TextStyle(
              fontSize: 24,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNextQuote,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
