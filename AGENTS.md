# dotfiles

Personal dotfiles + machine setup for Arch Linux running Omarchy. No app code,
no test suite — the deliverable is idempotent shell scripts and symlinked
config, and "correctness" means re-running them doesn't break a live machine.

## Structure

- `install.sh` — package installer. Sources every `installs/*.sh`, collects
  package-array declarations from each, then installs them (pacman → yay →
  mise → go → bun → VS Code extensions), skipping anything already installed
  unless `--update` is passed.
- `installs/*.sh` — one file per tool/app group (e.g. `go.sh`, `rust.sh`,
  `apps-coding.sh`). Each just appends to shared arrays (`PACMAN_PACKAGES`,
  `YAY_PACKAGES`, `MISE_PACKAGES`, `GO_PACKAGES`, `BUN_PACKAGES`,
  `VSCODE_EXTENSIONS`) and optionally defines `pre_install()` / `post_install()`
  hook functions. These files are *sourced*, not executed — see Gotchas.
- `setup.sh` — post-install machine setup: GPG/SSH key generation, git config
  templating, symlinking, background sync, Chromium policy files.
- `scripts/*.sh` — helpers called by `setup.sh` (and `install.sh` via
  `utils.sh`). `set-symlinks.sh` is the one you'll touch most: it links
  `home/` into `$HOME`.
- `templates/*.tmpl` — `gomplate` templates (currently just git config),
  rendered with env vars exported by the corresponding `scripts/*.sh`.
- `home/` — mirrors `$HOME`. Everything under here gets symlinked in place by
  `scripts/set-symlinks.sh`; nothing here is copied.
- `home/.agents/` — shared skills/commands/agents config, vendored from the
  upstream `agent-skills` plugin and synced into both Claude Code and
  OpenCode. See `home/.agents/README.md` before editing anything under here —
  it documents the local patches you must reapply after a sync.
- `backgrounds/` — wallpaper images synced into the active Omarchy theme.

## Commands

- Full install: `./install.sh` (add `--dry` to preview, `--debug` for verbose
  logging, `--update` to force-check every package instead of skipping
  installed ones, `--work` to skip personal-only packages, `--name`/`--email`
  to set the git identity).
- Post-install machine setup (symlinks, keys, git config, backgrounds):
  `./setup.sh` (same flags as above).
- Just symlinks (fastest loop when editing `home/`): `./scripts/set-symlinks.sh`.
- Lint a shell script before committing: `shellcheck path/to/script.sh`
  (installed via `installs/terminal.sh`; there's no CI, so this is manual).
- There is no test suite and no build step — verification is `--dry` runs,
  `shellcheck`, and reading the diff.

## Conventions

- Every script starts `#!/bin/bash`; scripts that are executed directly (not
  sourced) add `set -euo pipefail` right after sourcing `utils.sh`.
- Scripts that need flags/logging resolve their own directory and source
  `scripts/utils.sh "$@"` first — this parses `--dry`/`--debug`/etc. and
  defines `log`, `debug`, `execute`.
- Nothing is hardcoded to one person's identity. Scripts that need a name or
  email call `require_identity` (from `utils.sh`) before reading
  `$NAME`/`$EMAIL`. It takes `--name`/`--email` when given, else reads
  `$XDG_CONFIG_HOME/dotfiles/identity`, else prompts once and saves the answers
  there. Call it only where the values are needed, so a plain `./install.sh`
  never stops to ask. A flag that contradicts the stored identity asks before
  overwriting it; declining, or having no TTY, uses the new values for that run
  only.
- Use `execute cmd ...` (not a bare command) for anything that mutates the
  system, so `--dry` can no-op it. Use `log` for user-visible output (also
  written to `install.log`) and `debug` for verbose-only output.
- `installs/*.sh` files only declare arrays and optional `pre_install`/
  `post_install` functions — they don't run anything at top level.
- Package lists are deduplicated and sorted by `install.sh`, not by the
  individual `installs/*.sh` file — don't hand-sort or dedupe locally.
- Symlinks go through the `link()` helper in `set-symlinks.sh`, which handles
  the "real directory already exists at destination" case by renaming it to
  `.bak`. Add new links there rather than open-coding `ln -s`.
- Commit messages follow Conventional Commits with a scope:
  `type(scope): summary`, lowercase, imperative (e.g. `fix(zed): file panel
  indent size`, `feat(mise): add uv to managed tools`). Common types seen:
  `feat`, `fix`, `chore`, `docs`, `build`.
- Comments explain *why*, not *what* — see the AUR-vs-extension comment in
  `installs/java.sh` or the `.bak` rename comment in `set-symlinks.sh` for the
  house style. Don't add comments restating the line below them.

## Things a newcomer would get wrong

- **Don't edit `home/.agents/{skills,references,commands,agents}` freely.**
  They're vendored from an upstream plugin (`addyosmani/agent-skills`); local
  patches (stripped plugin namespace, `mode: subagent` frontmatter, etc.) must
  be reapplied after every sync. Read `home/.agents/README.md` first.
- **`installs/*.sh` files are sourced by `install.sh`, not run standalone.**
  They have no shebang execution path of their own — they rely on the arrays
  and `$WORK`/`$UPDATE_MODE` vars already existing in the parent script's
  scope. Running one directly does nothing useful.
- **Editing files under `$HOME` directly doesn't persist.** Real config lives
  under `home/` in this repo; `$HOME` paths are symlinks onto it. If a symlink
  didn't exist yet, `set-symlinks.sh` will have renamed whatever real
  directory was there to `<name>.bak` — check for that before assuming data
  was lost.
- **`.gitignore` allow-lists specific files inside otherwise-ignored config
  dirs** (`home/.config/Code/**`, `home/.config/omarchy/**`,
  `home/.config/opencode/**`). Adding a new file under one of these
  directories requires an explicit `!home/.config/.../newfile` negation line,
  or it silently won't be tracked.
- **`install.log` and `myfile.txt`-style stray files aren't part of the
  project.** `*.log` is gitignored; don't treat local log output or scratch
  files in the repo root as something to preserve or clean up as part of a
  change.
- **This only targets Omarchy.** `setup.sh`'s bootstrap (see `README.md`)
  hard-fails on any other `/etc/os-release` `ID`. Don't add generic-Linux
  fallbacks without checking whether that's actually wanted.
- **Identity prompts fail instead of hanging without a TTY.** `require_identity`
  errors out when stdin isn't a terminal and no identity is on disk. CI or
  piped runs must pass `--name`/`--email`, or pre-seed
  `$XDG_CONFIG_HOME/dotfiles/identity` (`name=` / `email=`, one per line).
- **`--dry` only fakes `execute`, not everything.** Code paths that check
  system state directly (e.g. `pacman -Q`, `[[ -d ... ]]`) still run for
  real during a dry run; only the mutating command itself is skipped and
  logged instead.
