# PHP 보안 규칙

> 이 파일은 PHP 프로젝트에서 `~/.claude/CLAUDE.md`에 병합하여 사용합니다.
> 글로벌 공통 보안 규칙(`GLOBAL/CLAUDE.md`)과 함께 적용하세요.

## PHP 보안 체크리스트

- SQL: PDO Prepared Statement 필수, 사용자 입력을 쿼리에 직접 연결 금지
- XSS: 출력 시 `htmlspecialchars($var, ENT_QUOTES, 'UTF-8')`, JS 내 변수는 `json_encode()`
- CSRF: 폼에 CSRF 토큰 삽입 및 서버 검증, 중요 동작은 POST만
- 세션: 로그인 후 `session_regenerate_id(true)`, 쿠키에 httponly/secure/samesite 설정
- 비밀번호: `password_hash()` / `password_verify()` 사용
- 파일업로드: 업로드 디렉토리 PHP 실행 차단, MIME 검증은 `finfo_file()` 사용
- 에러: 운영 환경 `display_errors=Off`, DB 에러 사용자 노출 금지
- 입력검증: `filter_var()`, `intval()` 등으로 타입 검증
- `eval()`, `exec()`, `system()` 사용 최소화
  - **예외**: QA E2E 테스트 도구 (`QA/e2e-*.{js,py}`) 의 `page.evaluate()` 등 동적 JS 주입은 면제. Playwright 등 브라우저 자동화 도구의 표준 패턴이며 CDP 통신이라 JS `eval()` 과 메커니즘이 다름. 운영 코드는 그대로 적용.
