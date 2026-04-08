#!/bin/bash
# QA 디렉터리 파일 명명 규칙 검증
# 허용 패턴:
#   index.md
#   legacy_checklist.md
#   qa_YYYYMMDD_v#.md
#   qa_YYYYMMDD_v#_주제.md  (영문/숫자/언더스코어)
#   e2e-범위.*
#   visual-test.*
#   범위-report.html
#   deploy.*
#   deploy_모듈명.*
#   CLAUDE.md (디렉터리 규칙 파일)

set -e

QA_DIR="${1:-QA}"
ERRORS=0

if [ ! -d "$QA_DIR" ]; then
  echo "QA 디렉터리를 찾을 수 없습니다: $QA_DIR"
  exit 0
fi

echo "QA 명명 규칙 검증 시작: $QA_DIR"

for filepath in "$QA_DIR"/*; do
  [ -f "$filepath" ] || continue

  filename=$(basename "$filepath")

  # 허용 패턴 검사
  if echo "$filename" | grep -qE \
    '^(CLAUDE|index|legacy_checklist)\.md$|^qa_[0-9]{8}_v[0-9]+(_[a-zA-Z0-9_]+)?\.md$|^e2e-[a-zA-Z0-9_-]+\.[a-zA-Z]+$|^visual-test\.[a-zA-Z]+$|^[a-zA-Z0-9_-]+-report\.html$|^deploy(_[a-zA-Z0-9_]+)?\.[a-zA-Z]+$'; then
    echo "  ✅ $filename"
  else
    echo "  ❌ 명명 규칙 위반: $filename"
    echo "     허용 패턴: index.md, legacy_checklist.md, qa_YYYYMMDD_v#.md, qa_YYYYMMDD_v#_주제.md, e2e-범위.*, visual-test.*, 범위-report.html, deploy.*, deploy_모듈명.*"
    ERRORS=$((ERRORS + 1))
  fi
done

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "❌ QA 명명 규칙 위반 $ERRORS 건 발견"
  exit 1
else
  echo ""
  echo "✅ QA 명명 규칙 검증 통과"
fi
