import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user.dart';
import '../services/random_connection_service.dart';

class TestChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final List<String> interests;
  final String bio;

  const TestChatScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.interests,
    required this.bio,
  }) : super(key: key);

  @override
  _TestChatScreenState createState() => _TestChatScreenState();
}

class _TestChatScreenState extends State<TestChatScreen> {
  final RandomConnectionService _service = RandomConnectionService();
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isConnected = false;
  User? _matchedUser;

  @override
  void initState() {
    super.initState();
    _service.generateDummyData();
    _findMatch();
  }

  void _findMatch() {
    final currentUser = User(
      id: widget.userId,
      name: widget.userName,
      interests: widget.interests,
      bio: widget.bio,
      isOnline: true,
      lastActive: DateTime.now(),
      points: 1000,
    );

    final match = _service.findMatch(currentUser);
    setState(() {
      _matchedUser = match;
      _isConnected = true;
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        content: _messageController.text,
        isMe: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();

      // 상대방의 응답 시뮬레이션
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add(ChatMessage(
            content: '테스트 응답 메시지입니다.',
            isMe: false,
            timestamp: DateTime.now(),
          ));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}의 채팅'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _findMatch,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isConnected && _matchedUser != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(_matchedUser!.name[0]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _matchedUser!.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          _matchedUser!.bio ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: message.isMe
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color:
                            message.isMe ? Colors.white : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String content;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isMe,
    required this.timestamp,
  });
}
