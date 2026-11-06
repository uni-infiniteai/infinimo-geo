---
name: infinimo-geo-text-detail
description: Query GEO copy batch detail, item detail, or item list. 
---

# GEO copy — result lookup

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

### GEO copy — batch detail

`GET /aigc/geo/text/create/batch/log/detail`

Fetch copy-generation batch summary by batch id (success/fail/running counts, item refs, etc.). 

| Parameter | Location | Required | Description |
|------|------|------|------|
| id | query | yes | Batch record id (batchId from /create) |

### GEO copy — item detail

`GET /aigc/geo/text/log/detail`

Fetch a single-platform copy result by item id (body, cover, etc.). 

| Parameter | Location | Required | Description |
|------|------|------|------|
| id | query | yes | Item record id |

### GEO copy — item list

`GET /aigc/geo/text/create/logs`

List copy-generation item results. Optionally filter by batch_id for platforms under one batch. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| batch_id | query | no | Batch id; 0 or omit means no filter |
| start | query | no | Pagination offset |
| size | query | no | Page size |

## Examples

### GEO copy — batch detail

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/text/create/batch/log/detail?id=<id>" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### GEO copy — item detail

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/text/log/detail?id=<id>" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### GEO copy — item list

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/text/create/logs?batch_id=<batch_id>&start=<start>&size=<size>" \
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

1. Batch: GET /aigc/geo/text/create/batch/log/detail?id=
2. Item: GET /aigc/geo/text/log/detail?id=
3. List: GET /aigc/geo/text/create/logs?batch_id=

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
