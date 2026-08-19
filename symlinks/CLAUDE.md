# Global Instructions

## Conversation

- Always respond with direct, clean messages. Do not over explain.
- Do not qualify my inquiries with "Excellent question", "Great idea", "Fair point", "Good catch" or similar. Respond directly to my claims/inquiries.
- Do not repeat back what I said, unless it is to confirm you understood me correctly.
- Do not provide detailed examples unless requested.
- Do not apologize if you've made a mistake. Provide remediation steps.
- Only make factual statements when you have a very high degree of certainty in the answer. Otherwise say you're not sure. Only speculate when specifically asked to.
- Always prioritize objective truth over agreeing with me.
- When I ask a question, respond with an answer. Do not take action unless I explicitly request it. E.g. `why have you done X?` is a request for explanation, NOT a request to change the `X` to something else.

## Writing syntax

- Do not use em dashes or double hyphens (`--`) as dash substitutes. Use periods or restructure sentences instead.
- Do not use the Oxford comma. Write "A, B and C" not "A, B, and C".
- Do not translate between English and Russian unless explicitly requested.

## Memory

Do not use the auto memory system. Never read from or write to project auto memory files or MEMORY.md.
Whenever I ask you to remember something, update CLAUDE.md or rules files in either project root or user directory, depending on the context of the change.

## Code

Language-agnostic defaults. A project's own guide overrides these where they conflict.

### Formatting

- Prefer tabs over spaces for indentation. Exception: a file managed by an external tool, e.g. `.claude/settings.local.json` is managed by Claude, which will always overwrite it with spaces.
- Do not hard wrap lines. Rely on editor virtual wrap. Exception: multi-part lambda / fluent API expressions.

### Comments

Comments must add context the code cannot convey (constraints, reasons, gotchas). Do not narrate what the code already says.

### Functions

- Inline single-use helpers. Keep a helper only when shared by 2+ callers or when it genuinely clarifies. Fold one-call helpers back into the call site.
- Collapse two functions that differ only by a constant into one parameterized function (e.g. show/hide pair to `set_shown(shown)`).
- Name a function for what it does, not for the path that triggered it. A single cleanup routine can serve both normal completion and teardown.
- Do not mix `if/elseif` condition trees with early returns within the same function. Pick one approach per function.
- A bool param that fully determines behavior is borderline. Fine when the paths share most logic. If they diverge heavily, prefer two functions.

### Variables

- Hoist a value used by multiple branches to the top of the function, rather than recomputing it per branch.
- Extract a repeated sub-expression into a named local, for readability and single evaluation.
- One variable per concept, reused across mutually exclusive phases. Sequential, never-concurrent phases can share one variable.
- Do not keep vestigial vars. A member that is only assigned then immediately read should be a local or inlined. A member cleared in cleanup but always reassigned before use is dead housekeeping.

## Scripting

Shell work and automation code for deterministic tasks (build scripts, file manipulation, one-off tooling). Not a project's application code, which follows the project's own stack.

- Use PowerShell over Bash for all shell work, one-off commands and saved scripts alike.
- Use Node over Python for complex automation code.
- If Bash is ever unavoidable, never redirect to `nul`. The Bash tool runs a Unix-like shell over a Windows filesystem, so `nul` creates a literal file instead of discarding output. Redirect to `/dev/null`.

## Temp files

Pass large or complex input (a JSON payload, SQL, a long argument) to a command through a temp file rather than inline to avoid fiddling with escape rules.

- Write it to the working directory root as `tmp.<random>.<ext>`, e.g. `tmp.5pg1popz.json`. The `tmp.` prefix is globally gitignored.
- Pick the random part yourself when writing the file directly, varying it every time. In a PS script, generate it with `[System.IO.Path]::GetRandomFileName().Split('.')[0]`.
- The file is new, so write it without reading first.
- Delete it on success only, leaving failures for inspection
