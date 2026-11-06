---
name: infinimo-geo-promo-link-eval
description: Start an async multi-model citation/mention check for a promo URL. 
---

# Promo link — start evaluation

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

### Promo link — start evaluation

`POST /aigc/geo/promo_link/eval`

Async: returns a record id immediately. questions: 1–5 items; questionMode=auto|custom. After WebSocket notify, fetch via promo-link detail. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| models | body | yes | Model id list from /aigc/geo/promo_link/model/options |
| url | body | yes | Promo URL |
| title | body | no | Article title (from prepare; if empty, eval re-fetches) |
| questions | body | yes | Check questions, 1–5 items |
| questionMode | body | no | Question source: auto=smart match, custom=user-defined |

## Examples

### Promo link — start evaluation

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/promo_link/eval" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"models": ["<model_id>"], "url": "https://example.com/article", "title": "<title>", "questions": ["Question 1"], "questionMode": "<questionMode>"}'
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

1. GET /aigc/geo/promo_link/model/options for models
2. POST /aigc/geo/promo_link/eval (models/url/questions; optional title, questionMode)
3. Fetch results with infinimo-geo-promo-link-detail

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
