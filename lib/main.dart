import 'package:flutter/material.dart';
import 'dart:convert'; // JSON 파싱을 위한 import
import 'dart:math'; // 랜덤 숫자 생성을 위한 import
import 'package:flutter/services.dart' show rootBundle; // JSON 파일 읽기 위한 import

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '!Quote',
      home: QuoteApp(),
    );
  }
}

class QuoteApp extends StatefulWidget {
  @override
  _QuoteAppState createState() => _QuoteAppState();
}

class _QuoteAppState extends State<QuoteApp> {
  List<String> quotes = [];
  int index = 0;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _loadQuotesFromJson(); // 앱 시작 시 JSON에서 명언 로드
  }

  // JSON 파일에서 명언을 불러오는 함수
  Future<void> _loadQuotesFromJson() async {
    try {
      String data = await rootBundle.loadString('assets/quotes_large.json');
      final jsonResult = json.decode(data);
      setState(() {
        quotes = List<String>.from(jsonResult.map((quote) =>
        '"${quote['korean']}"\n"${quote['english']}"\n- ${quote['author']}'));
        quotes.shuffle(); // 명언을 랜덤하게 섞음
      });
    } catch (error) {
      print('Error loading JSON: $error');
    }
  }

  // 다음 명언을 보여주는 함수 (모든 명언을 본 후에 다시 섞음)
  void _showNextQuote() {
    setState(() {
      index++;
      if (index >= quotes.length) {
        index = 0;
        quotes.shuffle(); // 모든 명언을 본 후 다시 섞음
      }
    });
  }

  void _showQuoteAtIndex(int selectedIndex) {
    setState(() {
      index = selectedIndex;
    });
    Navigator.pop(context);  // 목록에서 선택 후 뒤로 돌아가기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('!Quote'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _openQuoteList();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: quotes.isNotEmpty
              ? Text(
            quotes[index],
            style: TextStyle(
              fontSize: 24,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          )
              : CircularProgressIndicator(), // 명언이 로드되기 전에는 로딩 표시
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNextQuote,
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _openQuoteList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('명언 목록'),
          ),
          body: ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(quotes[index]),
                onTap: () {
                  _showQuoteAtIndex(index);  // 선택한 명언 보여주기
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
