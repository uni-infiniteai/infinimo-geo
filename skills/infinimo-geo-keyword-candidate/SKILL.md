---
name: infinimo-geo-keyword-candidate
description: Add keywords to the Infinimo GEO candidate library or list current candidates. Use when the user saves prompts or manages the keyword bank.
---

# Candidate keyword library

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

### Candidates — add

`POST /aigc/geo/keyword/candidate/add`

Add a keyword to the current user's candidate library; scoped per user within a merchant; duplicates are ignored. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| keyword | body | yes | Keyword |

### Candidates — list

`GET /aigc/geo/keyword/candidate/list`

List the signed-in user's candidate keywords for this merchant, no pagination, newest first. 

No request parameters.

## Examples

### Candidates — add

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/keyword/candidate/add" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"keyword": "wireless earbuds"}'
```

### Candidates — list

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/keyword/candidate/list" \
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

1. Add: POST /aigc/geo/keyword/candidate/add {keyword}
2. List: GET /aigc/geo/keyword/candidate/list
3. Duplicate keywords are ignored (expected)

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
