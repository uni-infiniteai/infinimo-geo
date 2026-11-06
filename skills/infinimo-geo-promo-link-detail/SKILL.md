---
name: infinimo-geo-promo-link-detail
description: Fetch promo-link check results by record id. 
---

# Promo link — detail

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

### Promo link — detail

`GET /aigc/geo/promo_link/log/detail`

Fetch promo-link check detail by record id. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| id | query | yes | Record id (from eval) |

## Examples

### Promo link — detail

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/promo_link/log/detail?id=<id>" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
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

1. GET /aigc/geo/promo_link/log/detail?id=
2. Summarize citation/mention results per model

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
