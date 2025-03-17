import 'package:flutter/material.dart';

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
                  ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
              child: Text('미션 시작'),
            ),
          if (selectedMission != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('미션: $selectedMission'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _completeMission(selectedMission!),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent),
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
                  title: Text('완료된 미션: ${completedMissions[index]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
