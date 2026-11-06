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
Skill: infinimo-geo-brand-score-prepare

Commands:
  model-options   # Brand score — model options
  prepare <brand> <description> <products>  # Brand score — generate keywords and competitors
EOF
  exit 1
}

[[ -n "$CMD" ]] || usage

case "$CMD" in
  model-options)
    # Brand score — model options
    curl -s -X GET "$BASE/aigc/geo/brand_score/model/options" -H "Authorization: Bearer $API_KEY"
    ;;
  prepare)
    # Brand score — generate keywords and competitors
    if [[ "${1:-}" == \{* ]]; then
      PAYLOAD="$1"
    else
      KEYS='["brand", "description", "products"]'
      REQUIRED='["brand", "description", "products"]'
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
    curl -s -X POST "$BASE/aigc/geo/brand_score/prepare" -H "Content-Type: application/json" -H "Authorization: Bearer $API_KEY" -d "$PAYLOAD"
    ;;
  *)
    usage
    ;;
esac
