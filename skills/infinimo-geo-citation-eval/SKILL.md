---
name: infinimo-geo-citation-eval
description: Multi-model check of whether AI answers mention the brand, citation sources, and competitor comparison. Optional Google Trends / Reddit side signals. 
---

# Citation eval

## About Infinimo GEO

**Infinimo GEO** is an AI workspace for Generative Engine Optimization (GEO): mine prompt keywords, measure AI citations, diagnose brand exposure, and produce multi-platform placement copy—so brands get seen and cited in ChatGPT, Gemini, and other generative engines.

This skill calls the Infinimo GEO open API.


## Authentication and base URL

- **Base URL**: `https://infinimo.ai/api`
- **API Key**: Sign up at https://geo.infinimo.ai, then create or copy a key at https://geo.infinimo.ai/api-key?source=q-github-geo
- **Headers**:
  - `Content-Type: application/json`
  - `Authorization: Bearer <API_KEY>`

Read `INFINIMO_API_KEY` from the environment first; if unset, ask the user—never hardcode credentials.


## Endpoints

### Citation eval — model options

`GET /aigc/geo/citation_eval/model/options`

Returns web-enabled models available for citation eval. 

No request parameters.

### Citation eval — side-signal options

`GET /aigc/geo/citation_eval/signal/options`

Returns optional side signals (e.g. google_trend / reddit) that can be requested with citation eval via the signals field. 

No request parameters.

### Citation eval — start

`POST /aigc/geo/citation_eval/eval`

Async multi-model citation eval. Provide question or questions (questions preferred, 1–20, each gets its own history). Returns record id list immediately; when done, WebSocket type=geo_citation_eval_result_refresh, then fetch citation detail. Optional signals, competitors, region, redditScene, redditLimit. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| models | body | yes | Model id list from /aigc/geo/citation_eval/model/options |
| brand | body | yes | Target brand keyword |
| question | body | no | Single question (mutually exclusive with questions; omit for batch) |
| questions | body | no | Submit multiple questions at once (1–20); wins if both are sent |
| competitors | body | no | Competitor brand list (optional, max 8) |
| signals | body | no | Side signals: google_trend / reddit (multi-select) |
| region | body | no | Google Trends region, ISO 3166-1 alpha-2, default US (only when google_trend is selected) |
| redditScene | body | no | Reddit scene: empty/common=semantic search, biz=opportunity search |
| redditLimit | body | no | Reddit result limit; default 20, max 50 |

## Examples

### Citation eval — model options

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/citation_eval/model/options" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### Citation eval — side-signal options

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/citation_eval/signal/options" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### Citation eval — start

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/citation_eval/eval" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"models": ["<model_id>"], "brand": "ExampleBrand", "question": "Which wireless earbuds are best for commuting?", "questions": ["Question 1"], "competitors": ["Competitor A"], "signals": "<signals>", "region": "<region>", "redditScene": "<redditScene>", "redditLimit": "<redditLimit>"}'
```

Or use the script (`scripts/query.sh`, by subcommand).

## Response shape

```json
{
  "status": 1,
  "data": { ... }
}
```

- `status`: `1` = success, `0` = failure
- On success, summarize `data` in English for the user (do not paste raw JSON)
- Async endpoints return a record id; call the detail endpoint next

## Workflow

1. Confirm brand, question or questions (1–20), optional competitors / signals
2. GET model/options and optional signal/options
3. POST /aigc/geo/citation_eval/eval
4. Fetch async results with infinimo-geo-citation-detail

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
