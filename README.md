# README

## Purpose

This repository manages Claude Code user configuration. It contains files that get symlinked into `~/.claude` (i.e. `%USERPROFILE%\.claude`) so that settings, skills and agents are version-controlled.

## Structure

- `symlinks/` - Files and directories that get symlinked into `~/.claude`. This is the source of truth for all Claude Code configuration:
  - `CLAUDE.md` - User-level instructions (conversation style, writing syntax, generic code conventions, investigation rules, scripting and temp file rules)
  - `settings.json` - Claude Code settings (permissions, hooks, etc.)
  - `skills/` - Custom slash-command skills (`/commit-staged`, `/md-to-txt`, `/solarch`)
  - `agents/` - Custom subagent definitions (`product-analyst`, `system-architect`, `solarch-reviewer`)
- `windows/` - Windows installation:
  - `install.ps1` - Creates the symlinks in `~/.claude`. Self-elevating via UAC.
- `docs/solutions/` - Solution docs produced by `/solarch`.

## Installation

Run `windows/install.ps1`. It prompts for UAC elevation, then links everything from `symlinks/` into `~/.claude`. Every entry under `symlinks/`, file or directory, becomes a symlink of the same name.

## Key Details

- Symlink creation requires elevated privileges, so the script relaunches itself as administrator. It also bypasses execution policy on that relaunch.
- Re-run install only when adding a new top-level entry under `symlinks/`. Existing symlinks automatically reflect changes to their targets.
- Claude Code syncs the skills published to your account into `~/.claude/skills/synced/`, which lands in `symlinks/skills/synced/` through the `skills` symlink. It is a disposable cache, so `.gitignore` excludes it. If Claude ever writes something else under `skills/`, add it there too.
