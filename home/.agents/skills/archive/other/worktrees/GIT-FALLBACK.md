# Git fallback

Creating worktrees by hand, for a harness with no native worktree tool. Reach for this only after ruling out the two native mechanisms in [SKILL.md](SKILL.md): bypassing a harness tool that exists creates state the harness cannot see or clean up.

## Where they go

In priority order:

1. A directory the user or the project's instructions already name.
2. An existing `.worktrees/` or `worktrees/` at the repo root (`.worktrees/` wins if both exist).
3. Otherwise `.worktrees/` at the repo root.

A project-local directory **must be ignored** before anything is created in it, or the next commit swallows every worktree:

```bash
git check-ignore -q .worktrees || echo '.worktrees/' >> .gitignore
```

Commit that change before creating worktrees.

## Creating them

Branch every worktree in a fan-out from the same base commit:

```bash
base=$(git rev-parse HEAD)
git worktree add .worktrees/<slice> -b <slice> "$base"
```

To check out a branch that already exists, drop the `-b` and name it. To run a throwaway experiment with no branch to clean up afterwards, use `git worktree add --detach .worktrees/<slice> <commit>`.

If creation fails on a permission error, a sandbox is blocking it. Say so, and work in the current directory rather than proceeding as though the isolation exists.

## Cleaning up

```bash
git worktree list              # what exists, and which branch each holds
git worktree remove <path>     # working tree must be clean; --force discards
git worktree prune             # clears metadata after a manual directory deletion
git worktree repair            # fixes links after a directory was moved by hand
```

`git worktree --help` has the rest.
