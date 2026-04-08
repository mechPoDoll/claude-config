#!/bin/bash
# 기본 보안 패턴 위반 탐지
# PHP, JavaScript, Python, Java 소스 파일에서 명백한 보안 위반 패턴을 탐지

set -e

TARGET_DIR="${1:-.}"
ERRORS=0

echo "보안 패턴 검증 시작: $TARGET_DIR"
echo ""

# ──────────────────────────────────────────
# PHP: 사용자 입력 직접 SQL 삽입
# ──────────────────────────────────────────
echo "[ PHP ] 사용자 입력 직접 SQL 삽입 탐지..."
if find "$TARGET_DIR" -name "*.php" | xargs grep -l '\$_\(GET\|POST\|REQUEST\|COOKIE\)' 2>/dev/null | \
   xargs grep -l 'mysql_query\|mysqli_query\|->query(' 2>/dev/null | grep -q .; then

  MATCHES=$(find "$TARGET_DIR" -name "*.php" -exec grep -ln '\$_\(GET\|POST\|REQUEST\|COOKIE\).*mysql_query\|mysql_query.*\$_\(GET\|POST\|REQUEST\|COOKIE\)' {} \; 2>/dev/null || true)
  if [ -n "$MATCHES" ]; then
    echo "  ❌ 사용자 입력 직접 SQL 삽입 가능성:"
    echo "$MATCHES" | sed 's/^/     /'
    ERRORS=$((ERRORS + 1))
  fi
fi

# ──────────────────────────────────────────
# PHP: eval() 사용
# ──────────────────────────────────────────
echo "[ PHP ] eval() 사용 탐지..."
PHP_EVAL=$(find "$TARGET_DIR" -name "*.php" -exec grep -ln '\beval\s*(' {} \; 2>/dev/null || true)
if [ -n "$PHP_EVAL" ]; then
  echo "  ❌ eval() 사용 감지:"
  echo "$PHP_EVAL" | sed 's/^/     /'
  ERRORS=$((ERRORS + 1))
fi

# ──────────────────────────────────────────
# JavaScript: eval() / innerHTML 직접 사용
# ──────────────────────────────────────────
echo "[ JS ] eval() 사용 탐지..."
JS_EVAL=$(find "$TARGET_DIR" \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" \
  -exec grep -ln '\beval\s*(' {} \; 2>/dev/null || true)
if [ -n "$JS_EVAL" ]; then
  echo "  ❌ eval() 사용 감지:"
  echo "$JS_EVAL" | sed 's/^/     /'
  ERRORS=$((ERRORS + 1))
fi

# ──────────────────────────────────────────
# Python: eval() 사용
# ──────────────────────────────────────────
echo "[ Python ] eval() 사용 탐지..."
PY_EVAL=$(find "$TARGET_DIR" -name "*.py" \
  -not -path "*/.git/*" \
  -exec grep -ln '\beval\s*(' {} \; 2>/dev/null || true)
if [ -n "$PY_EVAL" ]; then
  echo "  ❌ eval() 사용 감지:"
  echo "$PY_EVAL" | sed 's/^/     /'
  ERRORS=$((ERRORS + 1))
fi

# ──────────────────────────────────────────
# 공통: .env 파일이 Git 추적 대상인지 확인
# ──────────────────────────────────────────
echo "[ 공통 ] .env 파일 Git 추적 여부 확인..."
if git -C "$TARGET_DIR" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  if git -C "$TARGET_DIR" ls-files --error-unmatch .env > /dev/null 2>&1; then
    echo "  ❌ .env 파일이 Git에 추적되고 있습니다! 즉시 제거하고 .gitignore에 추가하세요."
    ERRORS=$((ERRORS + 1))
  fi
else
  echo "  ⚠️  Git 저장소가 아닙니다. .env 파일 추적 검사를 건너뜁니다."
fi

# ──────────────────────────────────────────
# 공통: 하드코딩된 비밀번호/시크릿 패턴
# ──────────────────────────────────────────
echo "[ 공통 ] 하드코딩 시크릿 패턴 탐지..."
HARDCODED=$(find "$TARGET_DIR" \
  \( -name "*.php" -o -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/vendor/*" \
  -exec grep -ln 'password\s*=\s*["'"'"'][^"'"'"']\{4,\}["'"'"']\|secret\s*=\s*["'"'"'][^"'"'"']\{4,\}["'"'"']\|api_key\s*=\s*["'"'"'][^"'"'"']\{4,\}["'"'"']' {} \; 2>/dev/null || true)
if [ -n "$HARDCODED" ]; then
  echo "  ⚠️  하드코딩 시크릿 가능성 (수동 확인 필요):"
  echo "$HARDCODED" | sed 's/^/     /'
fi

echo ""

if [ "$ERRORS" -gt 0 ]; then
  echo "❌ 보안 패턴 위반 $ERRORS 건 발견"
  exit 1
else
  echo "✅ 보안 패턴 검증 통과"
fi
