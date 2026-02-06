---
name: av
description: "Aviator CLI for stacked pull requests. Trigger: stack branches, stacked PR, av branch, av sync, av commit, av pr, av tree, av restack, av next, av prev"
allowed-tools:
  - Bash(av *)
  - Bash(git *)
  - Bash(gh *)
---

## Current stack state

- Current branch: !`git branch --show-current`
- Stack tree: !`av tree 2>/dev/null || echo "not an av-managed repo"`
- PR status: !`av pr status 2>/dev/null || echo "no PR for current branch"`

## Overview

`av` (Aviator CLI) manages **stacked pull requests** — chains of dependent branches where each builds on the previous one. This enables incremental, reviewable PRs instead of monolithic changes.

A stack looks like:

```
main
 ├── feature/auth        (PR #1: add auth middleware)
 │   └── feature/login   (PR #2: add login page, depends on auth)
 │       └── feature/dashboard (PR #3: add dashboard, depends on login)
 └── feature/unrelated   (independent PR)
```

## Core Workflows

### Create a new stacked branch

```bash
av branch <name>              # branch off current branch
av branch <name> --parent main  # branch off a specific parent
```

### Commit changes

Always use `av commit` instead of `git commit` when working in a stack — it updates av's internal tracking metadata.

```bash
av commit -m "message"        # commit staged changes
av commit -a -m "message"     # stage modified/deleted + commit
av commit -A -m "message"     # stage everything including untracked + commit
av commit --amend             # amend the last commit
av commit -b -m "message"     # create a new auto-named branch AND commit
av commit --branch-name <name> -m "message"  # create named branch + commit
```

### Navigate the stack

```bash
av tree                       # show full stack tree
av tree --current             # show only the current stack
av next                       # checkout next branch in stack
av next --last                # jump to last branch in stack
av prev                       # checkout previous branch in stack
av prev --first               # jump to first branch in stack
av switch                     # interactive branch switcher
av switch <branch>            # switch to a specific branch
```

### Create pull requests

```bash
av pr --title "My PR"         # create PR for current branch
av pr --title "PR" --draft    # create as draft
av pr --all                   # create PRs for every branch in the stack
av pr --reviewers "user1,@org/team"  # add reviewers
av pr status                  # check PR status for current branch
```

### Sync and rebase

```bash
av sync                       # sync all branches in current stack
av sync --current             # sync only current branch (don't recurse)
av sync --all                 # sync all branches in repo
av sync --rebase-to-trunk     # rebase stack onto latest main/master
av sync --push=yes            # push after sync (skip prompt)
av sync --prune=yes           # delete merged branches (skip prompt)
av restack                    # rebase stack after amending/reordering commits
av restack --all              # restack all branches
```

If sync/restack hits conflicts:
```bash
# resolve conflicts, then:
av sync --continue            # or av restack --continue
# to skip a problematic commit:
av sync --skip                # or av restack --skip
# to abort:
av sync --abort               # or av restack --abort
```

### Clean up

```bash
av tidy                       # remove merged/deleted branches from av metadata
av sync --prune=yes           # delete merged git branches
```

### Restructure the stack

```bash
av branch --rename <new-name>         # rename current branch
av reparent --parent <branch>         # change parent of current branch
av branch --split                     # split last commit into new branch
av squash                             # squash current branch into one commit
av adopt --parent main                # adopt current unmanaged branch
av orphan                             # remove current branch from av tracking
```

## Key Guidelines

1. **Always use `av commit` instead of `git commit`** in a stack — av tracks branch relationships internally.
2. **Run `av restack` after amending commits** — child branches need rebasing onto the amended parent.
3. **Use `av diff`** to see changes relative to the parent branch (not the full diff from main).
4. **Use `av sync --rebase-to-trunk`** to pull in upstream changes from main.
5. **Don't use `git branch -m`** — use `av branch --rename` so av's metadata stays consistent.
6. **Use `av switch`** (not `git checkout`) for interactive branch selection with stack context.

## Reference

See [references/commands.md](references/commands.md) for the full command reference with all flags and options.
