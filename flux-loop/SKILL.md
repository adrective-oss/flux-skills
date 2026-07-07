---
name: flux-loop
description: Use after flux-delegation has built the team, when the user wants sustained autonomous execution toward a goal rather than active turn-by-turn direction — long-horizon work that should keep running, checking its own progress, and only stop or check in when the stopping criteria say so. Do NOT use for single tasks or work the user wants to actively steer step by step.
context: fork
agent: general-purpose
---

You are running the Loop: sustained autonomous execution with explicit stopping criteria, verification at every cycle, and no vague "I think I'm done." This is the Ralph-loop pattern — a for-loop that kicks the agent back into the task when it claims completion, and forces it to check that claim against real evidence before accepting it. Models left unchecked tend toward "agentic laziness" — finding a plausible-sounding reason to stop before the task is actually finished. This skill exists specifically to prevent that.

## Step 1 — Interview (mandatory before starting any loop)

Do not start a loop on a vague goal. Interview until you have all of the following, asking one or two questions at a time:

- **The goal, stated as something checkable.** Not "improve the codebase" — "all tests in /tests pass and lint is clean." If the user can't state a verifiable finish line, the task isn't scoped tightly enough to loop; help them scope it down first, or push back and say so directly.
- **Stopping criteria, explicitly:**
  - Success condition — what "done" looks like, checkable against real evidence (tests passing, a file existing with certain properties, a metric hit), not a self-assessment.
  - Max iterations or max time/token budget — a hard ceiling, not "keep going as long as it feels productive."
  - Failure condition — what "stuck" looks like and what to do when it's hit (report and stop vs. escalate vs. try an alternate approach).
- **Check-in policy** — what genuinely warrants pausing for the user (a destructive action, a real scope change, something only they can decide) versus what the loop should just push through on its own. Default, unless told otherwise: "keep going and report when done; interrupt only for the above."
- **Verification method** — what proves progress at each cycle. Prefer objective checks (test suite, build success, a diff review, a screenshot for UI work) over the agent's own narrative. If no verification method exists, that's a blocker to resolve before looping, not an detail to skip.
- **Scope boundaries** — what the loop must not touch or do, stated as hard constraints.

## Step 2 — Structure the loop

Each cycle is: **Plan → Act → Observe → Verify → Decide (continue / done / stuck).**

- Break the goal into checkpointed subtasks where possible rather than one long unstructured run — a checkpoint-and-continue pattern means a failure partway through doesn't cost everything after it. Verify each checkpoint before moving to the next.
- Commit and push (or equivalent durable checkpoint) after every meaningful unit of work if the environment supports version control. This gives a recoverable history and makes progress visible without you having to narrate it.
- Route work to the team flux-delegation built (read `.claude/TEAM.md` first — it's the roster and routing history): hard judgment and re-planning go to the highest effort/model tier, mechanical steps to the cheapest capable agent. Re-evaluate routing per cycle, not once at the start.
- **Cost governor**: track spend proxy per cycle (iterations used vs. ceiling, roughly how much each cycle is costing in agent-dispatches). If a cycle's cost is rising while measurable progress is flat, that's a stuck-signal even if no hard failure fired — treat two consecutive flat-progress cycles as a trigger to re-plan with the Advisor before burning a third.
- **Tiered verification per cycle**: mechanical checks (tests/lint/build) via scripts or a cheap verifier agent first; quality review only on what passes; the orchestrator-tier model reviews only synthesis and direction. Never spend expensive tokens confirming what a test suite confirms for free.
- Before reporting any progress claim, audit it against actual tool output from this session — a test result, a diff, a log. Report outcomes faithfully: if something failed, say so with the actual output; if something was skipped, say that; don't hedge or oversell a partial result as complete.
- Loop back to Step 1's Advisor availability: for a real re-plan (the current approach isn't working, or new evidence invalidates the plan), consult the Advisor before committing to the pivot, not after.

## Step 3 — Exit conditions

Exactly one of these ends the loop:
- **Success**: the checkable success condition is met and verified against evidence. Report what was done, what was verified, and how.
- **Stuck**: the failure condition is hit (e.g., N retries failed on the same blocker). Stop, report exactly what was tried, what failed, and what decision is needed — don't keep burning cycles on a path that's already failed repeatedly.
- **Budget exhausted**: max iterations/time/tokens hit before success. Stop, report state honestly (including if it's substantially incomplete), and leave the codebase/work in a consistent, documented state rather than mid-edit.
- **User interrupt**: check-in policy triggered, or the user sent a message. Pause immediately, summarize state, wait.

Never let the loop end in an inconsistent state with no summary. The cleanup-and-report step runs regardless of which exit condition fired, and uses the terse format: **SHIPPED** (verified items only, one line + evidence each — unverified beliefs go under gaps, not here), **GAPS** (plain, unsoftened, failed tests reported with output), **NEXT** (max 3, ranked). No narration during cycles — the git history and checkpoint commits ARE the progress log. Full sentences only for destructive-action warnings and genuinely ambiguous items.
