# CLAUDE.md — 프로젝트 루트 규칙

> 이 파일은 **claude-config 레포 자체**를 Claude Code로 작업할 때 사용되는 설정입니다.
> 새 프로젝트에 사용할 파일은 `CLAUDE.template.md`입니다. 이 파일을 복사하지 마세요.

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
├── CLAUDE.md              # 이 레포 전용 규칙 (이 파일, 복사 금지)
├── CLAUDE.template.md     # 새 프로젝트 초기화용 템플릿
├── GLOBAL/
│   ├── CLAUDE.md          # 글로벌 공통 규칙 (~/.claude/CLAUDE.md 원본)
│   ├── security-php.md
│   ├── security-js.md
│   ├── security-python.md
│   └── security-java.md
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
5. **커맨드는 선택적 효율 도구다** — 없어도 CI가 잡아줌, 있으면 한 번에 맞춤

---

## 3. 수정 작업 리포트 규칙

코드 수정 완료 후 아래 형식으로 완성도 점수를 보고:

```
## 수정 점수표
| # | 수정 내용 | 완성도 | 사유 |
|---|----------|--------|------|
| 1 | 내용 | 점수/100 | 이유 |
```

점수 기준: 1~20 미흡 / 21~50 보통 / 51~80 양호 / 81~100 우수

---

## 기여 가이드
- PR 제목은 `feat`, `fix`, `docs` 등으로 시작
- 코드 스타일: 네이밍 컨벤션 및 Lint 준수
