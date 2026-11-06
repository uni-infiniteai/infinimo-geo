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
Skill: infinimo-geo-text-detail

Commands:
  batch-detail <id>  # GEO copy — batch detail
  detail <id>  # GEO copy — item detail
  logs   # GEO copy — item list
EOF
  exit 1
}

[[ -n "$CMD" ]] || usage

case "$CMD" in
  batch-detail)
    # GEO copy — batch detail
    ID="${1:?Usage: query.sh batch-detail <id>}"
    qs=""
    if [[ -n "${ID}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsid=${ID}"
    fi
    if [[ -n "$qs" ]]; then
      curl -s -X GET "$BASE/aigc/geo/text/create/batch/log/detail?$qs" -H "Authorization: Bearer $API_KEY"
    else
      curl -s -X GET "$BASE/aigc/geo/text/create/batch/log/detail" -H "Authorization: Bearer $API_KEY"
    fi
    ;;
  detail)
    # GEO copy — item detail
    ID="${1:?Usage: query.sh detail <id>}"
    qs=""
    if [[ -n "${ID}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsid=${ID}"
    fi
    if [[ -n "$qs" ]]; then
      curl -s -X GET "$BASE/aigc/geo/text/log/detail?$qs" -H "Authorization: Bearer $API_KEY"
    else
      curl -s -X GET "$BASE/aigc/geo/text/log/detail" -H "Authorization: Bearer $API_KEY"
    fi
    ;;
  logs)
    # GEO copy — item list
    BATCH_ID="${1:-}"
    START="${2:-}"
    SIZE="${3:-}"
    qs=""
    if [[ -n "${BATCH_ID}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsbatch_id=${BATCH_ID}"
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
      curl -s -X GET "$BASE/aigc/geo/text/create/logs?$qs" -H "Authorization: Bearer $API_KEY"
    else
      curl -s -X GET "$BASE/aigc/geo/text/create/logs" -H "Authorization: Bearer $API_KEY"
    fi
    ;;
  *)
    usage
    ;;
esac
