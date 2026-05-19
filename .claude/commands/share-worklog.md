# 작업 로그 고객 공유본 생성 커맨드

$ARGUMENTS 날짜의 **워크로그**(`worklog/$DATE.md`)를 비개발자(고객) 친화 톤으로 재구성한다.
워크로그 전용 커맨드다. 워크로그가 없는 시점/세션 기반 공유는 `/share-session` 을 쓴다.

> 포맷·테마매핑·저장 규칙은 공통 모듈 [`_shared/customer-report-format.md`](_shared/customer-report-format.md) 가 단일 출처(SSOT)다.
> 이 커맨드는 **워크로그를 정규화**해서 그 모듈에 넘기는 역할만 한다.

> **사용 예시:**
> - `/share-worklog` — 오늘 날짜 자동
> - `/share-worklog 어제` — 자연어 날짜
> - `/share-worklog 2026-05-06` — 특정 날짜

## 동작 절차

### Step 1. 날짜 결정
- `$ARGUMENTS` 파싱: 비어있으면 `date +%Y-%m-%d`(오늘). "어제/오늘/그저께" 자연어 변환. `YYYY-MM-DD` 면 그대로. → `$DATE`
- 오전/오후 토큰이 있으면 `meta.ampm` 반영 (없으면 항목 시간으로 추정)

### Step 2. 워크로그 수집
- `worklog/$DATE.md` 읽기. **없으면** "해당 날짜에 작업 로그가 없습니다. 세션/레퍼런스 기반은 `/share-session` 을 사용하세요." 출력 후 종료
- 각 항목의 "### 작업 요약" + 시간/카테고리/카운터 파싱
- git 보강(시간/순서/누락 복원):
  ```bash
  git log --since="$DATE 00:00" --until="$DATE 23:59" --pretty=format:"%h | %ci | %s"
  git log --since="$DATE 00:00" --until="$DATE 23:59" --name-only --pretty=format: | sort -u | grep -v '^$'
  ```
  - 자동 커밋(`*(auto):`)은 제목만 참고, 사람 손 커밋 제목은 그대로 신뢰
  - 변경 파일 영역 그룹화: `api/lib/pages/assets/layouts`→"운영 시스템", `cron/`→"자동 작업", `sql/`→"DB 변경", `skill/QA`→"문서/계획", `scripts/.claude/CLAUDE.md`→"내부 도구/설정", `worklog/`→집계 제외

### Step 3. 정규화
워크로그를 공통 모듈 입력 계약(`{time, summary, areas}[] + meta`)으로 변환.
`meta.source = "worklog"`. 요약이 비면 커밋 제목 + 변경 영역으로 의미 복원.

### Step 4. 공통 모듈 적용
[`_shared/customer-report-format.md`](_shared/customer-report-format.md) 의
Step A(테마/진행도 매핑) → B(비개발자 톤) → C(출력 형식) → D(저장+출력) 를 **그대로 따른다.**
포맷/원칙을 여기서 중복 기술하지 않는다.

## 주의사항
- 책임은 **워크로그 정규화**까지. 톤/형식/저장은 공통 모듈이 결정한다.
- 워크로그 일부 항목의 "작업 요약"이 누락돼도 git log + 변경 영역으로 보강.
- 공통 모듈 규칙(이모지 금지, 마크다운 헤더 금지, `■` 글머리표, 식별자 비노출) 준수.
