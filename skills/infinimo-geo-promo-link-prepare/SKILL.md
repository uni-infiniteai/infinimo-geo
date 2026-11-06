---
name: infinimo-geo-promo-link-prepare
description: Fetch a promo URL and generate check questions. Use before measuring how an article/landing page is cited in AI answers. 
---

# Promo link — prepare

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

### Promo link — model options

`GET /aigc/geo/promo_link/model/options`

Returns evaluators available for promo-link checks. Fetch models before prepare/eval. 

No request parameters.

### Promo link — fetch and generate questions

`POST /aigc/geo/promo_link/prepare`

Sync: fetches page title and body summary, then generates up to 5 check questions. After confirm/edit, call promo-link eval. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| url | body | yes | Promo URL |

## Examples

### Promo link — model options

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/promo_link/model/options" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### Promo link — fetch and generate questions

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/promo_link/prepare" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"url": "https://example.com/article"}'
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

1. Confirm url
2. POST /aigc/geo/promo_link/prepare {url}
3. Show title / questions for confirmation
4. Continue to infinimo-geo-promo-link-eval

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
