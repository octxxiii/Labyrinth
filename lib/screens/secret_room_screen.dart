import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/secret_message.dart';
import '../services/secret_room_service.dart';

class SecretRoomScreen extends StatefulWidget {
  const SecretRoomScreen({super.key});

  @override
  _SecretRoomScreenState createState() => _SecretRoomScreenState();
}

class _SecretRoomScreenState extends State<SecretRoomScreen> {
  final SecretRoomService _service = SecretRoomService();
  final TextEditingController _messageController = TextEditingController();
  List<SecretMessage> _messages = [];
  final List<String> _selectedTags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      _service.generateDummyData();
      setState(() {
        _messages = _service.getMessages();
        _isLoading = false;
      });
    });
  }

  void _submitMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = SecretMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _messageController.text,
      createdAt: DateTime.now(),
      likes: 0,
      tags: _selectedTags,
    );

    setState(() {
      _messages.insert(0, message);
    });

    _messageController.clear();
    _selectedTags.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('메시지가 공유되었습니다.'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _likeMessage(String messageId) {
    setState(() {
      final message = _messages.firstWhere((m) => m.id == messageId);
      message.likes++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀의 방'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '태그 선택',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _service.getAvailableTags().map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) => _toggleTag(tag),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: '당신의 이야기를 공유하세요',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _submitMessage,
                  icon: const Icon(Icons.send),
                  color: AppTheme.primaryColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.content,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: message.tags.map((tag) {
                                  return Chip(
                                    label: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                    backgroundColor:
                                        AppTheme.primaryColor.withOpacity(0.1),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.favorite_border,
                                          color: AppTheme.primaryColor,
                                        ),
                                        onPressed: () =>
                                            _likeMessage(message.id),
                                      ),
                                      Text(
                                        '${message.likes}',
                                        style: const TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
