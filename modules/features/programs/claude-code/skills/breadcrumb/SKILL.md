---
name: breadcrumb
description: Use at the end of a working session to capture learnings and create a handoff note (breadcrumb) for the next session.
when_to_use: When you see phrases like "leave a breadcrumb", "commit this to memory", or "so we can pick up where we left off".
---

# Breadcrumb

## Overview

Captures state at the end of a working session, in two parts:

- Durable learnings from the session go into individual memory files.
- A single handoff note (breadcrumb) tells the next session exactly where work stopped.

Both live in the project memory directory (listed in the system prompt).

## Steps

1. **Harvest learnings**

   Walk the session for things a future session cannot infer or rediscover from the repository, Git history, or CLAUDE.md:
     - Any corrections the user provided or preferences they confirmed (type `feedback`, with **Why:** and **How to apply:**)
     - External facts that were looked up or discovered mid-session (type `reference`)
     - Project state or decisions not recorded anywhere else (type `project`)
     - New facts, information, or metadata about the user (type `user`)

   Skip anything the repository or its workspace docs already record.
   Prefer updating an existing memory file over creating a new one with duplicate content.
   Updated memories should be dated with a bold `UPDATE <YYYY-MM-DD>:` and memories that have been proven wrong should be deleted.

2. **Write the breadcrumb**

   Overwrite `BREADCRUMB.md` (name `breadcrumb`, type `project`) which describes the latest handoff, not a running log.
   When several workstreams are in-flight concurrently, give each one its own block.

   Contents, in order:
     - **Last session ended:** the absolute date.
     - **Where we left off:** repository/branch/worktree state, what was finished, what's in progress, what's left to do.
     - **Next session:** what the user said comes next, in their framing, plus anything prepared/staged for it.
     - **Open items:** unresolved questions, deferred findings, things to watch (upstream releases, open pull requests, version gates), each with enough context to act on.
     - Any related memories should be linked with `[[name]]`.

3. **Update the index**

   Add one line per new memory in `MEMORY.md` and refresh the breadcrumb's hook to mark the new handoff.

## At the start of the next session

When the recalled breadcrumb is stale relative to the current state, trust the repository and update the breadcrumb rather than acting on old state.
Examples: an open pull request was merged, a version pin was bumped, etc.
