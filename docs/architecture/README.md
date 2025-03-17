# 아키텍처 문서

## 개요
Labyrinth는 Clean Architecture 패턴을 따르는 Flutter 애플리케이션입니다.

## 아키텍처 계층
1. **Presentation Layer** (UI)
   - 화면 표시 및 사용자 입력 처리
   - BLoC 패턴을 사용한 상태 관리

2. **Domain Layer** (비즈니스 로직)
   - Use Cases
   - Entities
   - Repository Interfaces

3. **Data Layer** (데이터 처리)
   - Repository Implementations
   - Data Sources
   - DTOs

## 주요 컴포넌트
### BLoC (Business Logic Component)
- 상태 관리 및 비즈니스 로직 처리
- UI와 비즈니스 로직 분리

### Repository
- 데이터 접근 추상화
- 데이터 소스 관리

### Use Cases
- 단일 책임 원칙에 따른 비즈니스 로직 구현
- 재사용 가능한 독립적인 기능 단위

## 의존성 규칙
- 안쪽 계층은 바깥쪽 계층을 모르지 않음
- 의존성은 안쪽으로 향함
- 계층 간 통신은 인터페이스를 통해 이루어짐 