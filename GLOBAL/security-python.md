# Python 보안 규칙

> 이 파일은 Python 프로젝트에서 `~/.claude/CLAUDE.md`에 병합하여 사용합니다.
> 글로벌 공통 보안 규칙(`GLOBAL/CLAUDE.md`)과 함께 적용하세요.

## Python 보안 체크리스트

- SQL: ORM 사용 또는 파라미터 바인딩 (`cursor.execute(sql, params)`)
- XSS: 템플릿 엔진 자동 이스케이프 활성화 (Jinja2 `autoescape=True`)
- 입력검증: `ast.literal_eval()` 사용 (`eval()` 금지)
- 의존성: `pip audit` / `safety check` 정기 실행
- 비밀번호: `bcrypt` 또는 `argon2` 사용
- 파일경로: `os.path.realpath()`로 경로 검증, Path Traversal 방지
- `pickle.loads()` 신뢰할 수 없는 데이터에 사용 금지
- CORS/시크릿: 설정 파일에 하드코딩 금지, 환경변수 사용
- Django: `DEBUG=False` 운영 환경 필수, `ALLOWED_HOSTS` 설정
