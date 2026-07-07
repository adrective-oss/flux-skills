<div align="center">

# Flux Skills

**Turn Claude from a lone worker into an orchestrator with a team.**

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-skills-d97757.svg)](https://docs.claude.com/en/docs/claude-code/skills)
![Skills](https://img.shields.io/badge/skills-2-black.svg)

</div>

Two [Claude Code](https://docs.claude.com/en/docs/claude-code) skills that change *how* Claude works on big tasks — it plans, delegates to cheaper specialized subagents, and verifies their output against real evidence instead of grinding through everything itself.

| Skill | What it does |
|-------|--------------|
| **`flux-delegation`** | Puts the model into **architect/orchestrator mode**. It interviews you, designs a team of specialized subagents (builder, verifier, scout, advisor), routes each piece of work to the cheapest capable agent, and reviews. It spends its own expensive tokens only on decisions, synthesis, and review. |
| **`flux-loop`** | **Sustained autonomous execution** toward a checkable goal — the Ralph-loop pattern. Plan → Act → Observe → Verify → Decide, every cycle, verifying progress against real evidence. Built to defeat *"agentic laziness"* — the model quitting before the task is actually done. |

They compose: `flux-delegation` builds the team, `flux-loop` drives it toward a goal unattended.

## Why

The most expensive tokens in a session are the top model's. Every file it reads, scan it runs, or line of boilerplate it writes is a token stolen from the judgment work only it can do. Flux fixes the economics:

- **Route by cost, not prestige.** Haiku scans and runs checks. Sonnet implements. The top model decides. A cheap agent with an elite brief beats an expensive one with a vague one.
- **Verify in tiers.** Mechanical checks (tests/lint/build) run on a cheap verifier first; quality review only on what passes; the orchestrator reviews only architecture and synthesis. Nothing failing a lower tier reaches a higher one.
- **Trust evidence, not narration.** A subagent's "done" means nothing until it's checked against a tool result — test output, a diff, a log.

## flux-delegation — the team

```mermaid
flowchart TD
    U([You]) -->|interview + goal| A[🧠 Orchestrator<br/>plans · delegates · reviews]
    A -->|read/map, no context bloat| S[🔍 scout · haiku<br/>read-only recon]
    A -->|implementation to spec| B[🔨 builder · sonnet<br/>features · fixes · refactors]
    A -->|mechanical pass/fail| V[✅ verifier · haiku<br/>tests · lint · build gate]
    A -->|second opinion| AD[🎯 advisor · sonnet<br/>persistent senior review]
    B --> V
    V -->|passed| A
    V -->|failed| B
    A -->|SHIPPED · GAPS · NEXT| U

    classDef orch fill:#d97757,stroke:#000,color:#fff
    class A orch
```

The four subagent definitions ship in [`flux-delegation/agents/`](flux-delegation/agents). The team, routing decisions, and open items get written to `.claude/TEAM.md` in your project — so session 2 costs a fraction of session 1.

## flux-loop — the cycle

```mermaid
flowchart LR
    P[Plan] --> Act --> O[Observe] --> V{Verify<br/>vs evidence}
    V -->|progress| D{Decide}
    V -->|flat/failed| P
    D -->|continue| P
    D -->|✅ success| DONE([Report: SHIPPED/GAPS/NEXT])
    D -->|🛑 stuck / budget| DONE
```

It won't start on a vague goal — it interviews for a **checkable finish line** ("all tests in `/tests` pass and lint is clean"), a hard iteration/budget ceiling, and a failure condition, before the first cycle. It commits after every meaningful unit so progress is recoverable and visible without narration.

## Install

Skills live in `~/.claude/skills/`. Clone and copy:

```bash
git clone https://github.com/adrective-oss/flux-skills.git
cp -R flux-skills/flux-delegation flux-skills/flux-loop ~/.claude/skills/
```

Or run the installer (copies both, prompts before overwriting):

```bash
cd flux-skills && ./install.sh
```

Start a new Claude Code session and both skills are available.

## Use

**flux-delegation** — invoke at the start of a project or session when the work is big enough to warrant a team. Not for one-turn questions or single-file edits.

```
> Use flux-delegation. I'm building a REST API with auth, rate limiting, and a
  Postgres layer, production-grade.

Orchestrator: [interviews you on scope, quality bar, constraints]
              [designs a 4-agent team, writes .claude/TEAM.md]
              [delegates the Postgres layer to builder, schema audit to scout,
               runs the test gate on verifier, sanity-checks the design with advisor]

SHIPPED  ✓ auth middleware — 14/14 tests pass (verifier)
         ✓ rate limiter — diff at src/mw/rate.ts, load test 0 drops
GAPS     · Postgres pooling unverified — integration test still red
NEXT     1. Fix pool exhaustion under concurrent writes
```

**flux-loop** — invoke *after* flux-delegation has built the team, when you want long-horizon work that runs unattended toward a goal you can state as a finish line. It inherits the team and `TEAM.md`.

```
> Use flux-loop. Goal: every test in /tests green and lint clean. Max 20 cycles.
  Stop and report if the same test fails 3 times. Don't touch the migrations dir.
```

Both are model-agnostic — they route work across Haiku/Sonnet/Opus by task difficulty, not by which model is running them.

## What's a skill?

A [Claude Code skill](https://docs.claude.com/en/docs/claude-code/skills) is a folder with a `SKILL.md` that Claude loads on demand when your task matches its description. No code to run — just expert instructions Claude follows. These two are pure instructions plus, for flux-delegation, four subagent definitions.

## License

[MIT](LICENSE) — use, modify, redistribute freely.
