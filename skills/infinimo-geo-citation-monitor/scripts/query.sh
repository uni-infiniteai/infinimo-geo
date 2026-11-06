#!/usr/bin/env bash
set -euo pipefail

API_KEY="${INFINIMO_API_KEY:-}"
if [[ -z "$API_KEY" ]]; then
  echo "Please set INFINIMO_API_KEY" >&2
  exit 1
fi
BASE="https://infinimo.ai/api"

CMD="${1:-}"
shift || true

usage() {
  cat >&2 <<EOF
Usage: query.sh <command> [args...]
Skill: infinimo-geo-citation-monitor

Commands:
  monitor-add <name> <cron_date_type> <time> <models> <brand> <keywords>  # Citation monitor — add cron task
  monitor-run <item_id>  # Citation monitor — run now
  series <item_id>  # Citation monitor — time series
  monitor-logs   # Citation monitor — run history
  monitor-detail <id>  # Citation monitor — run detail
EOF
  exit 1
}

[[ -n "$CMD" ]] || usage

case "$CMD" in
  monitor-add)
    # Citation monitor — add cron task
    if [[ "${1:-}" == \{* ]]; then
      PAYLOAD="$1"
    else
      KEYS='["name", "cron_date_type", "time", "weeks", "days", "day", "enable", "notifyEmail", "models", "brand", "competitors", "keywords"]'
      REQUIRED='["name", "cron_date_type", "time", "models", "brand", "keywords"]'
      PAYLOAD=$(KEYS="$KEYS" REQUIRED="$REQUIRED" python3 - "$@" <<'PY'
import json, os, sys
keys = json.loads(os.environ["KEYS"])
required = set(json.loads(os.environ["REQUIRED"]))
vals = list(sys.argv[1:])
body = {}
array_keys = {"products","keywords","competitors","models","questions","platforms","angles","weeks","days","image_prompts","signals"}
number_keys = {"count","cover_count","redditLimit","enable","promptId","groupId","batchId","cover"}
for idx, k in enumerate(keys):
    v = vals[idx] if idx < len(vals) else ""
    v = (v or "").strip()
    if not v:
        if k in required:
            raise SystemExit(f"{k} must not be empty")
        continue
    if k in array_keys:
        if v.startswith("["):
            body[k] = json.loads(v)
        else:
            body[k] = [x.strip() for x in v.split(",") if x.strip()]
    elif k in number_keys:
        try:
            body[k] = int(v)
        except ValueError:
            body[k] = v
    else:
        body[k] = v
print(json.dumps(body, ensure_ascii=False))
PY
)
    fi
    curl -s -X POST "$BASE/aigc/geo/citation_monitor/cron_task/add" -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY" -d "$PAYLOAD"
    ;;
  monitor-run)
    # Citation monitor — run now
    Q_ITEM_ID="${1:?item_id required}"
    curl -s -X POST "$BASE/aigc/geo/citation_monitor/cron_task/run?item_id=$Q_ITEM_ID" -H "Authorization: Bearer $API_KEY"
    ;;
  series)
    # Citation monitor — time series
    ITEM_ID="${1:?Usage: query.sh series <item_id> <begin> <end> <limit>}"
    BEGIN="${2:-}"
    END="${3:-}"
    LIMIT="${4:-}"
    qs=""
    if [[ -n "${ITEM_ID}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsitem_id=${ITEM_ID}"
    fi
    if [[ -n "${BEGIN}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsbegin=${BEGIN}"
    fi
    if [[ -n "${END}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsend=${END}"
    fi
    if [[ -n "${LIMIT}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qslimit=${LIMIT}"
    fi
    if [[ -n "$qs" ]]; then
      curl -s -X GET "$BASE/aigc/geo/citation_monitor/series?$qs" -H "Authorization: Bearer $API_KEY"
    else
      curl -s -X GET "$BASE/aigc/geo/citation_monitor/series" -H "Authorization: Bearer $API_KEY"
    fi
    ;;
  monitor-logs)
    # Citation monitor — run history
    ITEM_ID="${1:-}"
    START="${2:-}"
    SIZE="${3:-}"
    qs=""
    if [[ -n "${ITEM_ID}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsitem_id=${ITEM_ID}"
    fi
    if [[ -n "${START}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsstart=${START}"
    fi
    if [[ -n "${SIZE}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qssize=${SIZE}"
    fi
    if [[ -n "$qs" ]]; then
      curl -s -X GET "$BASE/aigc/geo/citation_monitor/logs?$qs" -H "Authorization: Bearer $API_KEY"
    else
      curl -s -X GET "$BASE/aigc/geo/citation_monitor/logs" -H "Authorization: Bearer $API_KEY"
    fi
    ;;
  monitor-detail)
    # Citation monitor — run detail
    ID="${1:?Usage: query.sh monitor-detail <id>}"
    qs=""
    if [[ -n "${ID}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsid=${ID}"
    fi
    if [[ -n "$qs" ]]; then
      curl -s -X GET "$BASE/aigc/geo/citation_monitor/log/detail?$qs" -H "Authorization: Bearer $API_KEY"
    else
      curl -s -X GET "$BASE/aigc/geo/citation_monitor/log/detail" -H "Authorization: Bearer $API_KEY"
    fi
    ;;
  *)
    usage
    ;;
esac
