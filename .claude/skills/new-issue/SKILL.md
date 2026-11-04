---
name: new-issue
description: Produces this week's short AI Boost for Students newsletter issue from Brent's session notes. Runs research, writing, and editing subagents, checks the file, and opens a pull request for Brent to review. Use when Brent says "new issue", "write this week's newsletter", "make the issue for week N", or shares notes from his weekly AI session.
---

# New weekly issue

## 1. Gather inputs
Get these from Brent. Ask only for what is missing:
- Session notes (topics, links, demos, his opinions). Required.
- Session date. Default: today.
- Semester, e.g. `Fall 2026`. Default: same as the latest issue in `_issues/`.
- Issue number. Default: latest `issue` number in `_issues/` plus one.
- A short name for the file, e.g. `week-10`. Default: `week-<n>` for the week of the semester.
- An image (optional): a screenshot, photo, or AI-generated image, and who made it.
  Ask once. If Brent has none, the issue goes out without one.

The file path is `_issues/<YYYY-MM-DD>-<short-name>.md`.

## 2. Image (only if Brent gave one)
1. Save it to `assets/images/issues/<YYYY-MM-DD>-<short-name>.jpg` (or `.png`).
2. If it's over 300 KB or wider than 1200 px, shrink it:
   `convert <in> -resize 1200x\> -quality 80 <out>.jpg`
3. Look at the image and draft `image_alt`: one plain sentence saying what it shows.
4. `image_credit` comes from Brent. AI-generated images say so, e.g. `AI-generated with <tool>`.
   Never use a photo from a news site.

## 3. Research
Run the `news-researcher` subagent with the session notes. Wait for its notes.

## 4. Write
Run the `issue-writer` subagent with the session notes, research notes, issue number, date,
semester, file path, and the image file name, alt text, and credit (if any). It copies `_templates/issue-template.md` and runs the checker.

## 5. Edit
Run the `issue-editor` subagent on the new file with the research notes. If it reports
format or factual problems, fix them in the file (or rerun issue-writer for big problems),
then run the editor once more. Don't loop more than twice; report what's left instead.

## 6. Publish for review
1. Make a branch named `issue/<YYYY-MM-DD>-<short-name>`.
2. Commit the issue file and the image, if any.
3. Push and open a draft pull request titled `Issue <n>: <Title>`. In the body, list the
   topics, every `TODO(Brent):` marker, and anything the editor flagged and didn't fix.
4. Tell Brent the PR link and what needs his input. Merging the PR publishes the issue.
