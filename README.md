# ⏳ Clepsydra (클렙시드라)

---

## 🛠 주요 기술 스택

- **Frontend**: Flutter (Provider, Google Sign-In)
- **Backend**: NestJS (REST API)
- **Design**: Dark Mode Only (Elegant Dark Theme)

---

## ✨ 핵심 기능

- [x] **타임 블록 기반 타이머**: 시간을 블록 단위로 관리하여 몰입을 돕습니다.
- [x] **구글 로그인 연동**: 구글 계정으로 간편하게 시작할 수 있습니다.
- [x] **실시간 동기화**: 로그인 시 서버와 데이터를 동기화하고, 비로그인 시 로컬 저장소를 활용합니다.
- [ ] **통계 리포트**: (진행 예정) 내 몰입 시간을 시각화하여 확인합니다.

---

## 🚀 시작하기 (설정 방법)

보안을 위해 구글 로그인 설정 파일은 저장소에 포함되어 있지 않습니다. 프로젝트를 로컬에서 실행하려면 아래 파일들을 직접 추가해야 합니다.

### 1. 구글 로그인 설정 (Google Cloud Console)

1.  **Android**: `android/app/google-services.json` 파일 배치
2.  **iOS**: `ios/Runner/GoogleService-Info.plist` 파일 배치 및 Xcode에서 Target 등록
3.  **URL Scheme**: `ios/Runner/Info.plist`의 `CFBundleURLSchemes` 항목에 `REVERSED_CLIENT_ID` 등록

### 2. 패키지 설치 및 실행

```bash
flutter pub get
flutter run
```

---

## 🏗 프로젝트 구조

- `lib/services`: 비즈니스 로직 및 상태 관리 (Provider)
- `lib/repository`: 데이터 접근 계층 (Local/Remote 분기 처리)
- `lib/data`: 데이터 모델 및 데이터 소스 (API 통신)
- `lib/screens`: UI 화면 위젯

---

## 📜 라이선스

이 프로젝트는 개인 학습 및 프로토타입 용도로 제작되었습니다.
