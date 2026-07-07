# Flux Skills

Two [Claude Code](https://docs.claude.com/en/docs/claude-code) skills for running Claude as an orchestrator instead of a lone worker.

| Skill | What it does |
|-------|--------------|
| **flux-delegation** | Puts the model into **architect/orchestrator mode** — it plans, decomposes, delegates to a team of specialized subagents (builder, verifier, scout, advisor), and reviews. It stops grinding through work a cheaper agent can do to spec, and spends its own tokens only on decisions, synthesis, and review. |
| **flux-loop** | Runs **sustained autonomous execution** toward a checkable goal — the Ralph-loop pattern. Keeps working, verifies its own progress against real evidence every cycle, and only stops when explicit stopping criteria are met. Built to defeat "agentic laziness" (stopping before the task is actually done). |

They compose: `flux-delegation` builds the team, `flux-loop` drives it toward a goal unattended.

## Install

Skills live in `~/.claude/skills/`. Clone and copy:

```bash
git clone https://github.com/adrective-oss/flux-skills.git
cp -R flux-skills/flux-delegation flux-skills/flux-loop ~/.claude/skills/
```

Or run the installer (copies both, prompts before overwriting):

```bash
./install.sh
```

Restart Claude Code (or start a new session) and the skills are available.

## Use

- **flux-delegation** — invoke at the start of a project or session when the work is big enough to warrant a team, not for one-turn questions or single-file edits.
- **flux-loop** — invoke *after* flux-delegation has built the team, when you want long-horizon work that runs unattended toward a goal you can state as a finish line (e.g. "all tests in `/tests` pass and lint is clean").

Both are model-agnostic. `flux-delegation` ships four subagent definitions (`flux-delegation/agents/`) that route work by cost: `builder` (sonnet, implementation), `verifier` (haiku, mechanical pass/fail gate), `scout` (haiku, read/map without polluting orchestrator context), `advisor` (sonnet, second opinions).

## What's a skill?

A [Claude Code skill](https://docs.claude.com/en/docs/claude-code/skills) is a folder with a `SKILL.md` that Claude loads on demand when the task matches its description. No code to run — just instructions Claude follows.

## License

See [LICENSE](LICENSE).
