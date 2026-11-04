---
name: new-issue
description: Produces this week's AI Boost for Students newsletter issue from Brent's session notes. Runs research, writing, and editing subagents, checks the file, and opens a pull request for Brent to review. Use when Brent says "new issue", "write this week's newsletter", "make the issue for week N", or shares notes from his weekly AI session.
---

# New weekly issue

## 1. Gather inputs
Get these from Brent. Ask only for what is missing:
- Session notes (topics, links, demos, his opinions). Required.
- Session date. Default: today.
- Semester, e.g. `Fall 2026`. Default: same as the latest issue in `_issues/`.
- Issue number. Default: latest `Issue Number` in `_issues/` plus one.
- A short name for the file, e.g. `week-10`. Default: `week-<n>` for the week of the semester.
- Images, if any. Save them to `assets/images/issues/<YYYY-MM-DD-short-name>/`.

The file path is `_issues/<YYYY-MM-DD>-<short-name>.md`.

## 2. Research
Run the `news-researcher` subagent with the session notes. Wait for its notes.

## 3. Write
Run the `issue-writer` subagent with the session notes, research notes, issue number, date,
semester, and file path.

## 4. Edit
Run the `issue-editor` subagent on the new file with the research notes. If it reports
format or factual problems, fix them in the file (or rerun issue-writer for big problems),
then run the editor once more. Don't loop more than twice; report what's left instead.

## 5. Publish for review
1. Make a branch named `issue/<YYYY-MM-DD>-<short-name>`.
2. Commit the issue file and any images.
3. Push and open a draft pull request titled `Issue <n>: <Title>`. In the body, list the
   topics, every `TODO(Brent):` marker, and anything the editor flagged and didn't fix.
4. Tell Brent the PR link and what needs his input. Merging the PR publishes the issue.

## Optional: slides
The issue file uses the same format as the `artificial-insights-pptx` skill. If Brent wants a
deck, run that skill on the issue file.
