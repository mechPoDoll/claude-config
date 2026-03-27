# 프로젝트 루트 문서

프로젝트 이름: 폴더구조 파서

## 소개
이 프로젝트는 로컬/원격 폴더 구조를 파싱하고, 각 경로에 대응하는 문서 파일을 자동 생성하도록 설계되었습니다.

## 디렉터리 구조
- `/global`: 글로벌 CLAUDE.md 원본 (`~/.claude/CLAUDE.md`에 배포하여 사용)
- `/QA`: QA(품질 보증) 관련 문서
- `/skill`: 스킬 목록 및 관련 설명

## CLAUDE.md 계층 구조
```
~/.claude/CLAUDE.md          ← 글로벌 (모든 프로젝트에 적용)
  └ /global/CLAUDE.md        ← 이 레포에서 버전 관리하는 글로벌 원본
/CLAUDE.md                   ← 프로젝트 루트 (이 파일)
/QA/CLAUDE.md                ← QA 디렉터리 로컬 규칙
/skill/CLAUDE.md             ← Skill 디렉터리 로컬 규칙
```
> `global/CLAUDE.md`를 수정한 후 `~/.claude/CLAUDE.md`에 복사하면 글로벌 설정이 갱신됩니다.

## 실행 방법
1. 개발 환경 설정
2. 파서 실행
3. 결과 확인

## 기여 가이드
- PR 제목은 `feat`, `fix`, `docs` 등으로 시작
- 코드 스타일: 네이밍 컨벤션 및 Lint 준수
