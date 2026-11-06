---
name: infinimo-geo-text-generate
description: Generate GEO writing-angle suggestions from a keyword or seed prompt (not full articles). Use infinimo-geo-text-create for final copy.
---

# GEO copy — writing directions

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

### GEO copy — platform options

`GET /aigc/geo/text/platform/options`

Returns writable target platforms as type/desc: wechat_public/weibo/toutiao/douyin_text/xiaohongshu/zhihu/baijiahao/netease/sohu/csdn/baidu_baike/wiki_baike, etc. 

No request parameters.

### GEO copy — model options

`GET /aigc/geo/text/model/options`

Returns LLMs available for copy generation (id/title/pointsPer1kToken). 

No request parameters.

### GEO copy — image model options

`GET /aigc/geo/text/image_model/options`

Returns image models for covers; point is the per-cover cost. 

No request parameters.

### GEO copy — writing-angle options

`GET /aigc/geo/text/angle/options`

Returns available writing angles: definition/how_to/comparison/scenario/faq/buying_guide/roi/trend/risk/practice. Used as multi-select angles for generate writing directions. 

No request parameters.

### GEO copy — generate writing directions

`POST /aigc/geo/text/generate`

Synchronously generate suggested writing directions (not full articles). For final create, also pass seed + implant + this prompt. count defaults to 20, max 50. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| prompt | body | yes | Keyword/seed prompt (topic search term or content direction) |
| model | body | yes | LLM id from /aigc/geo/text/model/options |
| count | body | no | Number of directions; default 20, range 1–50 |
| implant | body | no | Brand implant copy (strongly recommended) |
| angles | body | no | GEO writing-angle type list from /angle/options |

## Examples

### GEO copy — platform options

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/text/platform/options" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### GEO copy — model options

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/text/model/options" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### GEO copy — image model options

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/text/image_model/options" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### GEO copy — writing-angle options

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/text/angle/options" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### GEO copy — generate writing directions

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/text/generate" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"prompt": "wireless earbuds buying guide", "model": "<model_id>", "count": "<count>", "implant": "Brand implant copy", "angles": "<angles>"}'
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

1. Fetch model/options, optional angle/options
2. POST /aigc/geo/text/generate (prompt/model; optional count/implant/angles)
3. Number the directions for the user to pick; then continue to create

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
