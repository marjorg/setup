# Agent config shared across harnesses

Various skills, references, commands and agents are vendored from https://github.com/addyosmani/agent-skills (version 0.6.12). These single skills are vendored from repos that don't tag releases, so they're pinned by commit:

- `unslop` from https://github.com/cursor/plugins/tree/main/pstack/skills/unslop (commit 70b2dc8)
- `diagram-design` from https://github.com/cathrynlavery/diagram-design/tree/main/skills/diagram-design (commit none)

## Updating

Run `./scripts/update-agent-skills.sh` from the repo root to update to the latest upstream tag, or pass a tag (`./scripts/update-agent-skills.sh 0.6.12`) to pin one. Passing the current version re-syncs it. Each single skill always moves to the last commit that changed it. `--dry` previews the changes. The script reads the current version and commits from the lines above and bumps them when done. To vendor another single skill, add it to `SKILL_SOURCES` in the script and add a line above ending in `(commit none)`.

Every upstream file overwrites its local copy, hand edits included. Review the result with `git diff`, and bring back the hand edits worth keeping with `git restore -p -- home/.agents`. Upstream files deleted locally come back, so drop them again if still unwanted.

`.vendored-files` lists what the last update installed: skill folders, and single files under `agents/`, `commands/` and `references/`. The next update deletes anything listed that the new version no longer ships, and makes each listed skill folder match upstream exactly, so stray files inside one are deleted too. Anything unlisted, like the `comments` and `omarchy` skills, is never touched. The script rewrites the list on every run, so don't edit it by hand.

## Local patches

The script applies these to every upstream file automatically, so they never need redoing by hand:

- `agent-skills:` namespace stripped from commands, since the skills aren't installed as a plugin.
- `CLAUDE.md` renamed to `AGENTS.md` everywhere, since `AGENTS.md` is the one rules file here and Claude Code reads it through a `CLAUDE.md` symlink. Phrases naming both, like "`AGENTS.md` or `CLAUDE.md`", collapse to just `AGENTS.md`.
- `.claude/commands/plan.md` renamed to `commands/planning.md`, because `/plan` collides with the built-in plan mode.
- `mode: subagent` added to agent frontmatter, otherwise OpenCode treats them as primary agents.
- `disable-model-invocation` removed from `unslop`, which upstream set so it only runs as `/unslop`. It's meant to apply to all writing.

Anything else, such as the OpenCode notes in `browser-testing-with-devtools` and the rewording in commands, is a hand edit that each update overwrites.
