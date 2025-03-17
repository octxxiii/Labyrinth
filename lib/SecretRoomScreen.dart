import 'package:flutter/material.dart';

class SecretRoomScreen extends StatefulWidget {
  @override
  _SecretRoomScreenState createState() => _SecretRoomScreenState();
}

class _SecretRoomScreenState extends State<SecretRoomScreen> {
  List<String> secrets = [];

  final TextEditingController _controller = TextEditingController();

  void _submitSecret(String secret) {
    setState(() {
      secrets.add(secret);
    });
    _controller.clear();
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
                labelStyle: TextStyle(color: Colors.greenAccent),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _submitSecret(_controller.text),
            child: Text('비밀 제출'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: secrets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('비밀: ${secrets[index]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
