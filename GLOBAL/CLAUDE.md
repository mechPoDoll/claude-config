# Global Rules

## Figma 작업 워크플로우
Figma 디자인을 코드로 구현할 때 반드시 다음 순서를 따를 것:

1. 화면 스크린샷 + Description 확인 — get_screenshot, get_design_context 등으로 디자인 의도를 파악
2. 현재 코드와 차이점 정리 — 기존 코드를 읽고, 디자인과 달라지는 부분을 명확히 정리하여 사용자에게 공유
3. 이해 안 되는 부분은 먼저 질문 — 추측으로 작업하지 말고, 불명확한 부분은 반드시 사용자에게 확인
4. 100% 이해 후 작업 시작 — 위 단계를 모두 완료한 뒤에만 코드 수정 시작

## SFTP 설정 규칙
프로젝트에 `.vscode/sftp.json`을 생성하거나 수정할 때, 반드시 `ignore` 항목을 포함할 것:
```json
"ignore": [
    ".vscode",
    ".git",
    ".DS_Store",
    "node_modules",
    "vendor",
    "log",
    "sessions",
    ".env",
    "*.log",
    ".cache",
    "tmp",
    "img",
    "data"
]
```
프로젝트 특성에 따라 항목을 추가/조정하되, 위 목록을 기본 베이스로 사용할 것.

## 공통 상태 아이콘 규칙
모든 문서(QA, SKILL, index 등)에서 진행 상태를 표시할 때 아래 아이콘을 통일하여 사용할 것:

| 아이콘 | 상태 | 조건 |
|--------|------|------|
| ✅ | 완료 | 100% 완료 |
| 🔄 | 진행중 | 작업 중이거나 리뷰 중 |
| ❌ | 실패 | 실패 항목 존재, 수정 대기 |
| ⬜ | 대기 | 미착수 |

## 금지 사항 체크리스트 (모든 프로젝트 공통)

- [ ] 사용자 입력을 SQL 문자열에 직접 삽입
- [ ] 출력 시 이스케이프 없이 사용자 데이터 렌더링
- [ ] CSRF 토큰 없는 상태 변경 요청
- [ ] 인증 체크 없는 처리 엔드포인트
- [ ] 평문 비밀번호 저장
- [ ] `.env` / 시크릿 파일 커밋
- [ ] 운영 환경 상세 에러 노출
- [ ] 사용자 입력을 셸 명령에 직접 전달
- [ ] 파일 경로에 사용자 입력 직접 사용 (`../` 등)
- [ ] 불필요한 개인정보 수집/로깅

## 보안 체크리스트 (코드 작성 시 반드시 준수)
코드를 작성하거나 수정할 때 해당 언어의 보안 체크리스트를 반드시 따를 것.

### PHP
- SQL: PDO Prepared Statement 필수, 사용자 입력을 쿼리에 직접 연결 금지
- XSS: 출력 시 `htmlspecialchars($var, ENT_QUOTES, 'UTF-8')`, JS 내 변수는 `json_encode()`
- CSRF: 폼에 CSRF 토큰 삽입 및 서버 검증, 중요 동작은 POST만
- 세션: 로그인 후 `session_regenerate_id(true)`, 쿠키에 httponly/secure/samesite 설정
- 비밀번호: `password_hash()` / `password_verify()` 사용
- 파일업로드: 확장자 화이트리스트, MIME 검증(`finfo_file()`), 파일명 랜덤 생성, 업로드 디렉토리 PHP 실행 차단
- 에러: 운영 환경 `display_errors=Off`, DB 에러 사용자 노출 금지
- 입력검증: `filter_var()`, `intval()` 등으로 타입 검증
- `eval()`, `exec()`, `system()` 사용 최소화

### JavaScript / Node.js
- XSS: 사용자 입력을 innerHTML/document.write에 직접 삽입 금지, DOM 조작 시 `textContent` 사용
- SQL: ORM 또는 Parameterized Query 사용 (Sequelize, Prisma 등)
- 인증: JWT secret 하드코딩 금지, 토큰 만료 설정 필수
- 의존성: `npm audit` 정기 실행, 알려진 취약 패키지 업데이트
- CORS: `Access-Control-Allow-Origin: *` 운영 환경 사용 금지, 허용 도메인 명시
- 입력검증: 서버 사이드 검증 필수 (클라이언트 검증만으로 불충분)
- 환경변수: `.env` 파일 git 커밋 금지, `dotenv` 사용
- Rate Limiting: API 엔드포인트에 요청 제한 적용
- `eval()`, `Function()` 생성자 사용 금지

### Python
- SQL: ORM 사용 또는 파라미터 바인딩 (`cursor.execute(sql, params)`)
- XSS: 템플릿 엔진 자동 이스케이프 활성화 (Jinja2 `autoescape=True`)
- 입력검증: `ast.literal_eval()` 사용 (`eval()` 금지)
- 의존성: `pip audit` / `safety check` 정기 실행
- 비밀번호: `bcrypt` 또는 `argon2` 사용
- 파일경로: `os.path.realpath()`로 경로 검증, Path Traversal 방지
- `pickle.loads()` 신뢰할 수 없는 데이터에 사용 금지
- CORS/시크릿: 설정 파일에 하드코딩 금지, 환경변수 사용
- Django: `DEBUG=False` 운영 환경 필수, `ALLOWED_HOSTS` 설정

### Java / Spring
- SQL: JPA/Hibernate 또는 PreparedStatement 사용, 문자열 연결 쿼리 금지
- XSS: Thymeleaf `th:text` 사용 (`th:utext` 지양), 입력값 이스케이프
- CSRF: Spring Security CSRF 보호 활성화
- 인증: Spring Security 사용, 비밀번호 `BCryptPasswordEncoder`
- 역직렬화: 신뢰할 수 없는 데이터 `ObjectInputStream` 사용 금지
- 로깅: 민감 정보(비밀번호, 토큰) 로그 출력 금지
- 의존성: OWASP Dependency Check 적용
- 설정: `application.yml`에 시크릿 하드코딩 금지, Vault 또는 환경변수 사용

### 공통 (모든 언어)
- HTTPS 필수 (운영 환경)
- 보안 헤더 설정: `X-Content-Type-Options: nosniff`, `X-Frame-Options`, `X-XSS-Protection`
- 중요 설정 파일은 웹 루트 밖 배치
- 디렉토리 리스팅 비활성화
- 에러 메시지에 시스템 내부 정보 노출 금지
- 로그인 실패 횟수 제한 (brute force 방지)
- 민감 데이터(비밀번호, API 키)는 암호화 저장, 평문 금지

## 수정 작업 리포트 규칙
코드 수정 작업을 완료한 후, 각 수정 항목에 대해 **완성도 점수**를 매겨서 보고할 것:
- 각 수정 사항마다 **완성도 점수 (1~100)** 를 부여 (내가 수행한 수정이 얼마나 잘 되었는지 자체 평가)
  - 1~20: 미흡 (임시 처리, 추가 작업 필요, 사이드이펙트 우려)
  - 21~50: 보통 (동작하지만 개선 여지 있음, 엣지케이스 미처리 가능)
  - 51~80: 양호 (요구사항 충족, 안정적이나 최적화 여지 존재)
  - 81~100: 우수 (요구사항 완벽 충족, 보안/성능/가독성 모두 고려)
- 수정 완료 후 아래 형식으로 정리:
  ```
  ## 수정 점수표
  | # | 수정 내용 | 완성도 | 사유 |
  |---|----------|--------|------|
  | 1 | 내용 | 점수 | 이유 |
  ```
