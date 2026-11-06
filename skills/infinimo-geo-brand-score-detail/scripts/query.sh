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
Skill: infinimo-geo-brand-score-detail

Commands:
  detail <id>  # Brand score — detail
EOF
  exit 1
}

[[ -n "$CMD" ]] || usage

case "$CMD" in
  detail)
    # Brand score — detail
    ID="${1:?Usage: query.sh detail <id>}"
    qs=""
    if [[ -n "${ID}" ]]; then
      [[ -n "$qs" ]] && qs="$qs&"
      qs="$qsid=${ID}"
    fi
    if [[ -n "$qs" ]]; then
      curl -s -X GET "$BASE/aigc/geo/brand_score/log/detail?$qs" -H "Authorization: Bearer $API_KEY"
    else
      curl -s -X GET "$BASE/aigc/geo/brand_score/log/detail" -H "Authorization: Bearer $API_KEY"
    fi
    ;;
  *)
    usage
    ;;
esac
