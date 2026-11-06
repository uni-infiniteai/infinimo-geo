# Infinimo GEO Agents

## About Infinimo GEO

**Infinimo GEO** is an AI workspace for Generative Engine Optimization (GEO): mine prompt keywords, measure AI citations, diagnose brand exposure, check promo links, and produce multi-platform placement copy—so brands get seen and cited in ChatGPT, Gemini, and other generative engines.

Website: [https://geo.infinimo.ai/?source=q-github-geo](https://geo.infinimo.ai/?source=q-github-geo)

## This Repository

**infinimo-geo** is the open-source Agent repository for Infinimo GEO: **AI Agent** definitions and install scripts for GEO workflows. Each Agent understands the business request, orchestrates API capabilities under `.infinimo/skills/`, and delivers results in a consistent format. Install into Cursor, Claude Code, and other mainstream AI coding tools.

The skills cover keyword expansion, brand score, citation eval/monitor, promo-link checks, and GEO copy—**15** API skills in total.

## Agents

| Agent | Description | Skills | In-product | Definition |
|-------|-------------|--------|------------|------------|
| **infinimo-geo-keyword** | Mine GEO prompts: keyword expansion and candidate library | 3 | [/keyword](https://geo.infinimo.ai/keyword?source=q-github-geo) | [agents/infinimo-geo-keyword/AGENT.md](agents/infinimo-geo-keyword/AGENT.md) |
| **infinimo-geo-citation** | Measure AI citations: multi-model eval, side signals, scheduled monitoring | 3 | [/citation-eval](https://geo.infinimo.ai/citation-eval?source=q-github-geo) | [agents/infinimo-geo-citation/AGENT.md](agents/infinimo-geo-citation/AGENT.md) |
| **infinimo-geo-brand-score** | Brand exposure score: prepare → eval → detail | 3 | [/brand-score](https://geo.infinimo.ai/brand-score?source=q-github-geo) | [agents/infinimo-geo-brand-score/AGENT.md](agents/infinimo-geo-brand-score/AGENT.md) |
| **infinimo-geo-content** | Write GEO placement copy: writing directions + multi-platform articles | 3 | [/text](https://geo.infinimo.ai/text?source=q-github-geo) | [agents/infinimo-geo-content/AGENT.md](agents/infinimo-geo-content/AGENT.md) |
| **infinimo-geo-promo-link** | Check promo links: fetch questions + multi-model detection | 3 | [/promo-link](https://geo.infinimo.ai/promo-link?source=q-github-geo) | [agents/infinimo-geo-promo-link/AGENT.md](agents/infinimo-geo-promo-link/AGENT.md) |

## Repository Layout

```text
infinimo-geo/
├── README.md
├── agents/                         # Agent source definitions
│   └── infinimo-geo-<agent-name>/AGENT.md
├── skills/                         # API skill sources (synced to .infinimo/skills/ on install)
│   └── infinimo-geo-<skill-name>/SKILL.md
└── scripts/install.sh
```

---

## Install & Use

### Supported Tools

| Tool | Output Location | Install Command |
|------|-----------------|-----------------|
| **Cursor** | `.cursor/skills/<agent>/SKILL.md` | `./scripts/install.sh --tool cursor .` |
| **Claude Code** | `.claude/agents/*.md` (optional `--global` → `~/.claude/agents/`) | `./scripts/install.sh --tool claude-code .` |
| **Codex** | `.agents/skills/<agent>/SKILL.md` | `./scripts/install.sh --tool codex .` |
| **GitHub Copilot** | `~/.github/agents/` + `~/.copilot/agents/` | `./scripts/install.sh --tool copilot .` |
| **Antigravity** | `~/.gemini/antigravity/skills/infinimo-geo-<agent>/` | `./scripts/install.sh --tool antigravity .` |
| **Gemini CLI** | `~/.gemini/extensions/infinimo-geo/` | `./scripts/install.sh --tool gemini-cli .` |
| **OpenCode** | `.opencode/agents/` | `./scripts/install.sh --tool opencode .` |
| **Aider** | `./CONVENTIONS.md` | `./scripts/install.sh --tool aider .` |
| **Windsurf** | `./.windsurfrules` | `./scripts/install.sh --tool windsurf .` |
| **OpenClaw** | `~/.openclaw/infinimo-geo/<agent>/` | `./scripts/install.sh --tool openclaw .` |
| **Qwen Code** | `.qwen/agents/` | `./scripts/install.sh --tool qwen .` |
| **Kimi Code** | `~/.config/kimi/agents/<agent>/` | `./scripts/install.sh --tool kimi .` |

Interactive multi-tool install (auto-detects tools on this machine):

```bash
./scripts/install.sh --tool all
# non-interactive: ./scripts/install.sh --no-interactive --tool all
# parallel:        ./scripts/install.sh --no-interactive --tool all --parallel
```

Unless `--rules-only` is set, every install syncs this repo's **`skills/`** into the target project's **`.infinimo/skills/`** (API docs and scripts; Agent links are rewritten to that path).

**Quick install:**

```bash
git clone https://github.com/uni-infiniteai/infinimo-geo.git
cd your-project

# Cursor
/path/to/infinimo-geo/scripts/install.sh --tool cursor .

# Claude Code
/path/to/infinimo-geo/scripts/install.sh --tool claude-code .
```

One-liner install:

```bash
export INFINIMO_GEO_GIT="https://github.com/uni-infiniteai/infinimo-geo.git"
curl -fsSL https://raw.githubusercontent.com/uni-infiniteai/infinimo-geo/main/scripts/install.sh | bash -s -- --tool cursor .
```

Update Agent definitions only (when `.infinimo/skills/` already exists): `./scripts/install.sh --tool <tool> . --rules-only`

### Prerequisites

- macOS / Linux / WSL with `bash`
- Run install from your **project root** (`.` or your project path in the command)
- Configure an **Infinimo API Key** (see below)

### API Key & Environment Variables

API calls under `.infinimo/skills/` require an Infinimo API Key. Agents and scripts read **`INFINIMO_API_KEY`** from the environment. Do not put keys in code or commit them to git.

#### 1. Get a Key

1. Sign up at [Infinimo GEO](https://geo.infinimo.ai/?source=q-github-geo)
2. After login, open the [API Key page](https://geo.infinimo.ai/api-key?source=q-github-geo) to create or copy a key

#### 2. Set Environment Variables

**Current shell session (temporary):**

```bash
export INFINIMO_API_KEY="your-key"
```

**Persistent (recommended, macOS / Linux zsh):**

```bash
echo 'export INFINIMO_API_KEY="your-key"' >> ~/.zshrc
source ~/.zshrc
```

## Related Repositories

| Repo | Purpose |
|------|---------|
| **infinimo-geo** (this repo) | Installable GEO Agents + Skill docs/scripts for Cursor and similar tools |
| **infinimo-agents** | Cross-border marketplace research (Amazon / TikTok / Shopee / Ozon) |
| **infinimo-ai-design** | Product image / video design Agents |

## License

MIT License
