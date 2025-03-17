import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  final LeaderboardService _service = LeaderboardService();
  List<User> _users = [];
  String _selectedCategory = '전체';
  bool _isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadLeaderboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadLeaderboard() {
    setState(() {
      _isLoading = true;
    });

    // 실제로는 서버에서 데이터를 가져오는 로직이 들어갈 자리
    Future.delayed(const Duration(seconds: 1), () {
      _service.generateDummyData(); // 테스트용 더미 데이터 생성
      setState(() {
        _users = _service.getLeaderboard(category: _selectedCategory);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리더보드'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '주간'),
            Tab(text: '월간'),
            Tab(text: '카테고리별'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboard,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWeeklyLeaderboard(),
          _buildMonthlyLeaderboard(),
          _buildCategoryLeaderboard(),
        ],
      ),
    );
  }

  Widget _buildWeeklyLeaderboard() {
    return _buildLeaderboardList(_service.getWeeklyTopUsers());
  }

  Widget _buildMonthlyLeaderboard() {
    return _buildLeaderboardList(_service.getMonthlyTopUsers());
  }

  Widget _buildCategoryLeaderboard() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _service.getCategories().length,
            itemBuilder: (context, index) {
              final category = _service.getCategories()[index];
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                      _loadLeaderboard();
                    });
                  },
                ),
              );
            },
          ),
        ),
        Expanded(
          child: _buildLeaderboardList(
            _service.getCategoryTopUsers(_selectedCategory),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList(List<User> users) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(user.name[0]),
            ),
            title: Text(user.name),
            subtitle: Text(user.bio ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${user.points}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onTap: () {
              // 사용자 프로필 화면으로 이동하는 로직이 들어갈 자리
            },
          ),
        );
      },
    );
  }
}
