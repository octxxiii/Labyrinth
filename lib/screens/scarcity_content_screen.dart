import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../models/scarcity_content.dart';
import '../services/scarcity_content_service.dart';

class ScarcityContentScreen extends StatefulWidget {
  const ScarcityContentScreen({super.key});

  @override
  _ScarcityContentScreenState createState() => _ScarcityContentScreenState();
}

class _ScarcityContentScreenState extends State<ScarcityContentScreen> {
  final ScarcityContentService _service = ScarcityContentService();
  List<ScarcityContent> _contents = [];
  String _selectedCategory = '전체';
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadContents();
    _startRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadContents();
    });
  }

  void _loadContents() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      _service.generateDummyData();
      setState(() {
        _contents = _selectedCategory == '전체'
            ? _service.getAvailableContents()
            : _service.getContentsByCategory(_selectedCategory);
        _isLoading = false;
      });
    });
  }

  void _viewContent(ScarcityContent content) {
    _service.viewContent(content.id);
    setState(() {
      final index = _contents.indexWhere((c) => c.id == content.id);
      if (index != -1) {
        _contents[index] = content.copyWith(
          currentViews: content.currentViews + 1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('희귀 콘텐츠'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadContents,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _service.getCategories().length + 1,
              itemBuilder: (context, index) {
                final category =
                    index == 0 ? '전체' : _service.getCategories()[index - 1];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        _loadContents();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _contents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.hourglass_empty,
                              size: 64,
                              color: AppTheme.textSecondaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '현재 이용 가능한 콘텐츠가 없습니다.',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '잠시 후 다시 확인해주세요.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _contents.length,
                        itemBuilder: (context, index) {
                          final content = _contents[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () => _viewContent(content),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          content.category,
                                          style: const TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${content.currentViews}/${content.maxViews}',
                                            style: const TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      content.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      content.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    LinearProgressIndicator(
                                      value: content.viewProgress,
                                      backgroundColor: AppTheme.primaryColor
                                          .withOpacity(0.1),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        AppTheme.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '남은 시간: ${content.remainingTime.inHours}시간 ${content.remainingTime.inMinutes % 60}분',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          '${content.isExclusive ? '독점' : '일반'} 콘텐츠',
                                          style: TextStyle(
                                            color: content.isExclusive
                                                ? AppTheme.primaryColor
                                                : AppTheme.textSecondaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
