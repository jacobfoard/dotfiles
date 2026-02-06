# av Command Reference

Complete reference for all `av` subcommands.

Global flags available on all commands:
- `--debug` — enable verbose debug logging
- `-C, --repo <dir>` — directory to use for git repository
- `-h, --help` — help for the command

---

## Branch Management

### `av branch [flags] <name> [<parent-branch>]`
Create or rename a branch in the stack.

| Flag | Description |
|------|-------------|
| `--parent <branch>` | parent branch to base new branch off of |
| `-m, --rename` | rename the current branch |
| `--force` | force rename even if a PR exists |
| `--split` | split the last commit into a new branch (auto-generates name if omitted) |

### `av adopt [flags]`
Adopt unmanaged branches into av tracking.

| Flag | Description |
|------|-------------|
| `--parent <branch>` | force specifying the parent branch |
| `--remote <branch>` | adopt branches from remote PRs starting from the specified branch |
| `--dry-run` | preview adoption without making changes |

### `av orphan`
Remove the current branch from av tracking (opposite of adopt).

### `av reparent [flags]`
Change the parent of the current branch.

| Flag | Description |
|------|-------------|
| `--parent <branch>` | parent branch to rebase onto |

---

## Committing

### `av commit [flags]`
Record changes to the repository with commits.

| Flag | Description |
|------|-------------|
| `-m, --message <msg>` | commit message (can be specified multiple times for multi-paragraph) |
| `-a, --all` | stage modified and deleted files |
| `-A, --all-changes` | stage all files including untracked |
| `--amend` | amend the last commit |
| `--edit` | edit an amended commit's message |
| `-b, --branch` | create new branch with auto-generated name and commit |
| `--branch-name <name>` | create new branch with given name and commit |
| `--parent <branch>` | parent branch for the new branch |

### `av squash`
Squash all commits on the current branch into a single commit.

### `av split-commit`
Split a commit into multiple commits.

---

## Stack Navigation

### `av tree [flags]`
Show the tree of stacked branches.

| Flag | Description |
|------|-------------|
| `--current` | show only the current stack |

### `av next [<n>\|--last] [flags]`
Checkout the next branch in the stack.

| Flag | Description |
|------|-------------|
| `<n>` | move forward n branches |
| `--last` | checkout the last branch in the stack |

### `av prev [<n>\|--first] [flags]`
Checkout the previous branch in the stack.

| Flag | Description |
|------|-------------|
| `<n>` | move back n branches |
| `--first` | checkout the first branch in the stack |

### `av switch [<branch> | <url>]`
Interactively switch to a different branch. If a branch name or PR URL is given, switches directly.

### `av diff`
Show the diff between working tree and the parent branch (not trunk).

---

## Pull Requests

### `av pr [flags]`
Create a pull request for the current branch.

| Flag | Description |
|------|-------------|
| `-t, --title <title>` | PR title |
| `-b, --body <body>` | PR body (use `-` to read from stdin) |
| `--draft` | create as draft PR |
| `--all` | create PRs for every branch in stack |
| `--force` | force create even if PR already exists |
| `--no-push` | don't push before creating the PR |
| `--reviewers <list>` | comma-separated usernames or @org/team |
| `--queue` | queue an existing PR for merge |
| `--edit` | edit title/description before submitting |

### `av pr status`
Show the status of the PR associated with the current branch.

---

## Sync & Rebase

### `av sync [flags]`
Synchronize stacked branches to be up-to-date with their parent branches.

| Flag | Description |
|------|-------------|
| `--all` | sync all branches in the repository |
| `--current` | only sync current branch (don't recurse) |
| `--rebase-to-trunk` | rebase onto latest trunk (main/master) |
| `--push <ask\|yes\|no>` | push rebased branches (default: ask) |
| `--prune <ask\|yes\|no>` | delete merged branches (default: ask) |
| `--continue` | continue an in-progress sync |
| `--skip` | skip current commit during sync |
| `--abort` | abort an in-progress sync |

### `av restack [flags]`
Rebase stacked branches to maintain correct ordering after amendments.

| Flag | Description |
|------|-------------|
| `--all` | rebase all branches |
| `--current` | only rebase up to current branch |
| `--dry-run` | preview which branches would be rebased |
| `--continue` | continue an in-progress rebase |
| `--skip` | skip current commit |
| `--abort` | abort an in-progress rebase |

### `av fetch`
Fetch latest repository state from GitHub.

### `av sync-exclude`
Toggle whether a branch is excluded from `sync --all`. Excluded branches and their descendants are skipped.

---

## Cleanup

### `av tidy`
Remove deleted or merged branches from av's internal metadata and re-parent children of merged branches. Does not delete git branches.

---

## Setup

### `av init`
Initialize the repository for Aviator CLI.

### `av auth`
Check user authentication status.

### `av version`
Print version information.

---

## Reorder

### `av reorder`
Interactively reorder the stack. **Note:** This is interactive and should not be used by agents.
