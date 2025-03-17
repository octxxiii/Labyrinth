# 테스트 문서

## 개요
Labyrinth 애플리케이션의 테스트 전략 및 가이드라인을 설명합니다.

## 테스트 계층

### 1. 단위 테스트 (Unit Tests)
- 개별 컴포넌트의 독립적인 테스트
- Use Cases, Repositories, BLoCs 등에 대한 테스트
- `test/unit/` 디렉토리에 위치

### 2. 위젯 테스트 (Widget Tests)
- UI 컴포넌트의 테스트
- 위젯 렌더링 및 상호작용 테스트
- `test/widget/` 디렉토리에 위치

### 3. 통합 테스트 (Integration Tests)
- 여러 컴포넌트 간의 상호작용 테스트
- 전체 기능 흐름 테스트
- `test/integration/` 디렉토리에 위치

## 테스트 실행 방법

### 모든 테스트 실행
```bash
flutter test
```

### 특정 테스트 파일 실행
```bash
flutter test test/unit/maze_repository_test.dart
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
    
    setUp(() {
      repository = MazeRepository();
    });
    
    test('should generate maze with correct dimensions', () async {
      final maze = await repository.generateMaze(10, 10);
      expect(maze.width, equals(10));
      expect(maze.height, equals(10));
    });
  });
}
```

### 위젯 테스트
```dart
void main() {
  testWidgets('MazeWidget should render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MazeWidget(maze: testMaze),
    ));
    
    expect(find.byType(MazeCell), findsNWidgets(100));
  });
}
```

## 모킹 (Mocking)
- `mockito` 패키지를 사용하여 의존성 모킹
- 테스트에서 외부 의존성 격리

## CI/CD
- GitHub Actions를 통한 자동화된 테스트 실행
- PR 생성 시 자동 테스트 실행
- 테스트 실패 시 배포 중단 