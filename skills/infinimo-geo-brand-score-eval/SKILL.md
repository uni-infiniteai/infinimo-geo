---
name: infinimo-geo-brand-score-eval
description: Start an async multi-model brand exposure score check via Infinimo GEO. Run prepare first and confirm keywords/competitors.
---

# Brand score — start evaluation

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

### Brand score — start evaluation

`POST /aigc/geo/brand_score/eval`

Async: returns a record id immediately. When done, WebSocket type=geo_brand_score_result_refresh; the client fetches via brand-score detail. Get models from model options; keywords/competitors need at least one each (usually confirmed after prepare). 

| Parameter | Location | Required | Description |
|------|------|------|------|
| models | body | yes | Model id list (ContentModel.uuid) from /aigc/geo/brand_score/model/options |
| brand | body | yes | Brand name |
| description | body | no | Brand description (optional, shown in report) |
| products | body | no | Product/service list |
| keywords | body | yes | Topic keyword list (confirmed client-side) |
| competitors | body | yes | Competitor list (confirmed client-side) |

## Examples

### Brand score — start evaluation

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/brand_score/eval" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"models": ["<model_id>"], "brand": "ExampleBrand", "description": "Brand intro", "products": ["Product A"], "keywords": ["prompt keyword 1"], "competitors": ["Competitor A"]}'
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

1. GET /aigc/geo/brand_score/model/options for models
2. POST /aigc/geo/brand_score/eval (models/brand/keywords/competitors, etc.)
3. After you get the record id, fetch results with infinimo-geo-brand-score-detail

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
