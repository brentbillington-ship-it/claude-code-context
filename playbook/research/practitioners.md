# Practitioner Scout — Report

_Wave 1, 2026-04-22. Scope: independent practitioners who actually ship with Claude Code._

## Top practitioners + their biggest CC insight

| Name | Where they post | Headline take |
|---|---|---|
| Simon Willison | simonwillison.net, simonw.substack.com | Run multiple CC + Codex CLI instances in parallel (git worktrees, YOLO mode for sandboxed tasks); transcripts are the real artifact worth keeping. [parallel post](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/), [transcripts](https://simonwillison.net/2025/Dec/25/claude-code-transcripts/) |
| Boris Cherny (CC creator) | x.com/bcherny, howborisusesclaudecode.com | His setup is deliberately "vanilla": Plan mode + auto-accept, Opus with thinking, slash commands in `.claude/commands/`, shared team `CLAUDE.md`, PostToolUse formatter hook. Does NOT use `--dangerously-skip-permissions`. [thread](https://x.com/bcherny/status/2007179832300581177) |
| Thariq Shihipar (Anthropic) | x.com/trq212, LinkedIn | Skills are folders, not just markdown; the Gotchas section is the highest-signal content; treat the filesystem as progressive disclosure for the agent. [post](https://www.linkedin.com/pulse/lessons-from-building-claude-code-how-we-use-skills-thariq-shihipar-iclmc) |
| Dan Shipper / Every | every.to | "Compound engineering": every bug, review, and fix permanently upgrades the system. Non-technical staff ship PRs via CC. [post](https://every.to/source-code/how-i-use-claude-code-to-ship-like-a-team-of-five-6f23f136-52ab-455f-a997-101c071613aa) |
| Kieran Klaassen (Every / Cora) | every.to, x.com/kieranklaassen | Operationalizes compound engineering; runs five Every products with single-person eng teams by orchestrating agent loops that plan → code → review → learn. [guide](https://every.to/source-code/compound-engineering-the-definitive-guide) |
| Thorsten Ball (Amp / Sourcegraph) | registerspill.thorstenball.com | The handwritten/generated ratio has flipped; still writes some code by hand to keep learning. Highlights "6 Weeks of Claude Code" as S-tier. [J&C #76](https://registerspill.thorstenball.com/p/joy-and-curiosity-76) |
| swyx / Latent Space | latent.space | Longform interviews with the people building CC and its critics; best single source for the competitive frame. [CC episode](https://www.latent.space/p/claude-code) |
| Armin Ronacher | lucumr.pocoo.org | Production stack designed around agents: raw SQL over ORMs, OpenAPI-first, dual-agent workflow, Sonnet on $100 Max plan is enough. [recs](https://lucumr.pocoo.org/2025/06/12/agentic-coding/), [plan mode](https://lucumr.pocoo.org/2025/12/17/what-is-plan-mode/) |

## Specific posts worth Brent reading in full

- [Embracing the parallel coding agent lifestyle — Simon Willison, Oct 2025](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/) — how he got over his skepticism about N-way parallel agents.
- [Designing agentic loops — Simon Willison](https://simonw.substack.com/p/designing-agentic-loops/comments) — framework for designing the "outer loop" around CC.
- [A new way to extract detailed transcripts from Claude Code — Simon Willison, Dec 2025](https://simonwillison.net/2025/Dec/25/claude-code-transcripts/) — argues transcripts = decision log.
- [Claude Code Remote Control — Simon Willison, Feb 2026](https://simonwillison.net/2026/Feb/25/claude-code-remote-control/) — driving local CC from mobile/web.
- [Auto mode for Claude Code — Simon Willison, Mar 2026](https://simonwillison.net/2026/mar/24/auto-mode-for-claude-code/) — why he thinks auto mode is the right compromise between YOLO and manual approval.
- [Boris Cherny's "How I use Claude Code" thread](https://x.com/bcherny/status/2007179832300581177) and its expanded microsite [howborisusesclaudecode.com](https://howborisusesclaudecode.com) — primary source on creator-approved defaults.
- [Head of Claude Code, Boris Cherny — Lenny's Newsletter, Feb 2026](https://www.lennysnewsletter.com/p/head-of-claude-code-what-happens) — roadmap hints + productivity philosophy.
- [Building Claude Code with Boris Cherny — Pragmatic Engineer (Gergely Orosz), Mar 2026](https://newsletter.pragmaticengineer.com/p/building-claude-code-with-boris-cherny) — parallel agents, evolving eng role.
- [Thariq Shihipar — Lessons from Building Claude Code: How We Use Skills](https://www.linkedin.com/pulse/lessons-from-building-claude-code-how-we-use-skills-thariq-shihipar-iclmc) and ["Seeing like an Agent"](https://x.com/trq212/status/2027463795355095314) — skill design, context engineering.
- [How I Use Claude Code to Ship Like a Team of Five — Dan Shipper, Every](https://every.to/source-code/how-i-use-claude-code-to-ship-like-a-team-of-five-6f23f136-52ab-455f-a997-101c071613aa) — concrete workflow + subagent battle pattern.
- [Compound Engineering: The Definitive Guide — Every](https://every.to/source-code/compound-engineering-the-definitive-guide) — the philosophy Every bets on.
- [Agentic Coding Recommendations — Armin Ronacher, Jun 2025](https://lucumr.pocoo.org/2025/06/12/agentic-coding/) and [Agentic Coding Things That Didn't Work — Jul 2025](https://lucumr.pocoo.org/2025/7/30/things-that-didnt-work/) — honest accounting of wins/losses.
- [What Actually Is Claude Code's Plan Mode? — Armin Ronacher, Dec 2025](https://lucumr.pocoo.org/2025/12/17/what-is-plan-mode/) — the best single explainer of Plan Mode behavior.
- [Claude Code: Anthropic's Agent in Your Terminal — Latent Space, May 2025](https://www.latent.space/p/claude-code) — foundational podcast w/ Boris + Cat Wu.
- [Steve Yegge's Vibe Coding Manifesto — Latent Space](https://www.latent.space/p/steve-yegges-vibe-coding-manifesto) — the most substantive critique of CC's shape.
- [Why Anthropic Thinks AI Should Have Its Own Computer — Felix Rieseberg on Latent Space, Mar 2026](https://www.latent.space/p/felix-anthropic) — Claude Cowork positioning vs. CC.

## Workflows they describe

**Boris Cherny (creator-vanilla):** 5 terminal tabs numbered 1-5, each a separate CC session; 5-10 web sessions in parallel; `--teleport` to move sessions local/web; starts every session in Plan mode (shift+tab x2), iterates on the plan, then flips to auto-accept edits for a one-shot; Opus with thinking always on; slash commands in `.claude/commands/` committed to git; one shared `CLAUDE.md` the team updates whenever Claude makes a mistake; `/permissions` pre-allowlist in `.claude/settings.json` instead of YOLO; PostToolUse hook for formatter. [source](https://x.com/bcherny/status/2007179832300581177)

**Simon Willison:** Mixed fleet — CC (Sonnet 4.5), Codex CLI (GPT-5-Codex), Codex Cloud from his phone, Jules, Copilot Coding Agent. Runs YOLO only in sandboxed/ephemeral environments. Designs explicit "agentic loops" with tight feedback; publishes CC transcripts as the durable artifact; uses Playwright MCP for browser tasks. [parallel post](https://simonwillison.net/2025/Oct/5/parallel-coding-agents/), [Playwright MCP TIL](https://til.simonwillison.net/claude-code/playwright-mcp-claude-code)

**Thariq Shihipar:** Ships Skills as folders containing scripts + reference code + gotchas; treats tool design as product design; built the "ask user question" tool used in Plan mode so Claude can interactively elicit requirements. Caching is load-bearing for cost. [skills post](https://www.linkedin.com/pulse/lessons-from-building-claude-code-how-we-use-skills-thariq-shihipar-iclmc), [prompt caching thread](https://x.com/trq212/status/2024574133011673516)

**Dan Shipper / Every:** Non-technical teammates open PRs via CC. Pattern: multiple subagents with opposing roles (e.g. "pro-Dan" vs "auditor" for expense categorization) "do battle" to reach a defensible answer. Uses "tacit code sharing" — point CC at a sibling codebase and ask how that team solved X. [post](https://every.to/source-code/how-i-use-claude-code-to-ship-like-a-team-of-five-6f23f136-52ab-455f-a997-101c071613aa)

**Kieran Klaassen (Cora):** Orchestrates parallel agent loops — read issue → synthesize plan → write + test → review → feed lessons back. Each loop permanently upgrades the system's context. Runs a whole product solo. [guide](https://every.to/source-code/compound-engineering-the-definitive-guide)

**Armin Ronacher:** Abandoned ORMs for raw SQL (Claude writes it). OpenAPI-first, codegen for client + server shims. Dual-agent: one agent codes, another debugs with tool access. Sonnet + $100 Max plan. Gives agents full permissions and walks away. [post](https://lucumr.pocoo.org/2025/06/12/agentic-coding/)

**Thorsten Ball:** Works on Amp but writes respectfully about CC; his team is removing Amp Tab because handwritten/generated ratio flipped. Still writes ~10-20 lines by hand to stay sharp. [J&C #70](https://registerspill.thorstenball.com/p/joy-and-curiosity-70-d85)

## Tools they endorse

- **Playwright MCP** — Simon Willison's go-to for anything browser-shaped; Thariq-style skills often wrap it. [TIL](https://til.simonwillison.net/claude-code/playwright-mcp-claude-code)
- **Slash commands in `.claude/commands/`** — Boris checks them into git so the whole team gets them; widely copied. [thread](https://x.com/bcherny/status/2007179832300581177)
- **Shared `CLAUDE.md` with correction updates** — the dominant pattern (Boris, Every, Armin).
- **Skills (`.claude/skills/`)** — Thariq is the loudest voice; emphasizes Library/API Reference + Product Verification categories.
- **PostToolUse formatter hook** — Boris's team uses one; Simon Willison's "YOLO-with-a-destructive-command-hook" is the safety-conscious variant.
- **Auto Mode** (Anthropic's Mar 2026 feature) — Simon Willison endorses as the sane middle ground. [post](https://simonwillison.net/2026/mar/24/auto-mode-for-claude-code/)
- **claude-code-transcripts (simonw)** — publish sessions as HTML. [repo](https://github.com/simonw/claude-code-transcripts)
- **awesome-claude-code** — community index of skills/hooks/commands/subagents. [repo](https://github.com/hesreallyhim/awesome-claude-code)
- **claudekit** (Carl Rannaberg) — auto-save checkpointing, quality hooks, 20+ subagents (oracle, code-reviewer, typescript-expert).
- **ContextKit** (Cihat Gündüz) — 4-phase planning methodology as a framework.

## Where practitioners disagree with each other

- **YOLO / `--dangerously-skip-permissions`.** Armin Ronacher assigns agents full permissions and walks away; Simon Willison runs YOLO only in sandboxes and adds destructive-command hooks; Boris Cherny refuses to use the flag at all, preferring `/permissions` allowlists. Real-world `rm -rf ~/` incidents in late 2025 hardened the anti-YOLO camp. [writeup](https://thomas-wiegold.com/blog/claude-code-dangerously-skip-permissions/), [Boris](https://x.com/bcherny/status/2007179832300581177), [Simon](https://simonwillison.net/2026/mar/24/auto-mode-for-claude-code/)
- **Opus vs Sonnet.** Boris: always Opus with thinking — steering cost dominates token cost. Armin: Sonnet is plenty, Max plan is enough. Simon: Sonnet 4.5 as his CC default, Codex for the GPT side.
- **Is CC the endgame?** Steve Yegge (on Latent Space) argues CC-shaped tools are a dead-end and the future is orchestration dashboards ("VibeCoder"). swyx pushes back; Boris / Thariq obviously disagree, as does Every's Kieran (who builds the orchestration *on top of* CC rather than around it). [episode](https://www.latent.space/p/steve-yegges-vibe-coding-manifesto)
- **Customize heavily vs stay vanilla.** Boris: vanilla + a few slash commands. Every / claudekit / ContextKit crowd: elaborate skill/agent frameworks. Both ship real software; the split roughly tracks solo-hacker vs. team lead.
- **How much to hand-write.** Thorsten Ball keeps hand-writing small bits to stay sharp; Dan Shipper says nobody at Every writes code manually any more.

## Promising repos for deep-dive

- [simonw/claude-code-transcripts](https://github.com/simonw/claude-code-transcripts) — Simon Willison's transcript tooling.
- [simonw/research](https://github.com/simonw/research) — his research project scaffolding.
- [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) — curated skills/hooks/commands/agents.
- [citypaul/.dotfiles](https://github.com/citypaul/.dotfiles) — the CLAUDE.md that went viral.
- [zircote/.claude](https://github.com/zircote/.claude) — domain-specific agents (backend/frontend/DevOps/security/data-ML), Opus 4.5 optimizations.
- [ryoppippi/dotfiles](https://github.com/ryoppippi/dotfiles/blob/main/CLAUDE.md) — another heavily-tuned CLAUDE.md.
- [elizabethfuentes12/claude-code-dotfiles](https://github.com/elizabethfuentes12/claude-code-dotfiles) — git-sync pattern for `~/.claude`.
- [serpro69/claude-toolbox](https://github.com/serpro69/claude-toolbox) — opinionated 10-skill development pipeline.
- [wshobson/agents](https://github.com/wshobson/agents) — multi-agent orchestration patterns.
- [ThariqS](https://github.com/ThariqS) — Thariq's own GitHub; worth tracking for CC-team-adjacent experiments.
- [kieranklaassen](https://github.com/kieranklaassen) — Every/Cora's GM; compound-engineering artifacts.
