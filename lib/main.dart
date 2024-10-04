import 'package:flutter/material.dart';

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
  List<String> quotes = [
    '행복은 습관이다, 그것을 몸에 지니라. - 허버드',
    '성공은 열심히 노력하는 사람에게 찾아온다. - 아인슈타인',
    '꿈을 꾸지 않으면 미래도 없다. - 말콤 X',
    '시간은 금이다. - 벤자민 프랭클린',
    '행복은 준비된 자에게 찾아온다. - 에디슨',
    '성공이란 실패를 거듭하면서도 열정을 잃지 않는 것이다. - 윈스턴 처칠',
    '위대한 일은 갑자기 이루어지지 않는다. - 에픽테토스',
    '모든 위대한 행동은 작은 결정에서 시작된다. - 헨리 데이비드 소로',
    '어려움은 한 번의 시도로 해결되지 않는다. - 아리스토텔레스',
    '용기는 공포를 이기는 것이 아니라 공포와 함께 행동하는 것이다. - 마크 트웨인',
    '가장 중요한 것은 시작하는 것이다. - 파블로 피카소',
    '희망은 꿈꾸는 자에게만 주어진다. - 아리스토텔레스',
    '자신의 능력을 믿어라. - 브루스 리',
    '지식은 힘이다. - 프랜시스 베이컨',
    '오늘 할 수 있는 일을 내일로 미루지 마라. - 벤자민 프랭클린',
    '작은 행동이 큰 변화를 가져온다. - 존 우든',
    '성공은 성공하려는 의지에서 시작된다. - 벤자민 디즈레일리',
    '어떤 길도 첫걸음 없이는 시작되지 않는다. - 카를 구스타프 융',
    '변화는 고통스럽지만 피할 수 없다. - 지그 지글러',
    '인내는 쓰지만 그 열매는 달다. - 장 자크 루소',
    '실패는 성공으로 가는 과정이다. - 헨리 포드',
    '계획 없는 목표는 단지 바람일 뿐이다. - 앙투안 드 생텍쥐페리',
    '승리하는 자가 이기는 것이 아니라 끝까지 견디는 자가 승리한다. - 나폴레옹 힐',
    '미래는 오늘 하는 일에 달려 있다. - 마하트마 간디',
    '가장 큰 영광은 넘어지지 않는 것이 아니라, 넘어질 때마다 다시 일어서는 것이다. - 넬슨 만델라',
    '자신을 믿으면 그 어떤 것도 가능하다. - 나폴레옹 보나파르트',
    '두려움은 선택이다. 용기는 그 선택을 이기는 것이다. - 조지 S. 패튼',
    '배움은 마음을 넓힌다. - 레오나르도 다 빈치',
    '누구나 세상을 바꿀 수 있는 작은 행동을 할 수 있다. - 로버트 F. 케네디',
    '시작이 반이다. - 아리스토텔레스',
    '무엇이든지 할 수 있지만 모든 것을 할 수는 없다. - 데이비드 앨런',
    '문제는 기회로 변장하고 온다. - 존 애덤스',
    '인내가 없는 지혜는 작은 결실을 맺을 뿐이다. - 루소',
    '오늘의 실패는 내일의 성공의 밑거름이다. - 마하트마 간디',
    '현재를 즐겨라. - 호라티우스',
    '운명은 스스로 만드는 것이다. - 윌리엄 제닝스 브라이언',
    '도전 없는 삶은 의미 없다. - 소크라테스',
    '실패는 하나의 선택지일 뿐이다. - 엘론 머스크',
    '모든 것은 당신이 마음먹기에 달려 있다. - 헨리 포드',
    '겸손은 모든 미덕의 기초이다. - 공자',
    '사람은 혼자 꿈을 꾸지 않는다. - 나폴레옹 힐',
    '내일을 준비하는 가장 좋은 방법은 오늘 최선을 다하는 것이다. - H. 잭슨 브라운 주니어',
    '진정한 용기는 두려움을 극복하는 것이다. - 넬슨 만델라',
    '성공의 길은 언제나 고난의 길이다. - 프랭클린 D. 루즈벨트',
    '모든 성취는 계획에서 시작된다. - 피터 드러커',
    '작은 성공은 큰 성공의 시작이다. - 지그 지글러',
    '행동 없는 비전은 꿈일 뿐이다. - 존 맥스웰',
    '끊임없이 배워라. 그곳에 성장이 있다. - 존 F. 케네디',
    '자신을 믿고 한 발 내딛어라. - 헬렌 켈러',
    '포기하지 마라. 끝은 항상 시작이다. - 엘리너 루즈벨트',
    '기회는 스스로 만드는 것이다. - 조지 버나드 쇼',
    '실패는 더 나은 성공으로 가는 첫걸음이다. - 지그 지글러',
    '가장 빠른 길은 항상 직선이 아니다. - 에디슨',
    '고난은 우리의 강점을 드러낸다. - C.S. 루이스',
    '오늘의 작은 노력은 내일의 큰 성공으로 이어진다. - 에이브러햄 링컨',
    '진정한 용기는 목표를 향한 집념이다. - 토머스 제퍼슨',
    '열정이 성공을 만든다. - 랄프 왈도 에머슨',
    '실패는 성공의 일부이다. - 윈스턴 처칠',
    '미래는 자신이 결정한다. - 나폴레옹',
    '성공은 포기하지 않는 자에게만 찾아온다. - 윌슨',
    '어떤 일도 계획 없이는 이루어지지 않는다. - 스티브 잡스',
    '최선을 다하면 언제나 좋은 결과를 얻는다. - 엘리너 루즈벨트',
    '성공은 지식과 노력의 결합이다. - 베이컨',
    '작은 기회는 위대한 시작이다. - 데모스테네스',
    '실패는 성공을 위한 연습이다. - 세르반테스',
    '기회는 문을 두드릴 때 찾아온다. - 존 밀턴',
    '자신을 넘어서라. - 호라티우스',
    '위대한 일은 작은 시작에서 시작된다. - 레오나르도 다빈치',
    '변화를 두려워하지 마라. - 마하트마 간디',
    '목표 없는 삶은 방향 없는 배와 같다. - 몽테뉴',
    '노력은 재능을 이긴다. - 케빈 듀란트',
    '자신을 신뢰하라. - 셰익스피어',
    '지식은 행동으로 이루어져야 한다. - 플라톤',
    '승리는 준비된 자의 것이다. - 알렉산더 대왕',
    '성공은 실패를 뛰어넘는 자의 것이다. - 윈스턴 처칠',
    '단순함이 최상의 정교함이다. - 레오나르도 다 빈치',
    '현재를 살라. - 루크 에반스',
  ];

  int index = 0;

  void _showNextQuote() {
    setState(() {
      index = (index + 1) % quotes.length;
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
