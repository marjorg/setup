# Implementation Plan: Ubuntu support for file setup

## Overview

Make the file-setup scripts (`generate-ssh-key.sh`, `generate-gpg-key.sh`, `write-ssh-config.sh`, `write-git-config.sh`, `set-symlinks.sh`, plus `set-login-logo.sh` and the `copy-*` helpers) run cleanly on an Ubuntu GNOME work desktop, and let the `setup.sh` bootstrap accept Ubuntu. OS detection lives once in `scripts/utils.sh` as `is_omarchy`. Omarchy behaviour must stay byte-identical. Package installation (`install.sh`, `installs/*.sh`) is out of scope. Source of truth: `SPEC.md`.

## Dependency graph

```
scripts/utils.sh: OS_ID + is_omarchy
    │
    ├── scripts/set-login-logo.sh: early exit off Omarchy      (Task 1)
    │
    └── scripts/set-symlinks.sh: Omarchy-only links gated       (Task 2)
            │
            └── Ubuntu container run of all file-setup scripts  (Task 3)
                    │
                    └── README.md + AGENTS.md                   (Task 5)

setup.sh: inline ubuntu check + apt-get git  (Task 4, independent of 1–3)
.zshrc fzf block behind an Omarchy check  (Task 6, independent)
```

## Architecture decisions

- **`is_omarchy` is the only OS check in `scripts/`.** `OS_ID` is read once in `utils.sh` in a subshell (`. /etc/os-release && echo "$ID"`) so `os-release` variables don't leak into script scope. `setup.sh` keeps its own inline check because it runs from curl before the repo exists.
- **Gate by Omarchy, not by Ubuntu.** Scripts ask "is this Omarchy?" rather than "is this Ubuntu?", so the Ubuntu path is simply "the default minus desktop bits" and no per-distro branches appear.
- **Generic `.config/*/` loop skips `hypr` and `uwsm` off Omarchy** via a second `case` arm (`hypr|uwsm) is_omarchy || continue ;;`) rather than moving those dirs or adding an exclude list, so the Omarchy path through the loop is unchanged.
- **The five explicit Omarchy-only `link` calls move into one `if is_omarchy; then … fi` block**, keeping their relative order so the Omarchy run is behaviourally identical.
- **`set-login-logo.sh` exits before any `cmp`/`grep`** on the Plymouth files, so it never touches paths that don't exist on Ubuntu and never reaches `sudo`.
- **Bootstrap uses `sudo apt-get update && sudo apt-get install -y git`.** The `update` is needed because a fresh system (and the test container) has empty package lists.
- **Ubuntu image is `ubuntu:24.04`**, matching the work desktop.

## Task list

Full task detail (acceptance criteria, verification, files) is in `tasks/todo.md`.

### Phase 0: Baseline
- [x] Task 0: Capture the Omarchy link baseline on unmodified `main`

### Phase 1: Foundation and Omarchy safety
- [x] Task 1: `is_omarchy` in `utils.sh`, and `set-login-logo.sh` exits cleanly off Omarchy
- [ ] Task 2: Gate Omarchy-only links in `set-symlinks.sh`, prove Omarchy is unchanged

### Checkpoint A: Omarchy unchanged
- [ ] Link diff empty, `~/.local/bin/zed` still → `/usr/bin/zeditor`, shellcheck no new findings, human review

### Phase 2: Ubuntu paths
- [ ] Task 3: End-to-end file setup in an `ubuntu:24.04` container (fix anything it surfaces)
- [ ] Task 4: `setup.sh` bootstrap accepts Ubuntu and installs git with apt-get

### Checkpoint B: Ubuntu works
- [ ] Testing Strategy steps 1–4 from `SPEC.md` all pass, human review

### Phase 3: Docs
- [ ] Task 5: README Ubuntu prerequisites/script order, AGENTS.md corrections

### Checkpoint C: Complete
- [ ] All SPEC acceptance items met, ready for the real-desktop run

### Phase 4: Shell
- [ ] Task 6: Load fzf in `.zshrc` only on Omarchy

## Risks and mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Regression baseline misses `~/.local/bin/zed`: it points at `/usr/bin/zeditor`, not into `~/dotfiles`, so the spec's `find -lname "$HOME/dotfiles/*"` diff won't show it disappearing | High | Task 2 adds an explicit `readlink ~/.local/bin/zed` check alongside the diff |
| Baseline captured after a change instead of on clean `main` | High | Task 0 runs first, before any edit; Task 2 refuses to proceed without `/tmp/links-before.txt` |
| `link()` isn't dry-run aware, so Omarchy verification mutates the live `$HOME` | Med | Accepted by spec. The run is idempotent and `.bak` renames are logged; review `install.log` after the run |
| Host `/usr/bin/gomplate` mounted into the container may not run there (dynamic linking) | Med | Check `gomplate --version` in the container first. If it fails, download the static release binary into the container instead and note it in README |
| No `sudo` in the bare `ubuntu` image, so the bootstrap test fails for the wrong reason | Med | Task 4's test installs `sudo` (but not git) before running `setup.sh` |
| Bootstrap test mounts the repo at `~/dotfiles`, so `setup.sh` takes the "already exists" branch and never installs git | Med | Mount the repo at `/src` for the bootstrap test; the script clones from GitHub `main` into `~/dotfiles` |
| Sourcing `/etc/os-release` adds a shellcheck SC1091 info | Low | Use a `# shellcheck source=/dev/null` directive so the "no new findings" bar holds |

## Open questions

None.

## Resolved

- fzf in `.zshrc`: left as is on Omarchy and wrapped in an Omarchy check (`.zshrc` reads `/etc/os-release` itself, as `setup.sh` does, because it can't source `utils.sh`). Ubuntu gets no fzf shell integration for now.
- Ubuntu version: 24.04.
- Ghostty `window-decoration = false`: stays shared for now, no task.
- `git-lfs`: not added to Ubuntu prerequisites.
