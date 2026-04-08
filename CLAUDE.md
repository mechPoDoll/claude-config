# CLAUDE.md — 프로젝트 루트 규칙

> 이 파일은 Claude Code 세션 시작 시 자동 로딩됩니다.
> 핵심 규칙만 직접 포함하며, 플레이스홀더(`{{}}`)는 사용하지 않습니다.
> 새 프로젝트 초기화가 필요하면 `CLAUDE.template.md`를 복사하여 사용하세요.

---

## 1. 프로젝트 개요

이 레포는 Claude Code용 CLAUDE.md 설정 파일을 계층별로 관리합니다.
하네스 엔지니어링 3계층(지시 / 강제 주입 / 검증) 구조로 설계되어 있습니다.

| 항목 | 내용 |
|------|------|
| 기술 스택 | Markdown, Shell Script |
| 인프라 | GitHub Actions |

### 디렉터리 구조
```
claude-config/
├── CLAUDE.md              # 루트 규칙 (이 파일, 자동 로딩)
├── CLAUDE.template.md     # 새 프로젝트 초기화용 템플릿
├── GLOBAL/
│   ├── CLAUDE.md          # 글로벌 공통 규칙 (~/.claude/CLAUDE.md 원본)
│   ├── security-php.md
│   ├── security-js.md
│   ├── security-python.md
│   └── security-java.md
├── QA/
│   └── CLAUDE.md          # 사람용 QA 참고 문서
├── SKILL/
│   └── CLAUDE.md          # 사람용 SKILL 참고 문서
├── .claude/
│   ├── settings.json
│   └── commands/
│       ├── qa-audit.md
│       ├── skill-write.md
│       └── security-check.md
├── scripts/
│   ├── validate-qa-naming.sh
│   ├── validate-skill-naming.sh
│   └── validate-security-patterns.sh
├── .github/
│   └── workflows/
│       └── harness-check.yml
└── README.md
```

---

## 2. 하네스 엔지니어링 설계 원칙

1. **자동 로딩 위치에만 에이전트 규칙을 배치한다** — 루트 CLAUDE.md, 글로벌 CLAUDE.md
2. **"참조하라" 방식은 쓰지 않는다** — 에이전트가 실제로 읽을지 보장 불가
3. **핵심만 압축해서 직접 포함한다** — 토큰 효율 = 파일 분리가 아니라 압축
4. **상세 형식 검증은 CI가 강제한다** — 에이전트가 몰라도 머지 차단
5. **QA/SKILL CLAUDE.md는 사람용 참고 문서로 유지한다**
6. **커맨드는 선택적 효율 도구다** — 없어도 CI가 잡아줌, 있으면 한 번에 맞춤

---

## 3. QA 핵심 규칙

QA 파일 생성 시 반드시 아래 명명 규칙을 따를 것:

| 유형 | 파일명 패턴 | 예시 |
|------|------------|------|
| QA 이력 마스터 | `index.md` | 전체 QA 현황 요약 |
| 보안감사 보고서 | `qa_YYYYMMDD_v#.md` | `qa_20260318_v1.md` |
| 주제별 보고서 | `qa_YYYYMMDD_v#_주제.md` | `qa_20260318_v2_db_tuning.md` |
| 레거시 체크리스트 | `legacy_checklist.md` | 레거시 프로젝트 초기 점검용 |
| E2E 테스트 | `e2e-범위.*` | `e2e-test.mjs` |
| 배포 스크립트 | `deploy.*` | `deploy.sh` |

- QA 작업 시작 시 `QA/index.md` 생성, 보고서 추가 시 반드시 갱신
- 상태 아이콘: ✅ 완료 / 🔄 진행중 / ❌ 실패 / ⬜ 대기

---

## 4. SKILL 핵심 규칙

SKILL 파일 생성 시 반드시 아래 명명 규칙을 따를 것:

| 파일명 패턴 | 용도 |
|------------|------|
| `00_OVERVIEW.md` | 프로젝트 전체 IA, 파일 매핑 (항상 최초 생성) |
| `NN_섹션명.md` | 메뉴/기능별 명세서 (NN = 메뉴번호) |
| `CHANGE_MMDD.md` | 기존 기능 변경 요청 명세 |
| `DB_SCHEMA.md` | DB 스키마 정의 |
| `index.md` | 마일스톤 트래커 |

- 첫 작업 시 `00_OVERVIEW.md` 먼저 생성
- 파일 생성·수정 후 `index.md` 반드시 갱신
- 각 문서에 MUST 섹션(페이지 개요, 기능 요약, ASCII 와이어프레임) 반드시 포함

---

## 5. 보안 핵심 규칙

아래 항목은 어떤 언어에서도 절대 금지:

- 사용자 입력을 SQL 문자열에 직접 삽입 — **Prepared Statement / ORM 필수**
- 출력 시 이스케이프 없이 사용자 데이터 렌더링 — **XSS 방지 필수**
- CSRF 토큰 없는 상태 변경 요청 (세션 인증 사용 시)
- 인증 체크 없는 처리 엔드포인트
- 평문 비밀번호 저장 — **해시 필수**
- `.env` / 시크릿 파일 커밋
- 운영 환경 상세 에러 노출

언어별 상세 보안 규칙은 `GLOBAL/security-{언어}.md` 참조.
글로벌 공통 보안 규칙은 `~/.claude/CLAUDE.md`에 포함됩니다.

---

## 6. 수정 작업 리포트 규칙

코드 수정 완료 후 아래 형식으로 완성도 점수를 보고:

```
## 수정 점수표
| # | 수정 내용 | 완성도 | 사유 |
|---|----------|--------|------|
| 1 | 내용 | 점수/100 | 이유 |
```

점수 기준: 1~20 미흡 / 21~50 보통 / 51~80 양호 / 81~100 우수
