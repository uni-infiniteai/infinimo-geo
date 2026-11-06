---
name: infinimo-geo-text-create
description: Generate final GEO placement copy per platform (async). Must pass seed + implant + prompt (writing direction). Supports appending platforms. 
---

# GEO copy — final create

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

### GEO copy — final create

`POST /aigc/geo/text/create`

Generate final articles. Pass seed=keyword, implant=brand implant text, prompt=writing direction, platforms=target platform list, model. Returns batchId; multi-platform writes the batch then per-item records. Cover: cover_mode=none|single|multi. When done, WebSocket common_text_batch_result_refresh / common_text_result_refresh; then fetch batch/item detail. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| platforms | body | yes | Target platform type list from /platform/options |
| prompt | body | yes | Suggested writing direction |
| seed | body | no | Keyword/seed (recommended for final create) |
| implant | body | no | Brand implant copy |
| model | body | no | LLM id |
| cover | body | no | Whether to generate a cover (legacy; mutually exclusive with cover_mode) |
| cover_mode | body | no | Cover mode none/single/multi; if omitted, fall back to cover |
| cover_count | body | no | Multi-cover count; required when cover_mode=multi, 2–9 |
| cover_prompt_mode | body | no | Multi-cover prompt mode ai_split / user_input; required for multi |
| image_model | body | no | Image model id |
| image_prompt | body | no | Image prompt; for multi user_input, separate with --- |
| image_prompts | body | no | Multi-cover user prompt list; preferred for user_input; length = cover_count |
| groupId | body | no | Writing category itemId (optional) |
| promptId | body | no | Writing-direction library GeoPrompt.id (optional; auto-marked used after create) |

### GEO copy — append platforms

`POST /aigc/geo/text/create/append`

Append platform copy to an existing batch (does not create a new batch). Require batchId + platforms; omitted fields reuse the batch. Returns the same batchId. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| batchId | body | yes | Existing batch record id |
| platforms | body | yes | Target platform type list to append |
| prompt | body | no | Writing direction; omit to reuse the batch |
| seed | body | no | Keyword; omit to reuse the batch |
| implant | body | no | Brand implant; omit to reuse the batch |
| model | body | no | LLM id; omit to reuse the batch |
| cover_mode | body | no | Cover mode none/single/multi; omit to reuse the batch |
| image_model | body | no | Image model id; omit to reuse the batch |

## Examples

### GEO copy — final create

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/text/create" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"platforms": ["wechat_public"], "prompt": "wireless earbuds buying guide", "seed": "wireless earbuds", "implant": "Brand implant copy", "model": "<model_id>", "cover": "<cover>", "cover_mode": "<cover_mode>", "cover_count": "<cover_count>", "cover_prompt_mode": "<cover_prompt_mode>", "image_model": "<image_model>", "image_prompt": "<image_prompt>", "image_prompts": "<image_prompts>", "groupId": "<groupId>", "promptId": "<promptId>"}'
```

### GEO copy — append platforms

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/text/create/append" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"batchId": "<batchId>", "platforms": ["wechat_public"], "prompt": "wireless earbuds buying guide", "seed": "wireless earbuds", "implant": "Brand implant copy", "model": "<model_id>", "cover_mode": "<cover_mode>", "image_model": "<image_model>"}'
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

1. GET platform/options to pick platforms; fetch model (and optional image_model)
2. POST /aigc/geo/text/create: platforms + prompt + seed + implant + model
3. Optional cover_mode / image_* parameters
4. Fetch batchId results with infinimo-geo-text-detail; append platforms via /create/append

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
