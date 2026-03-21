---
name: commit-staged
description: Commit staged changes. Use when user explicitly requests to commit changes.
context: fork
---

## 1. Analyze Staged Changes

Run !`git diff --staged` to see the exact changes that will be committed.

- **Nothing is staged** (empty output): report "Nothing staged to commit" and stop
- Identify each individual change (e.g., new file added, existing file modified, section updated)
- Write a one-sentence summary for each change

## 2. Write Commit Message

If amending (`amend`), also run `git log -1 --pretty=%B` to get the previous commit message and incorporate it with the new changes.

Use a single line for one change, or a bullet point list for multiple changes:

```
<single-line summary OR * bulleted list of changes>

Co-Authored-By: Claude <noreply@anthropic.com>
```

Use Write() tool to save commit message to `.git/commit-message.tmp`.

## 3. Execute Commit

```bash
git commit -F .git/commit-message.tmp
```

If amending, use 
```bash
git commit --amend -F .git/commit-message.tmp
```
instead.

## 4. Cleanup

```bash
rm .git/commit-message.tmp
```

## 5. Response to User

Only describe changes that were actually committed. Do NOT mention unstaged or untracked files.
