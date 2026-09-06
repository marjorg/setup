---
name: worktrees
description: Run several agents at once on one project, each isolated in its own git worktree. Use when fanning work out to parallel agents, or when a change needs isolation from the current checkout.
---

# Worktrees

A **worktree** gives an agent its own working directory and branch on one shared repository. That is what makes a **fan-out** possible: several agents building different slices of the same project at once, none of them able to overwrite another's edits.

Fan out through the four steps below. A single agent that only needs isolation from your current checkout takes step 2 alone.

## 1. Slice to the frontier

Agents running in parallel cannot see each other's work, so only the **frontier** goes out together: the slices whose blockers are all already merged. A slice that needs another's output waits for that merge rather than running beside it. If the work is not sliced yet, call the Skill tool with "to-tickets" to break it into tracer bullets with blocking edges.

Then check the frontier for **collision**: slices that edit the same file, rename the same symbol, touch the same migration or lockfile, or need the same port or test database. Untangling that at merge time usually costs more than the parallelism bought, so sequence colliding slices instead, or give one agent both. A wide refactor collides with everything, so land it alone and fan out on top of it.

**Present the slice plan and get approval before dispatching**: one line per slice, naming what it delivers and which files it owns.

## 2. Give each agent its own worktree

Use the first of these your harness has:

1. **Isolation on the spawn call**, if the agent-spawning tool takes a worktree option. The harness then owns placement, branching, and cleanup.
2. **A worktree tool or command** (`EnterWorktree`, `WorktreeCreate`, `/worktree`, a `--worktree` flag).
3. **Plain git**: see [GIT-FALLBACK.md](GIT-FALLBACK.md).

Branch every worktree from the same base commit, the tip you will merge back into, so the branches differ only by their own work. You are already inside a linked worktree when `git rev-parse --git-dir` and `--git-common-dir` disagree; work there rather than nesting another.

## 3. Brief each agent

The agent starts **cold**: a fresh context in a directory it has never seen, with none of this conversation. The brief is the contract. Write it the way [../triage/AGENT-BRIEF.md](../triage/AGENT-BRIEF.md) describes, plus the four things a fanned-out agent needs that a solo one does not:

- **Its slice's ownership.** Name the files, modules, or domain concepts it owns, and say the rest of the repo belongs to a sibling agent working right now. This is what keeps the branches mergeable.
- **Its worktree path and branch name**, and that it works there rather than in the main checkout.
- **Setup.** A fresh worktree carries only tracked files: no `node_modules`, no `.env`, no build cache. Tell it to install and build in place, and where to get the untracked files it needs.
- **Where to stop.** Commit to its own branch (calling the Skill tool with "git-commits"), leave it unmerged, and report back. Integration is yours.

It inherits none of the skills you have loaded, so name the ones its slice needs.

## 4. Integrate

Merge one branch at a time in blocking order, running the test suite between merges so a failure names its own branch. Call the Skill tool with "resolving-merge-conflicts" when one conflicts, and with "code-review" once the last is in.

Then remove each merged worktree (`git worktree remove <path>`, or the harness's exit tool) and delete its branch. A leftover worktree keeps its branch checked out, and git allows that in only one worktree at a time.
