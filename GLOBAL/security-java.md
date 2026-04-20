# Java / Spring 보안 규칙

> 이 파일은 Java/Spring 프로젝트에서 `~/.claude/CLAUDE.md`에 병합하여 사용합니다.
> 글로벌 공통 보안 규칙(`GLOBAL/CLAUDE.md`)과 함께 적용하세요.

## Java / Spring 보안 체크리스트

- SQL: JPA/Hibernate 또는 PreparedStatement 사용, 문자열 연결 쿼리 금지
- SQL(동적 정렬): 정렬 컬럼은 Enum 또는 화이트리스트로 검증, 사용자 입력 직접 사용 금지
- XSS: Thymeleaf `th:text` 사용 (`th:utext` 지양), JSP는 `<c:out>` 또는 `fn:escapeXml()` 사용
- CSRF: Spring Security CSRF 보호 활성화 (JWT Stateless 방식은 비활성화 허용)
- 인증: Spring Security 사용, 비밀번호 `BCryptPasswordEncoder`
- Entity 노출 금지: API 응답에 Entity 직접 반환 금지, Request/Response DTO 분리
- @Transactional: 클래스 기본 `readOnly = true`, 쓰기 메서드만 `@Transactional` 오버라이드
- N+1 방지: `default_batch_fetch_size` 설정 또는 fetch join / `@EntityGraph` 사용
- 역직렬화: 신뢰할 수 없는 데이터 `ObjectInputStream` 사용 금지
- 로깅: 민감 정보(비밀번호, 토큰) 로그 출력 금지
- 의존성: OWASP Dependency Check 적용
- 설정: `application.yml` 민감값 평문 금지, JASYPT 암호화 또는 환경변수 사용
- 운영 프로파일: `show-sql: false`, `ddl-auto: validate`, 디버그 모드 비활성화 필수
- 인증 주입: `@AuthenticationPrincipal` 사용, 요청 파라미터 `userId` 직접 신뢰 금지
- Mass Assignment: `@RequestBody` DTO가 Entity와 동일 구조 금지, `@JsonIgnoreProperties(ignoreUnknown = true)` 필수
- 입력검증: Controller에서 `@Valid` / `@Validated` 사용 필수
- MyBatis: `${}` 사용 금지, `#{}` 파라미터 바인딩 사용
- XML 파싱: XXE 방어 설정 필수 (외부 엔티티 비활성화)
- 예외 처리: `@ControllerAdvice` GlobalExceptionHandler 필수, stack trace 미노출
- 운영 설정: `server.error.include-stacktrace: never` 필수
- 토큰/세션 ID URL 파라미터 전달 금지 (서버 접근 로그에 노출됨)
- 타이밍 공격 방지: 비밀번호/토큰 비교 시 `MessageDigest.isEqual` 사용
- 랜덤값 생성: `SecureRandom` 사용 (`Math.random()` 금지)
- 운영 환경: Actuator(`/env`, `/beans` 등) / H2 Console 노출 금지
- JWT 사용 시: null / 만료 / 서명 예외 처리 누락 여부 확인, 토큰 만료 시간 설정 필수
- Enum 검증: 상태값은 문자열 그대로 신뢰 금지, Enum 타입으로 변환 검증
