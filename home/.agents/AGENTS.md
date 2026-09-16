## Machine-local additions

If a `~/.agents/AGENTS.local.md` is present, read that as well. Any overrides there take priority. It holds what is true of this machine alone — client rules, environment specifics, local paths, anything not worth committing — and it wins wherever it contradicts this file. It is gitignored and often absent; when it is, carry on without mentioning it.

## Rules

- **no line wrapping**: when writing docs, such as markdown, don't wrap lines manually.

## Always-on skills

Load these without waiting for a description match: `comments`, `unslop`. unslop covers commit messages, PR bodies, and replies to me, not just docs.
