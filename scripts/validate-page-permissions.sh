#!/bin/bash
# 페이지 권한 일관성 검증
#
# 룰: pages/*.php 에 `require_page_access(N)` 호출이 있으면, 같은 파일에서 액션별
#     권한 처리(`page_permissions(N)` 헬퍼 또는 `has_role($g, N, ...)` 명시 호출)도
#     반드시 있어야 한다.
#
# 배경: 권한 게이트가 5층 분산 (페이지 진입 / API 호출 / 메뉴 노출 / 버튼 노출 / DB 필터)
#       되어 있어 신규 페이지 추가 시 "버튼 노출" 층 누락이 반복 발생.
#       require_page_access(N) 만 부르고 has_role 호출 안 하면 — 등록/수정/삭제 버튼이
#       권한 없는 사용자에게도 노출되어 클릭 시점 알럿 받는 어색한 UX.
#
# 검증 대상: 인자로 받은 디렉토리의 pages/*.php
# 제외: 인증 안 필요한 화면 (login.php, join.php), 권한 무관 (find_id.php 등) 은
#       require_page_access 호출 자체가 없으므로 본 룰 대상 아님

set -e

TARGET_DIR="${1:-.}"
ERRORS=0

echo "페이지 권한 일관성 검증: $TARGET_DIR"
echo ""

PAGES_DIR="$TARGET_DIR/pages"
if [ ! -d "$PAGES_DIR" ]; then
  echo "  ⚠️  pages/ 디렉토리 없음 — 검증 건너뜀"
  exit 0
fi

# require_page_access(N) 호출하는 페이지 목록 + menu_id 추출
while IFS= read -r FILE; do
  # require_page_access 호출 행 추출 → menu_id 첫 인자만 (action_id 무시)
  MENU_ID=$(grep -oE 'require_page_access\s*\(\s*[0-9]+' "$FILE" | head -1 | grep -oE '[0-9]+$' || true)
  if [ -z "$MENU_ID" ]; then continue; fi

  # 같은 파일에 page_permissions(MENU_ID) 또는 has_role(..., MENU_ID, ...) 있는지
  HAS_HELPER=$(grep -E "page_permissions\s*\(\s*${MENU_ID}\s*[\),]" "$FILE" | head -1 || true)
  HAS_ROLE_DIRECT=$(grep -E "has_role\s*\([^)]*,\s*[\"']?${MENU_ID}[\"']?\s*," "$FILE" | head -1 || true)

  if [ -z "$HAS_HELPER" ] && [ -z "$HAS_ROLE_DIRECT" ]; then
    echo "  ❌ $FILE"
    echo "     require_page_access($MENU_ID) 호출하지만 page_permissions($MENU_ID) /"
    echo "     has_role(..., $MENU_ID, ...) 호출 누락 — 액션 버튼 권한 처리 필요"
    ERRORS=$((ERRORS + 1))
  fi
done < <(grep -lE 'require_page_access\s*\(\s*[0-9]+' "$PAGES_DIR"/*.php 2>/dev/null || true)

echo ""

if [ "$ERRORS" -gt 0 ]; then
  echo "❌ 페이지 권한 일관성 위반 $ERRORS 건"
  echo ""
  echo "💡 수정 방법:"
  echo "   pages/*.php 에서 require_page_access(N) 직후 다음 패턴 추가:"
  echo "     \$perms = page_permissions(N);"
  echo "   그리고 등록/수정/삭제 버튼에 if (\$perms['register'/'edit'/'delete']) 적용"
  echo "   JS 측은 emit_permissions_js(\$perms) 로 CAN_REGISTER/CAN_EDIT/CAN_DELETE 노출"
  exit 1
else
  echo "✅ 페이지 권한 일관성 검증 통과"
fi
