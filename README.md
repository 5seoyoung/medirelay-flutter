# medirelay-flutter
AI-based Next-Generation Nursing Record System – Flutter Version

# 🏥 MediRelay Flutter

> AI 기반 차세대 간호기록 시스템 - Flutter 모바일 앱

## 📱 프로젝트 개요

MediRelay는 음성 인식과 AI를 활용하여 간호사의 업무 효율성을 높이는 혁신적인 간호기록 시스템입니다.

### 🎯 주요 기능
- 🎙️ **음성 차팅**: 말하면 자동으로 간호기록 작성
- 🤖 **AI 분류**: 자동 기록 분류 및 구조화
- 📝 **인계장 생성**: AI 기반 자동 인계장 작성
- 💬 **스마트 질의응답**: 자연어 기반 기록 검색

## 기술 스택

- **Framework**: Flutter 3.16+
- **Language**: Dart 3.0+
- **State Management**: Flutter Bloc
- **Audio**: speech_to_text, record
- **AI Integration**: OpenAI API
- **Database**: SQLite (local), PostgreSQL (server)

## 시작하기

### 필수 요구사항
- Flutter SDK 3.16.0 이상
- Dart 3.0.0 이상
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### 설치 및 실행
\`\`\`bash
# 레포지토리 클론
git clone https://github.com/5seoyoung/medirelay-flutter.git
cd medirelay-flutter

# 의존성 설치
flutter pub get

# 앱 실행
flutter run
\`\`\`

## 프로젝트 구조

\`\`\`
lib/
├── core/           # 핵심 유틸리티 및 서비스
├── features/       # 기능별 모듈 (Clean Architecture)
├── shared/         # 공통 위젯 및 유틸리티
└── main.dart       # 앱 진입점
\`\`\`


## 📄 라이센스

이 프로젝트는 [MIT 라이센스](LICENSE) 하에 있습니다.

