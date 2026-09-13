---
name: delegating
description: Delegate work to subagents, one at a time or many at once. Use when reading or searching would flood your context, when several pieces of work can run side by side, or when the user asks for subagents or parallel work.
---

# Delegating

A **subagent** is a second agent you dispatch with a written brief. It buys two things: its reading never enters your context, and several of them run at once. It costs one thing: the agent starts **cold**, holding nothing of this conversation, so the brief is the whole contract.

## 1. Decide whether to delegate

Delegate work whose byproducts you do not need. A search across a hundred files, a dependency audit, a research read, a review of a long diff: you want the conclusion, and the agent absorbs the pages it read to reach it.

Keep the work when writing the brief costs more than doing it, or when the judgment is yours and you need to watch it form. A subagent hands back a conclusion, not the thinking that produced it.

## 2. Shape the dispatch

- **Read-only agents never collide.** Search, research, and review run as wide as the question has independent parts.
- **Writers collide.** Two agents editing one working directory overwrite each other. Run one writer at a time, or give each its own isolated checkout: call the Skill tool with "worktrees".
- **Chain where output feeds input.** An agent that needs another's result waits for it, so only work whose inputs already exist goes out together.

Where your harness allows it, dispatch every parallel agent in one batch of calls. Spawning them one call at a time runs them in sequence, whatever the tool is named.

## 3. Brief each agent

Write the brief the way [../triage/AGENT-BRIEF.md](../triage/AGENT-BRIEF.md) describes: behaviour rather than procedure, acceptance criteria it can check itself, and an explicit boundary around what is out of scope. Then add the four things a cold agent needs that a colleague in this conversation would not:

- **The skills it needs.** It inherits none of the ones you have loaded, so name them.
- **Where its output goes.** Give it a file path, and ask for a reply of one status line plus that path. Whatever it prints back sits in your context and is re-read on every later turn, so a full report in the reply costs you the context the subagent was meant to save.
- **Where to stop.** What done looks like, what it leaves untouched, and whether it commits its own work (name the "git-commits" skill if it does).
- **Which agent type and model.** An unnamed model inherits yours, so yours is the ceiling: reach above it only when the user asks for that. Reach below it whenever the work is small enough, which is more often than it feels. A mechanical edit against a complete spec runs on the cheapest tier the harness offers, and integration work on the middle one. When a piece genuinely looks harder than your own tier, ask for the better model while you are presenting the work, and name what makes it hard. That is the one moment the ask is cheap: after a failed round it has already cost a wasted dispatch, and raised mid-fan-out it parks you while the rest run.

  All of this needs you to know what this harness actually offers, so where you do not, leave the model unnamed rather than guessing at a name that may not exist.

Nothing else belongs in a dispatch. Pasting the session's history into a brief is the common failure: a fresh agent needs its own task and the interfaces it touches, and the rest is load it pays for on every turn.

## 4. Collect

Keep working while they run. Ledger updates, the next brief, reading a finished report: all of it beats sitting in a wait loop, and results arrive on their own.

Read each agent's output file rather than asking it to repeat itself. Then verify rather than trust the report: an agent grading its own work is the least reliable reviewer of it, so run the tests and read the diff yourself.

When one comes back wrong, re-dispatch with the specific finding in hand, never the same prompt again. A missed detail goes back to the same agent type. Work the agent misunderstood goes up a tier, because the second attempt fails the same way otherwise, and once that reaches your own model the escalation is over: take the task back yourself, or tell the user what it would cost to go higher.
