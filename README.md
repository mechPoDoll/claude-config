# 폴더구조 파서 — CLAUDE.md 설정 관리

로컬/원격 폴더 구조를 파싱하고, 각 경로에 대응하는 CLAUDE.md 문서를 자동 생성·관리하는 프로젝트입니다.

## 구조

```
├── CLAUDE.md              # 프로젝트 루트 규칙
├── global/
│   └── CLAUDE.md          # 글로벌 규칙 (~/.claude/CLAUDE.md 원본)
├── QA/
│   └── CLAUDE.md          # QA 디렉터리 규칙
└── skill/
    └── CLAUDE.md          # Skill 디렉터리 규칙
```

## 글로벌 설정 적용 방법

```bash
cp global/CLAUDE.md ~/.claude/CLAUDE.md
```

## CLAUDE.md 계층 우선순위

1. **글로벌** (`~/.claude/CLAUDE.md`) — 모든 프로젝트에 공통 적용
2. **프로젝트 루트** (`/CLAUDE.md`) — 해당 프로젝트 전체에 적용
3. **하위 디렉터리** (`/QA/CLAUDE.md`, `/skill/CLAUDE.md`) — 해당 디렉터리 작업 시 추가 적용
