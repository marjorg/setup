# Tasks: Ubuntu support for file setup

See `tasks/plan.md` for decisions and risks, `SPEC.md` for requirements.

## Task 0: Capture the Omarchy link baseline

**Description:** Before anything changes, record every symlink into the repo, plus the zeditor link that the `find` filter can't see, so Task 2 has something to diff against.

**Acceptance criteria:**
- [x] `/tmp/links-before.txt` written from clean `main` with the SPEC's `find` command
- [x] `readlink ~/.local/bin/zed` recorded (expected `/usr/bin/zeditor`)
- [x] `shellcheck setup.sh scripts/utils.sh scripts/set-symlinks.sh scripts/set-login-logo.sh > /tmp/shellcheck-before.txt` saved for the "no new findings" comparison

**Verification:**
- [x] `git status` shows no changes to tracked files when the baseline is taken
- [x] `wc -l /tmp/links-before.txt` is non-zero

**Dependencies:** None

**Files likely touched:** none (writes to `/tmp` only)

**Estimated scope:** XS

## Task 1: `is_omarchy` helper and login logo skips off Omarchy

**Description:** Add `OS_ID` and `is_omarchy` to `scripts/utils.sh` as the single OS check. Make `set-login-logo.sh` log a line and exit 0 before touching Plymouth paths when not on Omarchy. Together these are the first complete Ubuntu path.

**Acceptance criteria:**
- [x] `utils.sh` defines `OS_ID` (read in a subshell from `/etc/os-release`) and `is_omarchy`, as in SPEC Code Style
- [x] `set-login-logo.sh` off Omarchy: one `log` line, exit 0, no `cmp`/`grep`/`sudo`/`omarchy` calls
- [x] On Omarchy, `set-login-logo.sh` behaves exactly as before

**Verification:**
- [x] `shellcheck` on both files: no findings beyond `/tmp/shellcheck-before.txt`
- [x] Omarchy: `./scripts/set-login-logo.sh --debug` prints "Login logo already up to date" (or the same as on `main`)
- [x] Ubuntu container (no `sudo` installed): `./scripts/set-login-logo.sh; echo $?` prints the log line and `0`

**Dependencies:** Task 0

**Files likely touched:**
- `scripts/utils.sh`
- `scripts/set-login-logo.sh`

**Estimated scope:** S

## Task 2: Gate Omarchy-only links in `set-symlinks.sh`

**Description:** Wrap the zeditor, `omarchy/branding/screensaver.txt`, `omarchy/shell.json`, `omarchy/defaults/agent` and `xdg-terminals.list` links in `if is_omarchy`, and skip `hypr`/`uwsm` in the `.config/*/` loop when not on Omarchy. Then prove Omarchy's link set is unchanged. This is the highest-risk task because it runs for real against the live `$HOME`.

**Acceptance criteria:**
- [x] The five explicit Omarchy-only links sit in one `is_omarchy` block, all still via `link()`
- [x] The loop skips `hypr` and `uwsm` only when `! is_omarchy`; `Code|omarchy|opencode` handling is unchanged
- [x] Omarchy link set is byte-identical to the baseline

**Verification:**
- [x] `shellcheck scripts/set-symlinks.sh`: no new findings
- [x] Omarchy: `./scripts/set-symlinks.sh`, then write `/tmp/links-after.txt` with the same `find`, and `diff /tmp/links-before.txt /tmp/links-after.txt` is empty
- [x] Omarchy: `readlink ~/.local/bin/zed` is still `/usr/bin/zeditor`
- [x] No new "Renaming existing directory" lines in `install.log` from this run

**Dependencies:** Tasks 0, 1

**Files likely touched:**
- `scripts/set-symlinks.sh`

**Estimated scope:** S

## Checkpoint A: Omarchy unchanged
- [x] Link diff empty, zed link intact
- [x] Shellcheck output for touched files has no findings beyond the baseline
- [x] `git diff` reviewed: only `utils.sh`, `set-login-logo.sh`, `set-symlinks.sh` changed
- [ ] Human review before moving to Ubuntu

## Task 3: End-to-end file setup on Ubuntu

**Description:** In `ubuntu:24.04` (the SPEC's `docker run` command), install `git gnupg openssh-client`, then run the five file-setup scripts with `--name Test --email test@example.com` and check every Ubuntu item in SPEC Testing Strategy step 3. Fix anything Ubuntu-specific this turns up in the scripts, within SPEC boundaries. Anything that would need an "Ask first" change gets raised, not patched.

**Acceptance criteria:**
- [x] All five scripts exit 0 in order; `~/.ssh/id_ed25519`, `~/.ssh/config`, `~/.config/git/config` (with `signingkey` set) exist
- [x] Expected links exist (`~/.zshrc`, `~/.profile`, `~/.config/{ghostty,zed,tmux,lazygit,ohmyposh,mise}`, `Code/User/settings.json`, `opencode/opencode.json`, `~/.claude/settings.json`, `~/.claude/skills/*`) and `~/.config/{hypr,uwsm,omarchy}`, `~/.config/xdg-terminals.list`, `~/.local/bin/zed` do not
- [x] Second `set-symlinks.sh` run exits 0 and changes nothing (same `find` listing before and after)

**Verification:**
- [x] `gomplate --version` works in the container first (see the gomplate risk in the plan)
- [x] Manual check: the step 3 checklist from SPEC, ticked item by item, including `set-login-logo.sh` exiting 0
- [x] `copy-ssh-key.sh` / `copy-gpg-key.sh`: read through to confirm there are no Omarchy-only calls (both only need `wl-copy`). A real clipboard test waits for the desktop run.

**Dependencies:** Tasks 1, 2

**Files likely touched:**
- none expected; `scripts/*.sh` only if the run exposes a bug

**Estimated scope:** S (verification-heavy)

## Task 4: Bootstrap accepts Ubuntu

**Description:** `setup.sh` accepts `ID=ubuntu` alongside `omarchy` (inline, no `utils.sh`) and installs git with `sudo apt-get update && sudo apt-get install -y git` when it's missing. Other IDs still hard-fail. This doesn't depend on Tasks 1–3 and can run in parallel with them.

**Acceptance criteria:**
- [x] `ID=ubuntu` passes the OS check; `ID=pop` and other IDs still print "Unsupported OS" and exit 1
- [x] Missing git on Ubuntu → installed via apt-get; on Omarchy the pacman path is unchanged
- [x] Existing SC2086 on the `git clone` line is not made worse (quoting `$DOTFILES_DIR` is fine to fix in passing)

**Verification:**
- [x] `shellcheck setup.sh`: no new findings
- [x] Fresh `ubuntu:24.04` with the repo mounted at `/src` (not `~/dotfiles`): `apt-get update && apt-get install -y sudo`, then `bash /src/setup.sh` installs git and clones into `~/dotfiles`
- [x] Unsupported-ID check: `docker run --rm -v "$PWD:/src" debian:stable bash /src/setup.sh` exits 1 with the unsupported message
- [x] Omarchy: `bash setup.sh` prints "Repository already exist" as before

**Dependencies:** None

**Files likely touched:**
- `setup.sh`

**Estimated scope:** XS

## Checkpoint B: Ubuntu works
- [x] SPEC Testing Strategy steps 1–4 all pass
- [x] Omarchy link diff still empty if any script changed during Task 3
- [ ] Human review

## Task 5: Docs

**Description:** README gets an Ubuntu section with the hand-installed prerequisites and the script order. AGENTS.md drops its stale `setup.sh` description (it's a curl bootstrap, not the post-install setup) and the "only targets Omarchy" gotcha. Instead it notes that file setup works on Ubuntu, package install is Arch-only, and OS checks go through `is_omarchy`.

**Acceptance criteria:**
- [x] README lists Ubuntu prerequisites (`git`, `gnupg`, `openssh-client`, `gomplate`, `wl-clipboard`) and the five-script order
- [x] AGENTS.md's Structure, Commands and "Things a newcomer would get wrong" entries for `setup.sh` / Omarchy-only match the code
- [x] No manual line wrapping (user rule)

**Verification:**
- [x] Manual check: every command in README runs as written on Omarchy (`--dry` where available)
- [x] `git diff README.md AGENTS.md` reviewed against SPEC

**Dependencies:** Tasks 1–4

**Files likely touched:**
- `README.md`
- `AGENTS.md`

**Estimated scope:** S

## Checkpoint C: Complete
- [x] Every SPEC acceptance bullet met
- [x] Ready for the real-desktop success check (signed commit + ssh push to GitHub)

## Task 6: Load fzf in `.zshrc` only on Omarchy

**Description:** Wrap the three fzf `source` lines (`home/.zshrc:26-28`) in an Omarchy check so Ubuntu shells start without errors. Ubuntu gets no fzf integration for now, which is an accepted trade-off. `.zshrc` can't source `utils.sh` (it sets `set -euo pipefail` and writes `install.log`), so it does its own check against `/etc/os-release`, like `setup.sh` does. Add a short why-comment saying the paths and `fzf --zsh` (0.48+) are Arch-specific and Ubuntu 24.04 ships 0.44. The lines themselves stay as they are.

**Acceptance criteria:**
- [x] On Omarchy, a new zsh has fzf completion and Ctrl-R/Ctrl-T bindings as before
- [x] On Ubuntu, shell start prints no fzf errors
- [x] The three `source` lines are unchanged apart from the wrapper; the fzf block still loads before zinit/fzf-tab

**Verification:**
- [ ] Omarchy: `zsh -i -c exit` prints nothing on stderr, plus a manual Ctrl-R and `**<Tab>` check
- [x] Ubuntu container (Task 3 setup, `apt-get install -y zsh`): `zsh -i -c exit 2>&1 | grep -i fzf` is empty (zinit/plugin noise from a bare container is out of scope)

**Dependencies:** None (container check after Task 3)

**Files likely touched:**
- `home/.zshrc`

**Estimated scope:** XS
