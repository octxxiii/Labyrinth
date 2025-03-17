# API 문서

## 개요
Labyrinth 애플리케이션의 주요 API 및 인터페이스에 대한 문서입니다.

## Repository 인터페이스

### IMazeRepository
```dart
abstract class IMazeRepository {
  Future<Maze> generateMaze(int width, int height);
  Future<List<Maze>> getMazeHistory();
  Future<void> saveMaze(Maze maze);
}
```

### IUserRepository
```dart
abstract class IUserRepository {
  Future<User> getUser(String userId);
  Future<void> updateUserScore(String userId, int score);
  Future<List<User>> getLeaderboard();
}
```

## Use Cases

### GenerateMazeUseCase
```dart
class GenerateMazeUseCase {
  final IMazeRepository mazeRepository;
  
  Future<Maze> execute(int width, int height) {
    return mazeRepository.generateMaze(width, height);
  }
}
```

### UpdateScoreUseCase
```dart
class UpdateScoreUseCase {
  final IUserRepository userRepository;
  
  Future<void> execute(String userId, int score) {
    return userRepository.updateUserScore(userId, score);
  }
}
```

## BLoC

### MazeBloc
```dart
class MazeBloc extends Bloc<MazeEvent, MazeState> {
  final GenerateMazeUseCase generateMazeUseCase;
  
  // 이벤트 처리 및 상태 관리
}
```

### UserBloc
```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  final UpdateScoreUseCase updateScoreUseCase;
  
  // 이벤트 처리 및 상태 관리
}
```

## 모델

### Maze
```dart
class Maze {
  final int width;
  final int height;
  final List<List<Cell>> cells;
  final DateTime createdAt;
  
  // 생성자 및 메서드
}
```

### User
```dart
class User {
  final String id;
  final String name;
  final int score;
  final DateTime lastPlayed;
  
  // 생성자 및 메서드
}
``` 