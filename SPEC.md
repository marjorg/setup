# Spec: Ubuntu support for file setup

## Objective

Make the existing file-setup scripts work on an Ubuntu GNOME work desktop, run by hand in the same order as on Omarchy. Ubuntu gets keys, ssh config, git config and every config in `home/` that isn't tied to Hyprland/Omarchy. Package installation stays Arch-only.

Acceptance:

- On Ubuntu, `generate-ssh-key.sh`, `generate-gpg-key.sh`, `write-ssh-config.sh`, `write-git-config.sh` and `set-symlinks.sh` run to completion and produce the same results as on Omarchy, minus the desktop-specific links.
- `copy-ssh-key.sh` and `copy-gpg-key.sh` work on Ubuntu when `wl-copy` is present (GNOME runs on Wayland).
- `set-login-logo.sh` exits 0 on Ubuntu with a log line and does nothing else.
- The bootstrap one-liner (`setup.sh`) accepts Ubuntu and installs git with `apt-get` when it's missing.
- Nothing changes on Omarchy. A real run produces exactly the same set of links as before.

## Tech Stack

Bash, plus tools the scripts already call: `ssh-keygen`, `gpg`, `gomplate`, `wl-copy`. Ubuntu is detected from `/etc/os-release` `ID=ubuntu`. Omarchy reports `ID=omarchy` (`ID_LIKE=arch`). Derivatives such as Pop!_OS (`ID=pop`) are not supported.

Ubuntu prerequisites, installed by hand: `git`, `gnupg`, `openssh-client`, `gomplate`, `wl-clipboard`.

## Commands

```
Lint:              shellcheck setup.sh scripts/utils.sh scripts/set-symlinks.sh scripts/set-login-logo.sh
File setup (both): ./scripts/generate-ssh-key.sh && ./scripts/generate-gpg-key.sh && ./scripts/write-ssh-config.sh && ./scripts/write-git-config.sh && ./scripts/set-symlinks.sh
Omarchy baseline:  find ~ -maxdepth 4 -type l -lname "$HOME/dotfiles/*" -printf '%p -> %l\n' | sort > /tmp/links-before.txt
Ubuntu test:       docker run --rm -it -v "$PWD:/root/dotfiles" -v /usr/bin/gomplate:/usr/bin/gomplate:ro ubuntu:24.04 bash
```

Inside the container, run `apt-get update && apt-get install -y git gnupg openssh-client`, then run the file setup with `--name Test --email test@example.com`.

## Project Structure

Files this change touches:

```
setup.sh                  → accept ubuntu, install git via apt-get
scripts/utils.sh          → OS_ID + is_omarchy, the single source of OS detection
scripts/set-symlinks.sh   → put the Omarchy-only links behind is_omarchy
scripts/set-login-logo.sh → exit cleanly when not Omarchy
README.md                 → Ubuntu prerequisites and script order
AGENTS.md                 → fix the stale setup.sh description, note Ubuntu file support
```

Links that only apply on Omarchy:

- `home/.config/hypr/` and `home/.config/uwsm/` (both picked up by the generic `.config/*/` loop)
- `home/.config/omarchy/branding/screensaver.txt`, `shell.json`, `defaults/agent`
- `home/.config/xdg-terminals.list`
- `/usr/bin/zeditor → ~/.local/bin/zed`. On Ubuntu, Zed's installer already puts its own `~/.local/bin/zed` there, and `ln -sfn` would replace it with a dangling link.

## Code Style

OS detection is done once in `utils.sh`. Scripts ask `is_omarchy` and never read `/etc/os-release` themselves. `setup.sh` is the one exception: it runs from curl before the repo exists, so it keeps its own inline check.

```bash
# scripts/utils.sh
OS_ID=$(. /etc/os-release && echo "$ID")

is_omarchy() {
  [[ "$OS_ID" == "omarchy" ]]
}
```

```bash
# scripts/set-symlinks.sh
if is_omarchy; then
  link /usr/bin/zeditor "$LOCAL_BIN/zed"
  link "$DOTFILES_CONFIG/omarchy/shell.json" "$HOME_CONFIG/omarchy/shell.json"
  # ...
fi
```

Follow `AGENTS.md`: `#!/bin/bash`, `set -euo pipefail` after sourcing `utils.sh`, `log`/`debug` for output, comments explain why and not what, all links go through `link()`.

## Testing Strategy

There is no test suite. Verification is:

1. **Lint:** `shellcheck` on every touched script, with no new warnings compared to `main`.
2. **Omarchy regression:** write the link baseline above on `main`, apply the change, run `./scripts/set-symlinks.sh` for real, write `/tmp/links-after.txt` the same way, and `diff` the two. The diff must be empty. `--dry` can't stand in for this because `link()` calls `mkdir`/`mv`/`ln` directly, not through `execute`.
3. **Ubuntu run:** in the `ubuntu:24.04` container, run the five scripts in order and check:
   - every script exits 0
   - `~/.ssh/id_ed25519`, `~/.ssh/config` and `~/.config/git/config` (with `signingkey` set) exist
   - `~/.zshrc`, `~/.profile`, `~/.config/{ghostty,zed,tmux,lazygit,ohmyposh,mise}`, `~/.config/Code/User/settings.json`, `~/.config/opencode/opencode.json`, `~/.claude/settings.json` and `~/.claude/skills/*` are symlinks into the repo
   - `~/.config/{hypr,uwsm,omarchy}`, `~/.config/xdg-terminals.list` and `~/.local/bin/zed` don't exist
   - running `set-symlinks.sh` a second time exits 0 and changes nothing
   - `./scripts/set-login-logo.sh` exits 0 without calling `sudo`
4. **Bootstrap:** in a fresh container without git, `bash setup.sh` gets past the OS check, installs git and clones the repo.

## Boundaries

- **Always:** route OS checks through `is_omarchy`; run shellcheck; keep Omarchy's link set byte-identical; add links through `link()`.
- **Ask first:** editing the contents of linked configs (`.zshrc`, ghostty) for Ubuntu; changing `link()` so `--dry` is honoured; adding prerequisite checks or new helpers beyond `is_omarchy`.
- **Never:** touch `install.sh` or `installs/*.sh`; edit vendored `home/.agents/{skills,references,commands,agents}`; add fallbacks for Linux distros other than Ubuntu; hardcode an identity.

## Success Criteria

- Every check in Testing Strategy steps 1–4 passes.
- On the real Ubuntu work desktop, a by-hand run of the five scripts leaves a working git setup (signed commit, ssh push to GitHub) and linked configs, with no manual fix-ups.

## Open Questions

1. **fzf in `.zshrc`.** `.zshrc` sources `/usr/share/fzf/completion.zsh` and `key-bindings.zsh`. On Ubuntu those files live in `/usr/share/doc/fzf/examples/`, so every new shell would print errors. On this machine `fzf --zsh` already outputs both, so the two lines look redundant and could just be deleted. But Ubuntu 24.04 ships fzf 0.44, and `--zsh` only arrived in 0.48. Recommendation: delete the two lines and install a newer fzf on Ubuntu by hand (or via mise). This counts as an "Ask first" edit.
2. **Ubuntu version.** Is the work desktop on 24.04 or 26.04? That decides the container image and whether question 1 even comes up.
3. **Ghostty on GNOME.** `window-decoration = false` takes the titlebar away under a non-tiling window manager. Leave it shared, or treat it as desktop-specific? Recommendation: leave it as is for now and revisit after a few days on the real machine.
