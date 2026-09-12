---
name: comments
description: Commenting code. Use when writing or editing code, or leaving a TODO.
---

# Comments

The default is no comment. Code that needs one usually wants a better name or a smaller function first, and a comment that survives a rename or a refactor turns into a lie nobody notices.

So each comment has to earn the line it takes. Two questions decide it:

1. **Is this fact absent from the code?** If a reader could learn it by reading the next few lines, the comment is noise.
2. **Would a competent reader of this file be surprised by it?** Unsurprising facts do not need saying.

Both yes, write it. Otherwise, don't.

## What passes

- **Why this way and not the obvious way.** The approach a reader would reach for, and the reason it fails here.
- **A constraint from outside the code.** Undocumented API behaviour, a protocol or legal requirement, a bug in a dependency being worked around.
- **A trap.** The thing that looks safe to change and is not.
- **A pointer.** The issue, RFC, or spec section that settles why the code is shaped this way.

## Length

A comment is a signpost, not the explanation. Once it runs to a paragraph it has stopped being a comment and become an essay that happens to live in a source file, and nobody reads or updates those.

So write the shortest thing that carries the surprise. A line or two is the normal size.

```go
// Vendor returns 200 with an empty body on rate limit. See #payments-api-quirks.
if len(body) == 0 {
	return retryWithBackoff(ctx, req)
}
```

Not this:

```go
// The vendor's API has an unusual behaviour where, instead of returning a 429
// status code as you would expect from a rate-limited endpoint, it returns a
// 200 OK with an empty response body. This means we cannot rely on the status
// code alone to distinguish a successful call from a throttled one, so we have
// to inspect the body and retry with exponential backoff when it is empty.
if len(body) == 0 {
	return retryWithBackoff(ctx, req)
}
```

Same fact, five times the upkeep. When trimming, keep the surprise and drop the narration.

## File headers

Working something out is satisfying, and the write-up wants to go somewhere. Watch for that pull, because the top of the file is not where it goes. A header essay is read once, by nobody, and is the first thing to rot.

A file header is worth a line, and only when the file's job is not already clear from its name and location. Anything past that — the architecture, the ordering rule, the deviation from a spec and its justification, the tour of what each step does — does not go in the file.

```go
// Command server is the demo's policy enforcement point.
package main
```

Not a twenty-line tour of the boot sequence, the thing step two fails to prove, and which other file closes the gap. Configuration files are no different: a compose file or a manifest gets a line, not a commentary with section banners.

Where the longer story goes is the repo's business, not this file's. If the repo keeps that kind of writing somewhere — a README section, a docs directory, decision records — put it there and let the header point at it in the same line. If it keeps none, the commit message is the right home. Either way, don't invent a new document for it, and don't leave it in the source as a consolation prize.

Facts that constrain one specific line still go next to that line, short, as above. The header is not where they are collected.

## What to cut

Restating the line below it. Section-divider banners. Change narration such as `// added validation here`; the diff already records that. A doc comment on a function whose signature already tells the whole story.

Commenting every block is a habit, not a standard. A file where most code is bare and three comments stand out is doing its job; a file with a comment over each block has taught readers to skim past all of them, including the one that mattered.

When you edit code that has a comment above it, the comment is part of what you are editing. Fix it or delete it.

## TODOs

A TODO is worth leaving when a later reader can act on it. That means it says what should happen and points at whatever settles it.

```go
// TODO(#214): drop this shim once every client is on the v2 payload.
```

A bare `TODO` records only that someone was once dissatisfied here.

## Dead code

Delete code you replaced. Git holds the history, so a commented-out block tells a reader nothing except that someone hesitated.
