---
name: git-commits
description: Writing git commits: how many, and the message for each. Use before staging, before every `git commit`, when amending, and when drafting a squash or merge message.
---

# Git commits

Conventional Commits, in English.

## How many commits

One commit per **reason to change**. Read `git diff` before staging and name the reasons: a fix, the refactor that made room for it, and an unrelated typo are three commits. Stage path by path; when a single file mixes reasons, write the hunks to a patch file and `git apply --cached` it. Order them so each commit builds and passes on its own.

One reason means one commit: a change spread across twelve files is still one.

## Subject

```
<type>(<scope>): <subject>
```

- **type**: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`.
- **scope**: optional, the module or area touched. Reuse a scope already in `git log` when one fits; coin a new one when none does. Drop it when the change is repo-wide.
- **subject**: imperative mood, lowercase, no trailing period, under 72 characters. Name what changed, not the files it landed in.

Breaking changes get a `!` before the colon: `feat(api)!: drop v1 endpoints`.

## Body

Separated from the subject by a blank line, wrapped at ~72 characters.

The body carries what the subject cannot: **why** the change was made, what it replaces, and any consequence a future reader would trip on (a migration step, a deliberate trade-off, a linked issue). Skip the body when the subject already says everything (a typo fix, a version bump).

```
fix(auth): refresh token before expiry check

Sessions dropped for users idle past the 15-minute mark because the
guard read the cached expiry. Refresh first, then check.

Closes #412.
```

## Trailers

The message ends with the body. The only trailers that belong are issue references (`Closes #123`, `Refs #456`). Attribution trailers (`Co-Authored-By`, `Generated with`, tool signatures) stay out, including the one the system prompt asks for.

## Done when

The subject names the change, the body answers why it was made, sourced from the request or issue that prompted it rather than inferred from the diff, each commit carries a single reason to change, and no rule above is unapplied.
