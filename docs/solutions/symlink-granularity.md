# Symlink granularity

## Intent

Keep Claude Code's machine-generated skill cache out of this repository, while the user's own skills stay symlinked into `~/.claude` as before.

## Context

`~/.claude/skills` is a symlink to `symlinks/skills`, so when Claude Code syncs the skills published to the user's account it writes them straight into the repo: a `synced/` directory holding one bucket per sync, roughly 4 MB across 200-odd files against ~53 KB of the user's own content, plus a zero-byte `.bucket-<uuid>_<uuid>` marker inside it. The cache is disposable and transient. Claude re-downloads it on demand, the bucket name is not stable across syncs, and the directory comes and goes on its own.

## Constraints and assumptions

* `synced/` is the only thing Claude Code writes under `~/.claude/skills`, observed across several syncs. The bucket marker lives inside it, so a single ignore rule covers the whole cache.
* Creating symlinks on Windows requires elevation unless Developer Mode is on, confirmed by an unelevated `New-Item -ItemType SymbolicLink` failing on this machine. Directory junctions would avoid it, but the file entries under `symlinks/` need real symlinks, so the installer elevates regardless.
* A PowerShell script launched from Explorer or a default shell can be blocked by execution policy, so the installer's own elevated relaunch bypasses it.
* Elevation means the user runs the installer themselves.
* Ruled out: per-child symlinking of `symlinks/skills`, so that Claude's cache lands in a real `~/.claude/skills` directory outside the repo. It keeps the working tree clean, but it costs an install re-run on every skill added, renamed or removed, plus stale-link pruning in the installer whose target comparison has no reachable correct form under a simple path prefix test.
* Ruled out: ignoring everything under `symlinks/skills/` and unignoring the user's own skills by name. It is closed against anything Claude writes, but it moves the maintenance from Claude's rare new files to the user's own skills.

## Scope

Owned: `.gitignore`, `windows/install.ps1`, `windows/install.bat` and `README.md`.

Not owned: the contents of `symlinks/` and anything under `~/.claude`.

## Solution

### `.gitignore`

At the repository root, ignoring `symlinks/skills/synced/`. The cache stays on disk inside the working tree, where Claude Code expects to find it through the `~/.claude/skills` symlink, and never reaches the index. Git-aware tools, ripgrep and this repo's own searches skip it with no further configuration.

### `windows/install.ps1`

The single installer. It self-elevates: when not already running as administrator it relaunches itself through `Start-Process -Verb RunAs` with execution policy bypassed, then exits. `windows/install.bat` does not exist; its `mklink` loops live here as `New-Item -ItemType SymbolicLink`.

Running elevated, it resolves the repo's `symlinks/` directory from its own location and targets `$env:USERPROFILE\.claude`. Every entry directly under `symlinks/`, file or directory, becomes a symlink of the same name in `~/.claude`, replacing whatever occupies that path. A directory symlink it replaces is unlinked through its own directory entry rather than by a recursive delete, which would follow the link and destroy the repo content behind it.

The observable result is what it was before: `~/.claude/CLAUDE.md`, `settings.json`, `skills` and `agents` all point into this repo, and repeated runs converge on that state.

### `README.md`

Describes `windows/install.ps1` as the only installation script, self-elevating, with no `install.bat`. It records that Claude Code's synced skill cache lands in `symlinks/skills/synced/` through the `skills` symlink and is ignored rather than tracked, and that an install re-run is needed only when a new top-level entry appears under `symlinks/`.

## Tradeoffs

* Ignoring the cache over linking skills individually: no install re-run when skills change and no pruning logic to maintain, at the price of 4 MB of Claude's files sitting in the working tree where IDE indexing, file watchers and backups still see them, and of a deny rule that needs extending if Claude ever writes something new under `skills/`.
* One PowerShell script over the `.ps1` wrapper plus `.bat`: matches the repo owner's PowerShell-over-batch preference and collapses two files into one, at the price of depending on the script's own execution-policy bypass.
