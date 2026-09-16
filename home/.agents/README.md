# Agent config shared across harnesses

`skills/`, `references/`, `commands/` and `agents/` are vendored from
https://github.com/addyosmani/agent-skills (plugin version 0.6.9).
`scripts/set-symlinks.sh` links them into each harness:

- OpenCode: `~/.config/opencode/{commands,agents}` -> here. Skills are found
  through `~/.agents/skills`, which OpenCode scans on its own.
- Claude Code: `~/.claude/{commands,agents}` -> here, `~/.claude/skills/<name>`
  per skill, and `~/.claude/references`. The `agent-skills` plugin must be
  disabled, or every skill and command shows up twice (bare and namespaced).

## When syncing from upstream

Copy `skills/`, `references/`, `.claude/commands/` -> `commands/`, `agents/`,
then re-apply the local edits below or the files break outside the Claude plugin:

1. **Strip the plugin namespace** in commands. Upstream says
   `agent-skills:spec-driven-development`; the bare name is what exists here.

   ```sh
   sed -i 's/agent-skills://g' commands/*.md
   ```

2. **Add `mode: subagent`** to each agent's frontmatter so OpenCode treats
   them as delegates instead of primary agents. Claude Code ignores the key.

   ```sh
   for f in agents/*.md; do sed -i '0,/^description:/s//mode: subagent\ndescription:/' "$f"; done
   ```

3. Keep `references/` beside `skills/`. Skills link to it with `../../references/`.

## Global instructions

`AGENTS.md` here is local, not vendored. It holds the rules that apply to every
session on this machine. `set-symlinks.sh` links it to `~/.claude/CLAUDE.md`;
OpenCode reads it through `instructions` in `opencode.json`.

`AGENTS.md` also tells the agent to read `AGENTS.local.md` beside it, for rules
that belong to one machine and not the repo. That one is gitignored, so create
it by hand where you want it — there is nothing to sync.

## Session-start context

`hooks/session-start.sh` prints the `using-agent-skills` meta skill, replacing
the plugin's jq-based hook. OpenCode does not run shell hooks, so it loads the
same file through `instructions` in `home/.config/opencode/opencode.json`.
Claude Code runs the script from the `SessionStart` hook in
`home/.claude/settings.json`.
