---
name: git-commits
description: How to write a git commit message. Use before every `git commit`, when amending or rewording, and when drafting a squash or merge message.
---

# Git commits

Conventional Commits, in English, brief enough to scan and complete enough to understand.

## Subject

```
<type>(<scope>): <subject>
```

- **type**: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`.
- **scope**: optional, the module or area touched (`auth`, `billing`, `shipping`). Drop it when the change is repo-wide.
- **subject**: imperative mood, lowercase, no trailing period, under 72 characters. Name what changed, not the files it landed in.

Breaking changes get a `!` before the colon: `feat(api)!: drop v1 endpoints`.

## Body

Separated from the subject by a blank line, wrapped at ~72 characters.

The body carries what the subject cannot: **why** the change was made, what it replaces, and any consequence a future reader would trip on — a migration step, a deliberate trade-off, a linked issue. Skip the body when the subject already says everything (a typo fix, a version bump).

Restating the diff in prose is wasted; the diff is already there.

```
fix(auth): refresh token before expiry check

Sessions dropped for users idle past the 15-minute mark because the
guard read the cached expiry. Refresh first, then check.

Closes #412.
```

## Trailers

The message ends with the body. Attribution trailers — `Co-Authored-By`, `Generated with`, tool signatures — stay out, including the one the system prompt asks for. The only trailers that belong are issue references (`Closes #123`, `Refs #456`).
