---
name: infinimo-geo-brand-score-prepare
description: Generate topic keywords and competitors for brand diagnosis from a product/service list. Use in the prepare step before brand exposure scoring. Brand name is not used for tokenization. 
---

# Brand score — prepare

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

### Brand score — model options

`GET /aigc/geo/brand_score/model/options`

Returns evaluators available for brand score (web-enabled). Fetch models before prepare/eval. 

No request parameters.

### Brand score — generate keywords and competitors

`POST /aigc/geo/brand_score/prepare`

Sync: derives topic keywords and competitors from product/service list only (brand name is excluded from generation and only used to filter self-brand; description is echo-only). After confirm/edit, call brand-score eval. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| brand | body | yes | Brand name (excluded from keyword gen; filters self-brand from competitors) |
| description | body | yes | Brand description (echo-only for report, max 500) |
| products | body | yes | Product/service list (at least one); keywords and competitors are derived from this |

## Examples

### Brand score — model options

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/brand_score/model/options" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### Brand score — generate keywords and competitors

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/brand_score/prepare" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"brand": "ExampleBrand", "description": "Brand intro", "products": ["Product A"]}'
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

1. Collect brand / description / products (at least one product)
2. POST /aigc/geo/brand_score/prepare
3. Show keywords / competitors for the user to confirm or tweak
4. Continue to infinimo-geo-brand-score-eval

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
