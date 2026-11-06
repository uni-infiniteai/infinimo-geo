---
name: infinimo-geo-citation-monitor
description: Create/run scheduled brand-citation monitors and query time series plus run history. Use for ongoing AI exposure tracking. 
---

# Citation monitor

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

### Citation monitor — add cron task

`POST /aigc/geo/citation_monitor/cron_task/add`

Create a scheduled citation-monitor task that evaluates keywords on a cron. cron_date_type=day|week|month|once; week uses weeks; month uses days; once uses day (yyyy-MM-dd). 

| Parameter | Location | Required | Description |
|------|------|------|------|
| name | body | yes | Task name |
| cron_date_type | body | yes | Schedule type: day / week / month / once |
| time | body | yes | Run time, e.g. 00:00 / 00:30 / 01:30 (30-minute slots) |
| weeks | body | no | Weekdays when cron_date_type=week; 0=Sun…6=Sat, comma-separated |
| days | body | no | Day-of-month list when cron_date_type=month, e.g. 1,3,5,10 |
| day | body | no | Exact date when cron_date_type=once, format 2026-01-01 |
| enable | body | no | Whether enabled |
| notifyEmail | body | no | Notify email when done (optional) |
| models | body | yes | Evaluator model id list (same pool as citation eval) |
| brand | body | yes | Target brand keyword |
| competitors | body | no | Competitor brand list (optional, max 8) |
| keywords | body | yes | Monitor query keywords (each run evaluates them one by one) |

### Citation monitor — run now

`POST /aigc/geo/citation_monitor/cron_task/run`

Run a configured monitor task once (do not wait for cron). Async: returns a summary record id immediately (status=appending); when done, use Citation monitor — run detail or /logs; child records can reuse Citation eval — detail. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| item_id | query | yes | Monitor task itemId |

### Citation monitor — time series

`GET /aigc/geo/citation_monitor/series`

Fetch time-series data for a monitor task item_id (for trend charts). Optional begin/end (timestamps), limit (default 200). 

| Parameter | Location | Required | Description |
|------|------|------|------|
| item_id | query | yes | Monitor task itemId (integer) |
| begin | query | no | Start timestamp; 0 means unbounded |
| end | query | no | End timestamp; 0 means unbounded |
| limit | query | no | Max rows to return; default 200 |

### Citation monitor — run history

`GET /aigc/geo/citation_monitor/logs`

Monitor run-history list. Optional item_id filter; pagination matches system PageBaseParam (e.g. start/size). 

| Parameter | Location | Required | Description |
|------|------|------|------|
| item_id | query | no | Monitor task itemId; 0 or omit means no filter |
| start | query | no | Pagination offset |
| size | query | no | Page size |

### Citation monitor — run detail

`GET /aigc/geo/citation_monitor/log/detail`

Fetch one monitor-run summary by run record id. 

| Parameter | Location | Required | Description |
|------|------|------|------|
| id | query | yes | Run record id |

## Examples

### Citation monitor — add cron task

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/citation_monitor/cron_task/add" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{"name": "Brand daily monitor", "cron_date_type": "day", "time": "09:00", "weeks": "<weeks>", "days": "<days>", "day": "<day>", "enable": "<enable>", "notifyEmail": "<notifyEmail>", "models": ["<model_id>"], "brand": "ExampleBrand", "competitors": ["Competitor A"], "keywords": ["prompt keyword 1"]}'
```

### Citation monitor — run now

```bash
curl -s -X POST "https://infinimo.ai/api/aigc/geo/citation_monitor/cron_task/run" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $INFINIMO_API_KEY" \
  -d '{}'
```

### Citation monitor — time series

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/citation_monitor/series?item_id=<item_id>&begin=<begin>&end=<end>&limit=<limit>" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### Citation monitor — run history

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/citation_monitor/logs?item_id=<item_id>&start=<start>&size=<size>" \
  -H "Authorization: Bearer $INFINIMO_API_KEY"
```

### Citation monitor — run detail

```bash
curl -s -X GET "https://infinimo.ai/api/aigc/geo/citation_monitor/log/detail?id=<id>" \
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

1. Add: POST /aigc/geo/citation_monitor/cron_task/add
2. Run now: POST /aigc/geo/citation_monitor/cron_task/run?item_id=
3. Series: GET /series; history: GET /logs; detail: GET /log/detail

## Output tips

- Present the core results in a table
- Give 2–3 actionable next steps
- English by default
