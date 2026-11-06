---
name: infinimo-geo-citation-detail
description: Fetch async citation-eval results by record id. 
---

# Citation eval — detail

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

### Citation eval — detail

`GET /aigc/geo/citation_eval/log/detail`

Fetch citation-eval detail by record id (cited domains, model answers, side signals, etc.). 

| Parameter | Location | Required | Description |
|------|------|------|------|
| id | query | yes | Record id |

## Examples

### Citation eval — detail

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/citation_eval/log/detail?id=<id>" \
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

1. GET /aigc/geo/citation_eval/log/detail?id=
2. Table: model × mention × source domains

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
