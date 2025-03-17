# API 문서

## 개요
Labyrinth 애플리케이션의 주요 API 및 인터페이스에 대한 문서입니다. 이 문서는 애플리케이션의 핵심 기능과 데이터 구조를 설명합니다.

## Repository 인터페이스

### IMazeRepository
```dart
abstract class IMazeRepository {
  /// 새로운 미로를 생성합니다.
  /// 
  /// [width] 미로의 너비
  /// [height] 미로의 높이
  /// 
  /// 생성된 미로를 반환합니다.
  Future<Maze> generateMaze(int width, int height);

  /// 사용자의 미로 생성 기록을 조회합니다.
  /// 
  /// 생성된 미로 목록을 반환합니다.
  Future<List<Maze>> getMazeHistory();

  /// 미로를 저장합니다.
  /// 
  /// [maze] 저장할 미로 객체
  Future<void> saveMaze(Maze maze);

  /// 특정 ID의 미로를 조회합니다.
  /// 
  /// [id] 미로 ID
  /// 
  /// 해당 ID의 미로를 반환합니다.
  Future<Maze?> getMazeById(String id);

  /// 미로의 난이도를 설정합니다.
  /// 
  /// [mazeId] 미로 ID
  /// [difficulty] 난이도 (1-5)
  Future<void> setMazeDifficulty(String mazeId, int difficulty);
}
```

### IUserRepository
```dart
abstract class IUserRepository {
  /// 사용자 정보를 조회합니다.
  /// 
  /// [userId] 사용자 ID
  /// 
  /// 사용자 정보를 반환합니다.
  Future<User> getUser(String userId);

  /// 사용자의 점수를 업데이트합니다.
  /// 
  /// [userId] 사용자 ID
  /// [score] 새로운 점수
  Future<void> updateUserScore(String userId, int score);

  /// 리더보드를 조회합니다.
  /// 
  /// [limit] 조회할 상위 사용자 수 (기본값: 10)
  /// 
  /// 상위 사용자 목록을 반환합니다.
  Future<List<User>> getLeaderboard({int limit = 10});

  /// 사용자의 게임 통계를 조회합니다.
  /// 
  /// [userId] 사용자 ID
  /// 
  /// 사용자의 게임 통계를 반환합니다.
  Future<UserStats> getUserStats(String userId);

  /// 사용자의 업적을 업데이트합니다.
  /// 
  /// [userId] 사용자 ID
  /// [achievement] 달성한 업적
  Future<void> updateAchievement(String userId, Achievement achievement);
}
```

## Use Cases

### GenerateMazeUseCase
```dart
class GenerateMazeUseCase {
  final IMazeRepository mazeRepository;
  
  GenerateMazeUseCase(this.mazeRepository);
  
  /// 새로운 미로를 생성합니다.
  /// 
  /// [width] 미로의 너비
  /// [height] 미로의 높이
  /// [difficulty] 미로의 난이도 (1-5)
  /// 
  /// 생성된 미로를 반환합니다.
  Future<Maze> execute({
    required int width,
    required int height,
    int difficulty = 3,
  }) async {
    final maze = await mazeRepository.generateMaze(width, height);
    await mazeRepository.setMazeDifficulty(maze.id, difficulty);
    return maze;
  }
}
```

### UpdateScoreUseCase
```dart
class UpdateScoreUseCase {
  final IUserRepository userRepository;
  
  UpdateScoreUseCase(this.userRepository);
  
  /// 사용자의 점수를 업데이트하고 업적을 확인합니다.
  /// 
  /// [userId] 사용자 ID
  /// [score] 새로운 점수
  /// [mazeId] 점수를 획득한 미로 ID
  Future<void> execute({
    required String userId,
    required int score,
    required String mazeId,
  }) async {
    await userRepository.updateUserScore(userId, score);
    
    // 업적 확인
    final stats = await userRepository.getUserStats(userId);
    if (stats.totalScore >= 1000) {
      await userRepository.updateAchievement(
        userId,
        Achievement(
          id: 'score_master',
          title: '점수 마스터',
          description: '총 1000점 달성',
          unlockedAt: DateTime.now(),
        ),
      );
    }
  }
}
```

## BLoC

### MazeBloc
```dart
class MazeBloc extends Bloc<MazeEvent, MazeState> {
  final GenerateMazeUseCase generateMazeUseCase;
  final IMazeRepository mazeRepository;
  
  MazeBloc({
    required this.generateMazeUseCase,
    required this.mazeRepository,
  }) : super(MazeInitial()) {
    on<GenerateMazeRequested>(_onGenerateMazeRequested);
    on<SaveMazeRequested>(_onSaveMazeRequested);
    on<LoadMazeHistoryRequested>(_onLoadMazeHistoryRequested);
  }

  Future<void> _onGenerateMazeRequested(
    GenerateMazeRequested event,
    Emitter<MazeState> emit,
  ) async {
    try {
      emit(MazeLoading());
      final maze = await generateMazeUseCase.execute(
        width: event.width,
        height: event.height,
        difficulty: event.difficulty,
      );
      emit(MazeGenerated(maze));
    } catch (e) {
      emit(MazeError(e.toString()));
    }
  }

  // ... 다른 이벤트 핸들러 구현
}
```

### UserBloc
```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final UpdateScoreUseCase updateScoreUseCase;
  final IUserRepository userRepository;
  
  UserBloc({
    required this.updateScoreUseCase,
    required this.userRepository,
  }) : super(UserInitial()) {
    on<UpdateScoreRequested>(_onUpdateScoreRequested);
    on<LoadLeaderboardRequested>(_onLoadLeaderboardRequested);
    on<LoadUserStatsRequested>(_onLoadUserStatsRequested);
  }

  Future<void> _onUpdateScoreRequested(
    UpdateScoreRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await updateScoreUseCase.execute(
        userId: event.userId,
        score: event.score,
        mazeId: event.mazeId,
      );
      final updatedUser = await userRepository.getUser(event.userId);
      emit(UserUpdated(updatedUser));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // ... 다른 이벤트 핸들러 구현
}
```

## 모델

### Maze
```dart
class Maze {
  final String id;
  final int width;
  final int height;
  final List<List<Cell>> cells;
  final DateTime createdAt;
  final int difficulty;
  final MazeType type;
  final Map<String, dynamic> metadata;

  Maze({
    required this.id,
    required this.width,
    required this.height,
    required this.cells,
    required this.createdAt,
    this.difficulty = 3,
    this.type = MazeType.classic,
    this.metadata = const {},
  });

  // JSON 직렬화/역직렬화 메서드
  factory Maze.fromJson(Map<String, dynamic> json) {
    return Maze(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      cells: (json['cells'] as List)
          .map((row) => (row as List)
              .map((cell) => Cell.fromJson(cell))
              .toList())
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      difficulty: json['difficulty'] ?? 3,
      type: MazeType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MazeType.classic,
      ),
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'cells': cells.map((row) => row.map((cell) => cell.toJson()).toList()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'difficulty': difficulty,
      'type': type.toString(),
      'metadata': metadata,
    };
  }
}
```

### User
```dart
class User {
  final String id;
  final String name;
  final int score;
  final DateTime lastPlayed;
  final List<Achievement> achievements;
  final UserStats stats;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.name,
    required this.score,
    required this.lastPlayed,
    this.achievements = const [],
    required this.stats,
    this.preferences = const UserPreferences(),
  });

  // JSON 직렬화/역직렬화 메서드
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      score: json['score'],
      lastPlayed: DateTime.parse(json['lastPlayed']),
      achievements: (json['achievements'] as List?)
          ?.map((a) => Achievement.fromJson(a))
          .toList() ?? [],
      stats: UserStats.fromJson(json['stats']),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'lastPlayed': lastPlayed.toIso8601String(),
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'stats': stats.toJson(),
      'preferences': preferences.toJson(),
    };
  }
}
```

## 에러 처리

### MazeException
```dart
class MazeException implements Exception {
  final String message;
  final String code;
  final dynamic details;

  MazeException({
    required this.message,
    required this.code,
    this.details,
  });

  @override
  String toString() => 'MazeException: $code - $message';
}
```

### UserException
```dart
class UserException implements Exception {
  final String message;
  final String code;
  final dynamic details;

  UserException({
    required this.message,
    required this.code,
    this.details,
  });

  @override
  String toString() => 'UserException: $code - $message';
}
``` 