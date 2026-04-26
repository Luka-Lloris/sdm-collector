#!/bin/bash
# 로컬에서 collector 수동 트리거 (디버깅·테스트용)
# 사용: RAILWAY_API_URL=... RAILWAY_ADMIN_TOKEN=... ./scripts/trigger.sh bizinfo

set -euo pipefail

COLLECTOR="${1:-bizinfo}"
RAILWAY_API_URL="${RAILWAY_API_URL:-https://web-production-c8d70c.up.railway.app}"
RAILWAY_ADMIN_TOKEN="${RAILWAY_ADMIN_TOKEN:-}"

if [ -z "$RAILWAY_ADMIN_TOKEN" ]; then
    echo "Warning: RAILWAY_ADMIN_TOKEN not set (proceeding without auth — only works in dev mode)"
fi

echo "Triggering ${COLLECTOR} collector..."
echo "Target: ${RAILWAY_API_URL}/api/v1/admin/collectors/${COLLECTOR}/run"
echo "---"

curl -X POST \
    "${RAILWAY_API_URL}/api/v1/admin/collectors/${COLLECTOR}/run" \
    -H "Content-Type: application/json" \
    -H "X-Admin-Token: ${RAILWAY_ADMIN_TOKEN}" \
    --max-time 1500 \
    | python3 -m json.tool || cat

echo ""
echo "---"
echo "Done."
