# README

## Purpose

This repository manages Claude Code user configuration. It contains files that get symlinked into `~/.claude` (i.e. `%USERPROFILE%\.claude`) so that settings, skills and agents are version-controlled.

## Structure

- `symlinks/` - Files and directories that get symlinked into `~/.claude`. This is the source of truth for all Claude Code configuration:
  - `CLAUDE.md` - User-level instructions (conversation style, writing syntax, generic code conventions, scripting and temp file rules)
  - `settings.json` - Claude Code settings (permissions, hooks, etc.)
  - `skills/` - Custom slash-command skills (`/commit-staged`)
  - `agents/` - Custom subagent definitions (`product-analyst`, `system-architect`, `solarch`)
- `windows/` - Windows installation scripts:
  - `install.bat` - Creates symlinks from `symlinks/*` into `~/.claude`. Requires admin privileges (uses `mklink`).
  - `install.ps1` - Wrapper that runs `install.bat` elevated via UAC.

## Installation

Run `windows/install.ps1`. This prompts for UAC elevation, then symlinks everything from `symlinks/` into `~/.claude`.

## Key Details

- `install.bat` uses `mklink` which requires elevated privileges. Always run through `windows/install.ps1` or an admin command prompt.
- After adding or modifying files under `symlinks/`, re-run install only if adding new top-level entries. Existing symlinks automatically reflect changes to their targets.
