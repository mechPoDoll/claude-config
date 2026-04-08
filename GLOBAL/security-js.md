# JavaScript / Node.js 보안 규칙

> 이 파일은 JavaScript/Node.js 프로젝트에서 `~/.claude/CLAUDE.md`에 병합하여 사용합니다.
> 글로벌 공통 보안 규칙(`GLOBAL/CLAUDE.md`)과 함께 적용하세요.

## JavaScript / Node.js 보안 체크리스트

- XSS: 사용자 입력을 innerHTML/document.write에 직접 삽입 금지, DOM 조작 시 `textContent` 사용
- SQL: ORM 또는 Parameterized Query 사용 (Sequelize, Prisma 등)
- 인증: JWT secret 하드코딩 금지, 토큰 만료 설정 필수
- 의존성: `npm audit` 정기 실행, 알려진 취약 패키지 업데이트
- 환경변수: `dotenv` 사용
- `eval()`, `Function()` 생성자 사용 금지
