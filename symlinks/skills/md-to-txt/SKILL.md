---
name: md-to-txt
description: Convert markdown to plain text. Use when user says "convert to text", "convert to txt", "plain text version", or asks to create a .txt version of markdown content.
---

# Markdown to Plain Text

Convert markdown into clean plain text suitable for pasting into forms, emails, and systems that do not support markdown.

## Instructions

### Input and Output

The skill handles two input modes:

- **File input** - A `.md` file path is supplied. Read it, convert it, and write the result to a sibling `.txt` file: same directory, same base name (e.g. `resume/resume.md` -> `resume/resume.txt`). If the sibling `.txt` already exists, just overwrite it. Do not attempt to fix/merge the content.
- **Inline input** - Markdown text is supplied directly in the conversation, with no file path. Convert it and return the plain text inline in the response. Do not write a file unless otherwise specified by the user.

If neither a file path nor inline markdown is supplied, ask the user for the input.

### Conversion Rules

- **Preserve structure** - Maintain the overall document hierarchy and whitespace layout of the source.
- **Bullets** - Replace markdown list markers (`-`, `*`, `+`) with unicode bullet characters for visual hierarchy: `•` for the first level, `–` for the second level. Preserve indentation to show nesting.
- **Numbered lists** - Keep ordered list numbering as `1)`, `2)`, `3)` etc. Preserve indentation for nested levels and let each nested level restart its own numbering.
- **Links** - Strip markdown link syntax `[text](url)` and keep the display text. If the URL differs from the display text and is useful to the reader, append it after the text. If the URL already contains the display text, drop the display text and keep just the cleaned URL (e.g. `[github](http://github.com/igourianov)` -> `github.com/igourianov`).
- **Bold/Italic** - Remove `**`, `*`, `__`, `_` markers while keeping the enclosed text.
- **Headings** - Remove the heading markers. Uppercase and underline the text of `#` (h1) headings. Leave deeper headings (`##` and below) in their original case and do not decorate with separator lines or underlines.
- **Section spacing** - Separate major sections with a single blank line.
- **Code blocks** - Remove backtick fencing and keep the content.
- **Tables** - Convert to aligned plain text using whitespace padding, or a simple delimited format if alignment is impractical.

### Response to User

- For file input: report the source path, the output path, and confirm the conversion is complete.
- For inline input: return the converted plain text directly.
