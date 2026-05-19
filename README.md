# UYOUNG

UYOUNG는 소중한 사람들과 함께 추억을 기록하고, 초대 링크로 같은 공간에 모여 기억을 공유하는 Flutter 기반 모바일 앱입니다.  
출석 체크, 알림, 기억섬 생성 및 초대, 날짜 기반 캘린더 탐색, 친구/프로필 관리까지 하나의 흐름으로 연결되어 있습니다.

이 문서는 이력서·포트폴리오 제출을 염두에 두고, 프로젝트의 목적과 구현 범위를 빠르게 파악할 수 있도록 정리했습니다.

## 한눈에 보기

- **플랫폼**: Flutter iOS / Android
- **언어**: Dart
- **상태관리**: `provider` + `ChangeNotifier`
- **백엔드**: `Supabase`
- **주요 연동**:
  - `Supabase Auth` 기반 소셜 로그인
  - 사용자별 출석/알림/기억섬 데이터 조회
  - 기억섬 초대 링크 및 딥링크 진입
  - 이미지 선택 및 배경 업로드
  - 캘린더 기반 추억 탐색

## 프로젝트 목표

단순 사진 저장 앱이 아니라, 사람 중심의 “공유형 추억 공간”을 만드는 것이 핵심 목표입니다.

- 홈에서 오늘의 상태를 확인하고 출석 보상을 받기
- 친구 또는 그룹 단위로 **기억섬**을 만들고 초대하기
- 기억섬 안에서 사진과 추억을 탐색하기
- **캘린더**에서 날짜별로 기록을 다시 보기
- 마이페이지에서 친구, 알림, 문의, 프로필을 관리하기

## 주요 기능

### 1. 인증 / 앱 진입

- `Supabase OAuth` 기반 소셜 로그인
- 인증 상태에 따른 진입 분기
- 프로필 설정 필요 여부 확인
- 초대 링크 진입 시 특정 기억섬으로 연결

관련 파일:
- [main.dart](/Users/choseoungeun/dev/UYOUNG/lib/main.dart)
- [app.dart](/Users/choseoungeun/dev/UYOUNG/lib/app.dart)
- [auth_view_model.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/viewModel/auth/auth_view_model.dart)
- [login_main_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/login/login_main_page.dart)

### 2. 홈

- 메인 캐릭터 중심 홈 화면
- 출석 체크 진입
- 진주 보유량 확인
- 알림 화면 이동 및 읽음 처리

관련 파일:
- [home_main.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/home/home_main.dart)
- [notification_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/home/notification_page.dart)
- [notification_view_model.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/viewModel/home/notification_view_model.dart)
- [pearl_view_model.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/viewModel/home/pearl_view_model.dart)

### 3. 출석 체크

- 출석 진입 → 보상 공개 → 보드 확인의 단계형 흐름
- `RPC` 호출 기반 출석 체크 처리
- 출석 로그 및 보상 아이템 표시

관련 파일:
- [attend_check_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/attendance/attend_check_page.dart)
- [attendance_view_model.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/viewModel/attendance/attendance_view_model.dart)
- [attendance_repository.dart](/Users/choseoungeun/dev/UYOUNG/lib/data/repositories/attendance/attendance_repository.dart)

### 4. 기억섬

- 기억섬 목록 조회
- 기억섬 생성
- 멤버 초대 및 초대코드 입장
- 상세 화면, 타임라인, 날짜별/앨범 형태 탐색
- 즐겨찾기, 알림 설정, 섬 이름 변경, 나가기

관련 파일:
- [memory_main_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/memory/memory_main_page.dart)
- [memory_detail_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/memory/memory_detail_page.dart)
- [timeline_memory_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/memory/timeline_memory_page.dart)
- [select_member_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/memory/select_member_page.dart)
- [memory_view_model.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/viewModel/memory/memeory_view_model.dart)
- [memory_repository.dart](/Users/choseoungeun/dev/UYOUNG/lib/data/repositories/memory/memory_repository.dart)

### 5. 캘린더

- 월 단위 기억 탐색
- 날짜별 추억 요약
- 선택 날짜 바텀시트 및 상세 흐름
- 기억섬별 필터링

관련 파일:
- [calendar_main_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/calendar/calendar_main_page.dart)
- [calendar_view_model.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/viewModel/calendar/calendar_view_model.dart)

### 6. 마이페이지

- 프로필/진주/친구/공지/문의 내역 관리
- 친구 프로필 조회 및 삭제
- 초대 코드 복사 및 친구 초대
- 로그아웃

관련 파일:
- [mypage_main_screen.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/mypage/presentation/mypage_main_screen.dart)
- [friend_profile_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/mypage/presentation/friend_profile_page.dart)
- [pearl_charge_page.dart](/Users/choseoungeun/dev/UYOUNG/lib/src/view/pages/mypage/presentation/pearl_charge_page.dart)

## 주요 화면

이력서 또는 포트폴리오 제출용으로는 아래 6장 정도를 선별해서 넣는 구성이 가장 깔끔합니다.

- 로그인
- 홈
- 출석 체크
- 기억섬
- 캘린더
- 마이페이지

스크린샷 파일은 `docs/screenshots/`에 아래 이름으로 두는 것을 추천합니다.

- `login.png`
- `home.png`
- `attendance.png`
- `memory.png`
- `calendar.png`
- `mypage.png`

README에는 아래 형식으로 바로 연결할 수 있습니다.

```md
## 주요 화면

| 로그인 | 홈 |
| --- | --- |
| ![로그인](docs/screenshots/login.png) | ![홈](docs/screenshots/home.png) |

| 출석 체크 | 기억섬 |
| --- | --- |
| ![출석 체크](docs/screenshots/attendance.png) | ![기억섬](docs/screenshots/memory.png) |

| 캘린더 | 마이페이지 |
| --- | --- |
| ![캘린더](docs/screenshots/calendar.png) | ![마이페이지](docs/screenshots/mypage.png) |
```

제출용으로는 각 화면에 아래 포인트가 잘 보이도록 캡처하는 것을 추천합니다.

- 로그인: 소셜 로그인 진입 구조
- 홈: 캐릭터 메인, 출석체크, 알림/진주 UI
- 출석 체크: 단계형 보상 흐름 또는 출석 보드
- 기억섬: 목록 또는 상세 탭 구조
- 캘린더: 날짜 선택과 기억 탐색 구조
- 마이페이지: 친구/공지/문의/프로필 관리 구조

## 기술 스택

- **Flutter / Dart**
- **Provider**
- **Supabase**
  - Auth
  - Database
  - RPC
  - Storage
- **app_links**
- **google_maps_flutter**
- **image_picker / file_picker**
- **table_calendar**
- **shared_preferences**
- **intl**

## 아키텍처

이 프로젝트는 `provider + ChangeNotifier`를 사용하는 레이어드 구조입니다.

```text
lib/
├── app.dart
├── data/
│   ├── model/
│   ├── repositories/
│   └── sources/
├── src/
│   └── view/
│       ├── common/
│       └── pages/
└── viewModel/
```

흐름:

1. `View`가 사용자 입력을 받음
2. `ViewModel`이 상태를 관리함
3. `Repository`가 비즈니스 흐름을 중개함
4. `Source / Supabase service`가 실제 데이터 입출력을 담당함

장점:
- 화면 로직과 데이터 로직이 분리되어 유지보수가 쉬움
- Supabase 연동 로직을 UI에서 직접 다루지 않음
- 화면 단위 테스트/교체가 비교적 쉬움

## 구현 포인트

이 프로젝트에서 기술적으로 눈여겨볼 만한 부분은 아래와 같습니다.

- **딥링크 기반 기억섬 초대 흐름**
  - 앱이 꺼져 있거나 로그인 전 상태에서도 초대 링크를 받아 흐름을 이어갈 수 있도록 구성
- **출석 체크 RPC 처리**
  - 단순 로컬 상태가 아니라 서버 기반 보상 지급 흐름으로 연결
- **기억섬 중심 데이터 모델링**
  - 섬, 멤버, 초대, 즐겨찾기, 알림 설정 등 사용자별 관계 데이터를 다룸
- **캘린더 기반 탐색 UX**
  - 날짜 선택 → 기억 요약 → 상세 보기로 이어지는 구조
- **이미지 업로드 및 Storage 연동**
  - 기억섬 배경 등 이미지 자산을 서버 스토리지에 업로드

## 실행 방법

### 1. 패키지 설치

```bash
flutter pub get
```

### 2. 앱 실행

```bash
flutter run
```

### 3. 환경값 주입

현재 프로젝트는 `String.fromEnvironment` 기반으로 Supabase 값을 받을 수 있습니다.

```bash
flutter run \
  --dart-define=SUPABASE_URL=YOUR_SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY \
  --dart-define=MEMORY_INVITE_BASE_URL=https://momenture.app/invite
```

관련 파일:
- [supabase_config.dart](/Users/choseoungeun/dev/UYOUNG/lib/data/sources/supabase/supabase_config.dart)

## 에셋 및 폰트

- 이미지 에셋: `assets/images/`
- 출석 에셋: `assets/images/attendance/...`
- 기억섬 에셋: `assets/images/memory/...`
- 마이페이지 에셋: `assets/images/mypage/`
- 폰트:
  - `memomentKkukkkuk`
  - `PretendardStatic`
  - `PretendardVariable`

## 프로젝트에서 보여줄 수 있는 역량

이 프로젝트는 아래 역량을 보여주기에 적합합니다.

- Flutter 기반 **중대형 화면 구조 설계 및 유지보수**
- `Provider` 중심 상태관리
- Supabase 인증/DB/Storage/RPC 연동 경험
- 딥링크 및 인증 게이트 흐름 설계
- 이미지 중심 모바일 UI 구현
- 기능별 화면 흐름을 끊기지 않게 연결하는 내비게이션 설계

## 참고

- 일부 화면은 실제 Supabase 데이터와 로컬/더미 데이터가 혼합되어 있을 수 있습니다.
- 이는 개발 단계에서 UI/흐름 검증과 서버 연동을 병행하기 위한 구조이며, 리팩터링 시 데이터 소스를 더 명확히 분리할 수 있습니다.
