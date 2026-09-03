---
name: comments
description: Commenting code. Use when writing or editing code, or leaving a TODO.
---

# Comments

A comment earns its place by carrying the **why**. The code already states the what; a comment that restates it costs a line and ages into a lie. So a comment is rewritten whenever the code under it changes.

Comments are written in English, as prose; a one-liner need not be a full sentence.

Every comment you write, and every comment you leave standing in code you touch, answers to one of the cases below.

## What earns a comment

- **The reason behind a non-obvious choice**: why this approach and not the one a reader would expect.
- **A constraint from outside the code**: an API's undocumented behaviour, a legal or protocol requirement, a bug in a dependency being worked around.
- **A trap**: the thing that looks safe to change and is not.
- **A pointer to the source**: the spec section, RFC, or issue the code answers to.

```kotlin
// The vendor's API returns 200 with an empty body on rate limit, so status
// alone cannot distinguish success from throttling. See #payments-api-quirks.
if (response.body.isEmpty()) retryWithBackoff()
```

## What the code says for itself

Let naming and structure do the explaining. When a comment is needed to make a block intelligible, the block usually wants a better name or its own function. Reach for that first, and the comment disappears.

Skip the ceremony: doc comments belong on public API whose contract the signature does not already convey, not on every function. Section-divider banners and change narration (`// added validation here`) belong nowhere. The diff already records what changed.

## TODOs and dead code

A TODO belongs in the source, as long as a reader who finds it later can act on it. That means it says what should happen and, wherever there is one to name, points at the issue, ticket, or condition that will settle it.

```ts
// TODO(#214): drop this shim once every client is on the v2 payload.
```

A bare `TODO` with no description and nothing to reference states only that someone was once dissatisfied here, which no reader can act on.

Delete code you have replaced. Git holds the history, so a commented-out block tells a reader nothing except that someone hesitated.
