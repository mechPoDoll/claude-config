# claude-config — 하네스 엔지니어링 CLAUDE.md 관리

Claude Code에서 사용하는 CLAUDE.md 파일을 하네스 엔지니어링 원칙에 따라 계층별로 관리하는 레포지터리입니다.

---

## 하네스 엔지니어링 3계층 구조

```
┌─────────────────────────────────────────────────┐
│  Layer 1: 지시                                   │
│  루트 CLAUDE.md, 글로벌 CLAUDE.md               │
│  → 에이전트가 세션 시작 시 자동 로딩              │
│  → 핵심 규칙만 직접 포함 (참조 링크 아님)         │
├─────────────────────────────────────────────────┤
│  Layer 2: 강제 주입 (선택적 효율 도구)            │
│  .claude/commands/                              │
│  → 유저가 커맨드 사용 시 규칙이 컨텍스트에 주입    │
│  → 없어도 CI가 잡아줌, 있으면 첫 시도부터 맞춤    │
├─────────────────────────────────────────────────┤
│  Layer 3: 검증                                   │
│  CI workflow, scripts/                          │
│  → 에이전트가 규칙을 어기면 머지 차단             │
│  → 유저 의지와 무관하게 강제 적용                 │
└─────────────────────────────────────────────────┘
```

---

## 토큰 효율 설계 원칙

| 원칙 | 설명 |
|------|------|
| **자동 로딩 위치에만 적는다** | 루트·글로벌 CLAUDE.md만 자동 로딩 보장 |
| **"참조하라" 지시는 쓰지 않는다** | 에이전트가 읽을지 보장 불가 |
| **핵심만 압축해서 직접 포함한다** | 토큰 효율 = 파일 분리가 아니라 압축 |
| **상세 형식 검증은 CI가 강제한다** | 에이전트가 몰라도 머지 차단 |
| **QA/SKILL CLAUDE.md는 사람용** | 에이전트 지시 아님, 사람 참고용 |

---

## 디렉터리 구조

```
claude-config/
├── CLAUDE.md              # 루트 규칙 (자동 로딩, 핵심만 직접 포함)
├── CLAUDE.template.md     # 새 프로젝트 초기화용 템플릿 (플레이스홀더 포함)
├── GLOBAL/
│   ├── CLAUDE.md          # 글로벌 공통 규칙 (~/.claude/CLAUDE.md 원본)
│   ├── security-php.md    # PHP 언어별 보안 규칙
│   ├── security-js.md     # JavaScript 언어별 보안 규칙
│   ├── security-python.md # Python 언어별 보안 규칙
│   └── security-java.md   # Java 언어별 보안 규칙
├── QA/
│   └── CLAUDE.md          # 사람용 QA 참고 문서
├── SKILL/
│   └── CLAUDE.md          # 사람용 SKILL 참고 문서
├── .claude/
│   ├── settings.json      # 도구 허용/차단 설정
│   └── commands/
│       ├── qa-audit.md    # QA 보안 감사 커맨드
│       ├── skill-write.md # SKILL 명세서 작성 커맨드
│       └── security-check.md # 보안 체크리스트 커맨드
├── scripts/
│   ├── validate-qa-naming.sh        # QA 명명 규칙 검증
│   ├── validate-skill-naming.sh     # SKILL 명명 규칙 검증
│   └── validate-security-patterns.sh # 보안 패턴 위반 탐지
├── .github/
│   └── workflows/
│       └── harness-check.yml        # PR 시 자동 검증 CI
└── README.md
```

---

## 사용 방법

### 1. 글로벌 설정 적용

```bash
# 공통 규칙만 적용
cp GLOBAL/CLAUDE.md ~/.claude/CLAUDE.md

# 언어별 보안 규칙 병합 (PHP 프로젝트 예시)
cat GLOBAL/CLAUDE.md GLOBAL/security-php.md > ~/.claude/CLAUDE.md
```

### 2. 새 프로젝트에 적용

```bash
# 템플릿을 복사하여 초기화
cp CLAUDE.template.md /path/to/project/CLAUDE.md
cp -r QA /path/to/project/QA
cp -r SKILL /path/to/project/SKILL
```

Claude Code를 시작하면 `CLAUDE.template.md`의 플레이스홀더(`{{}}`)를 감지하여 소스 코드를 자동 분석합니다.
플레이스홀더를 채운 후에는 자동 분석 지시문 섹션을 삭제하세요.

### 3. CI 검증 스크립트 로컬 실행

```bash
# QA 명명 규칙 검증
bash scripts/validate-qa-naming.sh QA

# SKILL 명명 규칙 검증
bash scripts/validate-skill-naming.sh SKILL

# 보안 패턴 위반 탐지
bash scripts/validate-security-patterns.sh .
```

---

## 커맨드 사용법

커맨드는 **선택적 효율 도구**입니다. 없어도 CI가 규칙 위반을 잡아주지만, 있으면 첫 시도부터 규칙에 맞는 결과를 얻을 수 있습니다.

| 커맨드 | 용도 |
|--------|------|
| `/qa-audit [대상]` | QA 보안 감사 절차 + 보고서 형식 주입 |
| `/skill-write [기능명]` | SKILL 명세서 작성 절차 + 형식 주입 |
| `/security-check [대상]` | 보안 체크리스트 실행 |

---

## CI 검증

PR 생성 시 `.github/workflows/harness-check.yml`이 자동 실행됩니다:

1. **QA 명명 규칙** — `qa_YYYYMMDD_v#.md` 등 패턴 검증
2. **SKILL 명명 규칙** — `NN_섹션명.md` 등 패턴 검증
3. **보안 패턴 탐지** — eval(), SQL 직접 삽입, .env 추적 등 탐지

위반 시 머지 차단됩니다.

---

## CLAUDE.md 계층 구조

```
~/.claude/CLAUDE.md          ← 글로벌 (모든 프로젝트에 적용, 자동 로딩 ✅)
  └ GLOBAL/CLAUDE.md          ← 이 레포에서 버전 관리하는 원본
/CLAUDE.md                   ← 프로젝트 루트 (자동 로딩 ✅, 핵심 규칙 직접 포함)
/QA/CLAUDE.md                ← 사람용 QA 참고 문서 (자동 로딩 ❌)
/SKILL/CLAUDE.md             ← 사람용 SKILL 참고 문서 (자동 로딩 ❌)
```

> QA/SKILL CLAUDE.md는 자동 로딩이 보장되지 않으므로 에이전트용 핵심 규칙은 루트 CLAUDE.md에 직접 포함되어 있습니다.
