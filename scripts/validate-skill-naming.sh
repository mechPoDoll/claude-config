#!/bin/bash
# SKILL 디렉터리 파일 명명 규칙 검증
# 허용 패턴:
#   .gitkeep
#   00_OVERVIEW.md
#   NN_섹션명.md  (두 자리 숫자 + 영문대문자/언더스코어)
#   CHANGE_MMDD.md  (4자리 날짜)
#   DB_SCHEMA.md
#   index.md
#   user_index.md
#   USER_NN_섹션명.md
#   migration_*.sql

set -e

SKILL_DIR="${1:-SKILL}"
ERRORS=0

if [ ! -d "$SKILL_DIR" ]; then
  echo "SKILL 디렉터리가 없습니다. 검증을 건너뜁니다: $SKILL_DIR"
  exit 0
fi

echo "SKILL 명명 규칙 검증 시작: $SKILL_DIR"

for filepath in "$SKILL_DIR"/*; do
  [ -f "$filepath" ] || continue

  filename=$(basename "$filepath")

  # 허용 패턴 검사
  if echo "$filename" | grep -qE \
    '^\.gitkeep$|^(index|user_index|DB_SCHEMA|00_OVERVIEW)\.md$|^[0-9]{2}_[A-Z][A-Z0-9_]+\.md$|^CHANGE_[0-9]{4}\.md$|^USER_[0-9]{2}_[A-Z][A-Z0-9_]+\.md$|^migration_[a-zA-Z0-9_]+\.sql$'; then
    echo "  ✅ $filename"
  else
    echo "  ❌ 명명 규칙 위반: $filename"
    echo "     허용 패턴: 00_OVERVIEW.md, NN_섹션명.md, CHANGE_MMDD.md, DB_SCHEMA.md, index.md, user_index.md, USER_NN_섹션명.md, migration_*.sql"
    ERRORS=$((ERRORS + 1))
  fi
done

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "❌ SKILL 명명 규칙 위반 $ERRORS 건 발견"
  exit 1
else
  echo ""
  echo "✅ SKILL 명명 규칙 검증 통과"
fi
