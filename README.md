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

```
medirelay_flutter/
├── 📄 pubspec.yaml
├── 📄 analysis_options.yaml
├── 📁 assets/
│   ├── 📁 images/
│   │   ├── medirelay_logo.svg
│   │   └── splash_logo.png
│   ├── 📁 icons/
│   ├── 📁 animations/
│   │   └── loading.json
│   ├── 📁 audio/
│   └── 📁 fonts/
│       └── Pretendard/
├── 📁 lib/
│   ├── 📄 main.dart
│   ├── 📁 core/
│   │   ├── 📁 constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── api_constants.dart
│   │   │   └── asset_constants.dart
│   │   ├── 📁 errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── 📁 network/
│   │   │   ├── dio_client.dart
│   │   │   └── network_info.dart
│   │   ├── 📁 utils/
│   │   │   ├── logger.dart
│   │   │   ├── validators.dart
│   │   │   └── date_utils.dart
│   │   ├── 📁 theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   └── app_decorations.dart
│   │   └── 📁 services/
│   │       ├── storage_service.dart
│   │       ├── permission_service.dart
│   │       └── notification_service.dart
│   ├── 📁 features/
│   │   ├── 📁 auth/
│   │   │   ├── 📁 data/
│   │   │   │   ├── 📁 datasources/
│   │   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   ├── 📁 models/
│   │   │   │   │   ├── user_model.dart
│   │   │   │   │   └── login_request_model.dart
│   │   │   │   └── 📁 repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── 📁 domain/
│   │   │   │   ├── 📁 entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── 📁 repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── 📁 usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       └── logout_usecase.dart
│   │   │   └── 📁 presentation/
│   │   │       ├── 📁 bloc/
│   │   │       │   ├── auth_bloc.dart
│   │   │       │   ├── auth_event.dart
│   │   │       │   └── auth_state.dart
│   │   │       ├── 📁 pages/
│   │   │       │   ├── landing_page.dart
│   │   │       │   └── login_page.dart
│   │   │       └── 📁 widgets/
│   │   │           ├── login_form.dart
│   │   │           └── demo_account_selector.dart
│   │   ├── 📁 patients/
│   │   │   ├── 📁 data/
│   │   │   ├── 📁 domain/
│   │   │   └── 📁 presentation/
│   │   ├── 📁 voice_recording/
│   │   │   ├── 📁 data/
│   │   │   │   ├── 📁 datasources/
│   │   │   │   │   ├── voice_local_datasource.dart
│   │   │   │   │   └── voice_remote_datasource.dart
│   │   │   │   ├── 📁 models/
│   │   │   │   │   └── voice_record_model.dart
│   │   │   │   └── 📁 repositories/
│   │   │   │       └── voice_repository_impl.dart
│   │   │   ├── 📁 domain/
│   │   │   │   ├── 📁 entities/
│   │   │   │   │   └── voice_record.dart
│   │   │   │   ├── 📁 repositories/
│   │   │   │   │   └── voice_repository.dart
│   │   │   │   └── 📁 usecases/
│   │   │   │       ├── start_recording_usecase.dart
│   │   │   │       ├── stop_recording_usecase.dart
│   │   │   │       └── transcribe_audio_usecase.dart
│   │   │   └── 📁 presentation/
│   │   │       ├── 📁 bloc/
│   │   │       │   ├── voice_recording_bloc.dart
│   │   │       │   ├── voice_recording_event.dart
│   │   │       │   └── voice_recording_state.dart
│   │   │       ├── 📁 pages/
│   │   │       │   └── voice_recording_page.dart
│   │   │       └── 📁 widgets/
│   │   │           ├── recording_button.dart
│   │   │           ├── audio_visualizer.dart
│   │   │           └── transcription_display.dart
│   │   ├── 📁 nursing_records/
│   │   │   ├── 📁 data/
│   │   │   ├── 📁 domain/
│   │   │   └── 📁 presentation/
│   │   ├── 📁 handover/
│   │   │   ├── 📁 data/
│   │   │   ├── 📁 domain/
│   │   │   └── 📁 presentation/
│   │   └── 📁 chat/
│   │       ├── 📁 data/
│   │       ├── 📁 domain/
│   │       └── 📁 presentation/
│   ├── 📁 shared/
│   │   ├── 📁 widgets/
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── loading_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   ├── patient_card.dart
│   │   │   └── custom_button.dart
│   │   ├── 📁 extensions/
│   │   │   ├── context_extension.dart
│   │   │   ├── string_extension.dart
│   │   │   └── datetime_extension.dart
│   │   └── 📁 mixins/
│   │       ├── validation_mixin.dart
│   │       └── loading_mixin.dart
│   ├── 📄 app.dart
│   └── 📄 injection_container.dart
├── 📁 test/
│   ├── 📁 unit/
│   ├── 📁 widget/
│   └── 📁 integration/
└── 📁 ios/
    └── 📁 android/



