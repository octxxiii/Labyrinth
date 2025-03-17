# Labyrinth 프로젝트 문서

## 프로젝트 개요
Labyrinth는 Flutter를 사용하여 개발된 미로 게임 애플리케이션입니다.

## 디렉토리 구조
```
labyrinth/
├── lib/           # 소스 코드
├── test/          # 테스트 코드
├── assets/        # 이미지, 폰트 등 리소스
├── android/       # Android 플랫폼 관련 파일
├── ios/          # iOS 플랫폼 관련 파일
├── web/          # 웹 플랫폼 관련 파일
├── windows/      # Windows 플랫폼 관련 파일
├── macos/        # macOS 플랫폼 관련 파일
└── linux/        # Linux 플랫폼 관련 파일
```

## 개발 환경 설정
1. Flutter SDK 설치
2. 프로젝트 의존성 설치:
   ```bash
   flutter pub get
   ```
3. 개발 서버 실행:
   ```bash
   flutter run
   ```

## 문서 목록
- [아키텍처 문서](./architecture/README.md)
- [API 문서](./api/README.md)
- [테스트 문서](./testing/README.md) 