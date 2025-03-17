# 테스트 문서

## 개요
Labyrinth 애플리케이션의 테스트 전략 및 가이드라인을 설명합니다. 이 문서는 개발자들이 테스트를 작성하고 실행하는 데 필요한 모든 정보를 제공합니다.

## 테스트 계층

### 1. 단위 테스트 (Unit Tests)
- **개별 컴포넌트의 독립적인 테스트**
  - Use Cases
  - Repositories
  - BLoCs
  - 유틸리티 함수
  - 모델 클래스

- **테스트 위치**
  - `test/unit/` 디렉토리에 위치
  - 파일명은 `*_test.dart` 형식

- **테스트 구조**
  ```dart
  void main() {
    group('ComponentName', () {
      late Component component;
      
      setUp(() {
        // 테스트 설정
        component = Component();
      });
      
      tearDown(() {
        // 테스트 정리
      });
      
      test('should do something', () {
        // 테스트 로직
      });
    });
  }
  ```

### 2. 위젯 테스트 (Widget Tests)
- **UI 컴포넌트의 테스트**
  - 위젯 렌더링
  - 사용자 상호작용
  - 상태 변경
  - 네비게이션

- **테스트 위치**
  - `test/widget/` 디렉토리에 위치
  - 파일명은 `*_widget_test.dart` 형식

- **테스트 구조**
  ```dart
  void main() {
    testWidgets('WidgetName should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestedWidget(),
        ),
      );
      
      // 위젯 검증
      expect(find.byType(TestedWidget), findsOneWidget);
    });
  }
  ```

### 3. 통합 테스트 (Integration Tests)
- **여러 컴포넌트 간의 상호작용 테스트**
  - 전체 기능 흐름
  - 데이터 흐름
  - 상태 관리
  - 네비게이션 흐름

- **테스트 위치**
  - `test/integration/` 디렉토리에 위치
  - 파일명은 `*_integration_test.dart` 형식

- **테스트 구조**
  ```dart
  void main() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    
    testWidgets('Feature flow test', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      
      // 전체 기능 흐름 테스트
      await tester.tap(find.byKey(Key('start_button')));
      await tester.pumpAndSettle();
      
      // 결과 검증
      expect(find.text('Success'), findsOneWidget);
    });
  }
  ```

## 테스트 실행 방법

### 모든 테스트 실행
```bash
flutter test
```

### 특정 테스트 파일 실행
```bash
flutter test test/unit/maze_repository_test.dart
```

### 특정 테스트 그룹 실행
```bash
flutter test --name "MazeRepository"
```

### 테스트 커버리지 확인
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 테스트 예시

### 단위 테스트
```dart
void main() {
  group('MazeRepository', () {
    late IMazeRepository repository;
    late MockDatabase mockDatabase;
    
    setUp(() {
      mockDatabase = MockDatabase();
      repository = MazeRepository(mockDatabase);
    });
    
    test('should generate maze with correct dimensions', () async {
      final maze = await repository.generateMaze(10, 10);
      expect(maze.width, equals(10));
      expect(maze.height, equals(10));
    });
    
    test('should save maze to database', () async {
      final maze = Maze(
        id: 'test-id',
        width: 5,
        height: 5,
        cells: [],
        createdAt: DateTime.now(),
      );
      
      await repository.saveMaze(maze);
      verify(mockDatabase.insert('mazes', maze.toJson())).called(1);
    });
    
    test('should throw exception for invalid dimensions', () async {
      expect(
        () => repository.generateMaze(0, 0),
        throwsA(isA<MazeException>()),
      );
    });
  });
}
```

### 위젯 테스트
```dart
void main() {
  group('MazeWidget', () {
    testWidgets('should render maze cells correctly', (WidgetTester tester) async {
      final maze = Maze(
        id: 'test-id',
        width: 3,
        height: 3,
        cells: [
          [Cell.wall, Cell.wall, Cell.wall],
          [Cell.path, Cell.path, Cell.wall],
          [Cell.wall, Cell.wall, Cell.wall],
        ],
        createdAt: DateTime.now(),
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MazeWidget(maze: maze),
          ),
        ),
      );
      
      // 셀 검증
      expect(find.byType(MazeCell), findsNWidgets(9));
      expect(find.byType(WallCell), findsNWidgets(7));
      expect(find.byType(PathCell), findsNWidgets(2));
    });
    
    testWidgets('should handle cell tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MazeWidget(
              maze: testMaze,
              onCellTap: (x, y) {
                // 탭 핸들러 검증
              },
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(PathCell).first);
      await tester.pumpAndSettle();
      
      // 탭 결과 검증
    });
  });
}
```

### 통합 테스트
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Game Flow', () {
    testWidgets('should complete game flow', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      
      // 게임 시작
      await tester.tap(find.byKey(Key('start_button')));
      await tester.pumpAndSettle();
      
      // 미로 생성
      await tester.tap(find.byKey(Key('generate_button')));
      await tester.pumpAndSettle();
      
      // 미로 탐색
      await tester.drag(
        find.byType(Player),
        Offset(50, 50),
      );
      await tester.pumpAndSettle();
      
      // 게임 완료
      expect(find.text('Congratulations!'), findsOneWidget);
    });
  });
}
```

## 모킹 (Mocking)

### Mockito 사용
```dart
@GenerateMocks([IMazeRepository])
void main() {
  late MockIMazeRepository mockRepository;
  
  setUp(() {
    mockRepository = MockIMazeRepository();
  });
  
  test('should use mock repository', () {
    when(mockRepository.generateMaze(any, any))
        .thenAnswer((_) async => testMaze);
    
    // 테스트 로직
  });
}
```

### 테스트 데이터
```dart
final testMaze = Maze(
  id: 'test-id',
  width: 5,
  height: 5,
  cells: [
    [Cell.wall, Cell.wall, Cell.wall, Cell.wall, Cell.wall],
    [Cell.wall, Cell.path, Cell.path, Cell.path, Cell.wall],
    [Cell.wall, Cell.wall, Cell.wall, Cell.path, Cell.wall],
    [Cell.wall, Cell.path, Cell.path, Cell.path, Cell.wall],
    [Cell.wall, Cell.wall, Cell.wall, Cell.wall, Cell.wall],
  ],
  createdAt: DateTime.now(),
);
```

## CI/CD

### GitHub Actions 설정
```yaml
name: Flutter Tests

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          
      - name: Install dependencies
        run: flutter pub get
        
      - name: Run tests
        run: flutter test
        
      - name: Generate coverage
        run: |
          flutter test --coverage
          genhtml coverage/lcov.info -o coverage/html
          
      - name: Upload coverage
        uses: actions/upload-artifact@v2
        with:
          name: coverage
          path: coverage/html
```

### 테스트 자동화
- PR 생성 시 자동 테스트 실행
- 테스트 실패 시 배포 중단
- 커버리지 리포트 자동 생성
- 테스트 결과 알림

## 테스트 모범 사례

### 1. 테스트 격리
- 각 테스트는 독립적이어야 함
- 테스트 간 상태 공유 지양
- `setUp`과 `tearDown` 활용

### 2. 명확한 테스트 설명
- 테스트 이름은 동작을 명확히 설명
- Given-When-Then 패턴 사용
- 테스트 그룹화 활용

### 3. 적절한 검증
- 정확한 검증 포인트 선택
- 불필요한 검증 지양
- 예외 케이스 고려

### 4. 테스트 유지보수
- 테스트 코드 리팩토링
- 중복 코드 제거
- 테스트 헬퍼 함수 활용

### 5. 성능 고려
- 테스트 실행 시간 최적화
- 무거운 작업 최소화
- 비동기 작업 적절히 처리 