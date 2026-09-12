# Mechanics

Read this when the straightforward path in SKILL.md does not fit: one file carrying two reasons, a hook that fails or rewrites your work, a commit that needs amending, or a squash message.

## Splitting one file across two commits

`git add -p` is interactive and unavailable, so write the hunks you want into a patch and apply that to the index:

```
git diff -- path/to/file > /tmp/part.patch   # edit down to the hunks for this reason
git apply --cached /tmp/part.patch
git commit -m "..."
```

Commit the remainder normally afterwards. Read `git diff --cached --name-only` first if you are unsure what actually landed.

This is worth the effort only when the two reasons genuinely need separate commits. If they are two halves of one reason, leave the file whole.

## Hooks

Let them run. A failing pre-commit hook is a finding: read what it reports, fix that, and commit again rather than reaching for `--no-verify`. Bypassing a hook hides the problem in history instead of solving it.

If a hook reformats files, its changes land in the working tree unstaged. Restage the paths you meant to commit and check `git diff --cached --name-only` before retrying, or the reformatting drifts into whatever you commit next.

## Amending and fixups

Amend only a commit you have not pushed. Rewriting published history forces everyone else to recover from it.

Keep the original message unless the reason for the change moved. Adding a forgotten test does not change why the commit exists, so the message stands and `git commit --amend --no-edit` is the whole operation.

When the work belongs to an older commit on the branch, `git commit --fixup <sha>` records that intent for a later `git rebase -i --autosquash`, which keeps it visible instead of folding it in silently.

## Squash and merge messages

A squash message describes the branch's net effect, not its history. One subject for what the branch does, and a body naming the reasons that survived. The "wip" and "fix review comments" commits do not appear; nobody reads them once the branch is squashed.
