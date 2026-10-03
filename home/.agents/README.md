# Agent config shared across harnesses

Various skills, references, commands and agents are vendored from https://github.com/addyosmani/agent-skills (version 0.6.11).

## Updating

Run `./scripts/update-agent-skills.sh` from the repo root to update to the latest upstream tag, or pass a tag (`./scripts/update-agent-skills.sh 0.6.12`) to pin one. Passing the current version re-syncs it. `--dry` previews the changes. The script reads the current version from the line above and bumps it when done.

Every upstream file overwrites its local copy, hand edits included. Review the result with `git diff`, and bring back the hand edits worth keeping with `git restore -p -- home/.agents`. Upstream files deleted locally come back, so drop them again if still unwanted.

`.vendored-files` lists what the last update installed: skill folders, and single files under `agents/`, `commands/` and `references/`. The next update deletes anything listed that the new version no longer ships, and makes each listed skill folder match upstream exactly, so stray files inside one are deleted too. Anything unlisted, like the `comments`, `omarchy` and `unslop` skills, is never touched. The script rewrites the list on every run, so don't edit it by hand.

## Local patches

The script applies these to every upstream file automatically, so they never need redoing by hand:

- `agent-skills:` namespace stripped from commands, since the skills aren't installed as a plugin.
- `.claude/commands/plan.md` renamed to `commands/planning.md`, because `/plan` collides with the built-in plan mode.
- `mode: subagent` added to agent frontmatter, otherwise OpenCode treats them as primary agents.

Anything else, such as the OpenCode notes in `browser-testing-with-devtools` and the rewording in commands, is a hand edit that each update overwrites.
