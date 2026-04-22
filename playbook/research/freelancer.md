# Freelancer Scout — Report

Scope: how indie devs, freelancers, and small agencies are wrapping Claude Code around client work as of Apr 2026. Sources are a mix of Reddit/IH discussions, AI-coding blogs, and GitHub template repos. Paraphrased throughout.

## Context-isolation patterns for multi-client work

1. **Per-client profile directory via `claude-code-profiles`** — Quinn JR / Pegasus Heavy's profile switcher treats each client as a full sandboxed config dir (settings, credentials, MCP servers, CLAUDE.md, history). Operators create profiles like `client-acme`, `work`, `personal` and switch between them instead of logging in/out. Useful when clients require you to use their Anthropic billing or their Max seat. https://github.com/pegasusheavy/claude-code-profiles  https://zitao.dev/posts/claude-profile/
2. **Committed `.claude/settings.json` per repo + `~/.claude/settings.json` as personal deny list** — project-scoped settings live in the client repo (and ship with the handoff), while global settings hold deny rules that cannot be overridden by a local allow. Matches Anthropic's documented multi-scope hierarchy. https://code.claude.com/docs/en/settings  https://egghead.io/organizing-personal-and-project-settings-in-claude-code~q7qsw
3. **Devcontainer-per-client** — Trail of Bits' `claude-code-devcontainer` (bypass-mode sandbox) is being adapted by freelancers so each client repo gets its own container, volumes, and secrets. Prevents credential bleed between engagements and is the mainstream recommendation for "one-off reviews or untrusted repos." https://github.com/trailofbits/claude-code-devcontainer  https://code.claude.com/docs/en/devcontainer
4. **Git worktrees for parallel feature work inside one client** — `claude --worktree <name>` puts each task in `.claude/worktrees/<name>/` with its own branch and context, so you can run 2–3 Claude sessions against one codebase without file collisions. Boris Cherny (Anthropic) promotes this on Threads. Pair with `--tmux` for session multiplexing. https://www.threads.com/@boris_cherny/post/DVAAoZ3gYut  https://claudefa.st/blog/guide/development/worktree-guide
5. **MemClaw / project-scoped memory layer** — third-party add-on that gives each project isolated persistent memory loaded at session start. Pitched specifically at the "context from Client A bleeding into Client B" problem that static CLAUDE.md and worktrees don't solve. https://felo.ai/blog/claude-code-multi-project/
6. **Parent-dir devcontainer + multiple cloned repos** — for agencies with several repos per client, a shared devcontainer wraps the client's repos with shared volumes, letting one container serve an ongoing engagement. https://code.claude.com/docs/en/devcontainer

## Billing and disclosure norms

- **Mainstream**: AI freelancers charging $100–200/hr are holding hourly rates steady and pocketing the productivity gain. Indie Hackers threads broadly agree hourly "pays you for being slow" — fixed-fee or weekly retainer is the pro-AI move because you keep the margin on speed. https://www.indiehackers.com/post/skip-the-hourly-rate-charge-a-flat-weekly-rate-instead-67e571de94  https://www.thirdwork.xyz/rate-guides/Hourly-rate-for-ai-engineer-freelancers
- **Value/outcome pricing** is the most repeated recommendation in Claude-Code-specific freelancer writeups: AI Builder Club's widely-shared post argues a $5K website built in 3–4 days (vs 2 weeks) should stay $5K, taking monthly capacity from 2 to 5–6 projects. https://www.aibuilderclub.com/blog/claude-code-for-freelancers
- **Controversial**: race-to-the-bottom hourly on Freelancer.com/Upwork ($8–12/hr full-stack + Claude/Cursor/Copilot postings). Most indie voices treat this as a warning, not a model. https://freelancehunt.com/en/project/full-stack-rozrobnik-vibe-coding/1621321.html
- **Disclosure norm forming**: "review outputs, cite sources for facts, label AI-assisted work where expected." Hidden AI use is increasingly called out as a contract breach risk; several legal blogs recommend contracts either whitelist approved tools or require written consent before use. https://tasconlegal.com/ai-clauses-in-contracts-the-practical-guide-for-2025/  https://deanusher.com/ai-clauses-freelance-contracts/
- **Time-tracking nuance**: no one seriously tracks "AI-assisted minutes" separately. The consensus on IH is either (a) bill a flat fee, or (b) bill hourly at your normal rate and don't break it out — clients hired your judgment, not your keystrokes. https://www.indiehackers.com/post/freelancers-and-consultants-what-are-your-rates-1dbdb59c7f

## Client-facing deliverable templates

Patterns that keep showing up:

- **HANDOFF.md** as a canonical deliverable artifact. `willseltzer/claude-handoff` ships `/handoff:create`, `/handoff:quick`, `/handoff:resume` slash commands. The required sections: goal, progress, what worked, what didn't, next steps, and — critically — failed approaches with reasons. Freelancers are repurposing this from agent-to-agent to dev-to-client. https://github.com/willseltzer/claude-handoff
- **Auto-generated README via a README-generator skill** (GLINCKER marketplace) that introspects structure, deps, and code patterns. Pairs with a hand-written "Ops" section. https://github.com/GLINCKER/claude-code-marketplace/blob/main/skills/documentation/readme-generator/SKILL.md
- **One-page case-study PDF** (problem / solution / ROI / metrics) as the sales artifact — trust signal consensus across Consultport and Keepertax writeups. https://consultport.com/succeed-as-consultant/how-to-create-a-great-consulting-case-study-portfolio-as-a-freelancer/
- **CLAUDE.md in the repo as living spec** — shipped to the client so they (or their next dev, human or AI) can resume work. Three-tier pattern from `abhishekray07/claude-md-templates`: global `~/.claude/CLAUDE.md` (yours, stays with you), project `.claude/CLAUDE.md` (ships), local `./CLAUDE.local.md` (yours, gitignored). https://github.com/abhishekray07/claude-md-templates
- **Sub-agent lifecycle boilerplate** like `shinpr/ai-coding-project-boilerplate` (20+ sub-agents for req analysis → QA → reverse-engineering) — some agencies hand the whole `.claude/` folder to clients as part of the deliverable so future work is reproducible. https://github.com/shinpr/ai-coding-project-boilerplate

## Contract / legal additions for AI work

Clauses reported across Tascon, Dean Usher, Michalsons, Odin Law, Rodriques Law:

- **Tool whitelist**: explicitly name approved tools (Claude Code, Cursor, Copilot). Forbids others without written consent.
- **No-training clause**: "Provider will not submit Client data, code, or IP to any AI service that retains inputs for training." Anthropic's commercial terms already cover this for Claude Code, but clients want it on paper from you.
- **Human-in-the-loop / originality language**: all AI-generated output is reviewed and validated by a qualified human (you) before delivery; you retain final editorial/quality control. This is also what makes the output copyrightable.
- **IP assignment with moral-rights waiver** — standard work-for-hire language won't carry AI output alone because US copyright requires human authorship; contracts must therefore assign whatever IP *does* exist (your human-authored edits, selection, arrangement) explicitly to the client. https://www.movingavg.com/essays/ai-generated-content-and-ai-ip-ownership-in-us-law.html  https://www.terms.law/forum/thread/ai-generated-code-ownership-employer-vs-developer.html
- **Disclosure-and-approval flow** with timeline and named signatory.
- **Audit right + breach-notice** — client can request a log of tools used; you must notify within N days if a tool was used outside scope.
- **Indemnity carve-out** for third-party IP claims arising from AI-generated code (some clients push this onto you; push back — you can't warrant training-data cleanliness).

`zubair-trabzada/ai-legal-claude` is a CC skill pack that generates these clauses; `evolsb/claude-legal-skill` does CUAD-style risk scoring. Both useful as drafting aids. https://github.com/zubair-trabzada/ai-legal-claude  https://github.com/evolsb/claude-legal-skill

## Portfolio presentation

- **Don't lead with "built with AI"** — lead with outcome, stack, metrics. AI tooling goes in a methodology footer at most. The freelancers writing about this publicly (AI Builder Club, Resumly) all say clients pay for judgment and outcomes; prominently advertising AI pushes rates down.
- **Case study with before/after metrics** (time-to-ship, cost saved, bugs caught) beats screenshots. This is the same consulting-portfolio pattern, AI-era.
- **GitHub as trust signal** — committed `.claude/` config, CLAUDE.md, and handoff docs in public template repos become the portfolio. Upwork verified badge + a GitHub org with 2–3 polished case-study repos is the 2026 baseline. https://www.resumly.ai/blog/freelance-portfolio-that-wins-for-software-engineers-in-2026
- **If asked directly about AI use**: honest, specific, confident — "Claude Code writes ~60% of boilerplate under my direction; I do architecture, review, and testing." The consulting writeups are clear that evasiveness is the thing that tanks trust, not the AI use itself.

## Flagged for Billington Works

Concrete, commercially-loaded recommendations for Brent:

1. **Stand up one CC profile per active client** using `claude-code-profiles`. Name them `bw-<client>`. Each gets its own `~/.claude/profiles/bw-<client>/` with scoped MCP, credentials, and CLAUDE.md. Zero credential/data bleed; also gives you a clean audit trail if a client asks.
2. **Commit `.claude/settings.json` into every client repo** with a project-specific allow list and a `deny` on reading anything matching `.env*`, `*.pem`, `secrets/**`. Your personal `~/.claude/settings.json` should deny the same things globally as a belt-and-braces.
3. **Move to fixed-fee or weekly-retainer pricing** for any engagement where scope is stable. Hourly for discovery and open-ended consulting only. This is the single highest-leverage change — you capture the Claude Code speedup as margin instead of giving it back to clients.
4. **Write a Billington Works AI addendum** (one page) with: tool whitelist, no-training warranty, human-review clause, IP assignment of your human contributions, 72-hour breach-notice. Attach to every SOW. Use `ai-legal-claude` to draft, have a lawyer review once, then reuse.
5. **Adopt HANDOFF.md + auto-README as standard deliverables.** Every project ships with `/handoff:create` output + generated README + `.claude/` folder. Differentiator vs competitors and it makes your own re-engagement (maintenance contracts) trivial.
6. **Don't disclose AI use proactively in sales copy; do disclose clearly if asked or in the contract.** Positions you as a senior operator who uses good tools, not a "vibe coder."
7. **Track one metric publicly**: average project turnaround. "Typical 5-page marketing site: 4 days" is a stronger hook than any rate table and justifies fixed-fee pricing.
8. **Keep a Billington-Works-branded template repo** (private, forkable) with pre-wired CLAUDE.md, `.claude/settings.json`, devcontainer, HANDOFF template, AI addendum boilerplate. Every new client = `gh repo create --template`. This is your moat.

## Promising repos for deep-dive

- `pegasusheavy/claude-code-profiles` — profile switcher. https://github.com/pegasusheavy/claude-code-profiles
- `trailofbits/claude-code-devcontainer` — sandbox, good base for per-client containers. https://github.com/trailofbits/claude-code-devcontainer
- `shinpr/ai-coding-project-boilerplate` — full sub-agent lifecycle, steal the structure. https://github.com/shinpr/ai-coding-project-boilerplate
- `willseltzer/claude-handoff` — handoff slash commands. https://github.com/willseltzer/claude-handoff
- `abhishekray07/claude-md-templates` — three-tier CLAUDE.md pattern. https://github.com/abhishekray07/claude-md-templates
- `davila7/claude-code-templates` — 600+ agents, 200+ commands, pick the client-work relevant ones. https://github.com/davila7/claude-code-templates
- `halans/cc-marketplace-boilerplate` — scaffold for packaging your own reusable CC plugin/skill for resale. https://github.com/halans/cc-marketplace-boilerplate
- `zubair-trabzada/ai-legal-claude` + `evolsb/claude-legal-skill` — contract drafting/review skills. https://github.com/zubair-trabzada/ai-legal-claude  https://github.com/evolsb/claude-legal-skill
- `GLINCKER/claude-code-marketplace` README generator skill — drop into handoff pipeline. https://github.com/GLINCKER/claude-code-marketplace
