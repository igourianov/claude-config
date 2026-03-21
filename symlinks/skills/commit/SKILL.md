---
name: commit
description: Create git commits and push to remote. Use when user explicitly requests to commit changes, create a commit, or push code.
context: fork
---

# Commit Skill

Gather changes from the repository, create a descriptive commit, and push to remote.

## Instructions

**CRITICAL: Only use this skill when explicitly requested by the user.**

### 1. Determine What to Commit

The user may pass a parameter (e.g., `commit staged`, `commit jobs/Ashby`). Run `git status` to see the current state.

- **User specified a scope** (paths, files, or keywords like "staged"): stage those specific items
- **Nothing is staged and no explicit scope given**: report "Nothing staged to commit" and stop
- **Something is already staged and no explicit scope given**: do NOT stage anything additional

### 2. Analyze Staged Changes

Once the commit scope is determined, examine ONLY what is staged:
- `git diff --staged` - See the exact changes that will be committed
- Identify each individual change (e.g., new file added, existing file modified, section updated)
- Write a one-sentence summary for each change

### 4. Create Commit

**Commit message format:**

If there is only one change:
```
Summary of the change

Co-Authored-By: Claude <noreply@anthropic.com>
```

If there are multiple changes, use bullet points:
```
* First change summary
* Second change summary
* Third change summary

Co-Authored-By: Claude <noreply@anthropic.com>
```

Write the commit message to a temp file, then use `-F`:
```bash
git commit -F commit.tmp; rm commit.tmp
```

### 5. Push to Remote

After successful commit:
- Check if current branch tracks a remote branch
- If yes: `git push`
- If no: Ask user if they want to set up remote tracking

### 6. Verify

Run `git status` after push to verify everything succeeded.

## Response to User

Only describe changes that were actually committed. Do NOT mention unstaged or untracked files that were not part of the commit.

## Notes

- Do NOT create commits unless user explicitly requests them
- If pre-commit hooks fail, fix the issue and create a NEW commit (do not amend)
