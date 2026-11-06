---
name: infinimo-geo-keyword-expand
description: Expand GEO prompt keywords from a seed term via the Infinimo GEO API. Use when the user needs keyword mining or search-query expansion. Fetch model options first, then call expand.
---

# GEO keyword expansion

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

### GEO keyword expansion — model options

`GET /aigc/geo/keyword/model/options`

Returns available models for keyword expansion (id/title/pointsPer1kToken). Fetch model before calling expand.

No request parameters.

### GEO keyword expansion

`POST /aigc/geo/keyword/expand`

Synchronously generates about 10 expanded search queries from a seed keyword, persists them, and returns the full result (including record id)—no WebSocket. Get model from the model-options endpoint.

| Parameter | Location | Required | Description |
|------|------|------|------|
| keyword | body | yes | Seed placement keyword |
| model | body | yes | Model id from /aigc/geo/keyword/model/options |

## Examples

### GEO keyword expansion — model options

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/keyword/model/options" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### GEO keyword expansion

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/keyword/expand" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"keyword": "wireless earbuds", "model": "<model_id>"}'
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

1. Confirm the seed keyword (keep the user's original language)
2. GET /aigc/geo/keyword/model/options pick a model
3. POST /aigc/geo/keyword/expand pass keyword + model
4. Present the expanded prompt table; suggest saving candidates or continuing to citation eval / content

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
