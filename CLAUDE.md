# AI Boost for Students — Project Guide for Claude

## What this project is
A weekly newsletter that recaps Brent Presley's weekly AI update session for students at
Mid-State Technical College. Each week's topics become one issue. Issues are published as a
GitHub Pages site built with Jekyll, with a homepage that lists every issue, grouped by semester.

## Audience and voice
- Readers are students, mostly new to AI. Write plainly: short sentences, define jargon the
  first time, and give a concrete "why this matters to you".
- Brent's own opinions (MyTake, TheLesson) are first person, direct and literal. No hype words
  ("revolutionary", "game-changer"), no filler, no mannered metaphors.
- Never invent facts, quotes, statistics or links. Every claim must trace to a source Brent
  gave or one the researcher verified. If something can't be verified, leave it out and say so.

## Repository layout
| Path | Purpose |
|---|---|
| `_issues/YYYY-MM-DD-short-name.md` | One file per weekly issue (the date is the session date) |
| `_templates/issue-template.md` | Starting point for every new issue; copy it, never edit in place |
| `assets/images/issues/<issue file name without .md>/` | Images for that issue |
| `_layouts/` | `default.html` (header/footer) and `issue.html` (one issue page) |
| `assets/css/main.scss` | All styling. Colors are Sass variables at the top |
| `assets/js/issue.js` | Turns `- **Label:** value` items into cards on the web page |
| `index.html` | Homepage: list of issues, newest first, grouped by `semester` |
| `scripts/check_issue.rb` | Validates an issue file before publishing |
| `.claude/agents/` | Subagents used by the weekly workflow |
| `.claude/skills/new-issue/` | The weekly "make an issue" workflow |

## The issue format (do not change it)
Issue files use the Artificial Insights Markdown format, so the same file also feeds the
`artificial-insights-pptx` slide generator. Rules:
- Front matter keys: `Issue Date`, `Issue Number`, `Title`, `date` (same as Issue Date),
  `semester` (e.g. `Fall 2026`). Keep front matter short; the slide generator reads the first
  10 lines.
- First paragraph after the front matter is the throughline (over 60 characters).
- Sections in this order, each optional except where noted: `## Quick Scan` (required),
  `## Tool Drop`, `## The Breakdown`, `## Ed Pulse`, `## In Action`, `## Try This` (required),
  `## Follow-up heading: <question>` (required), `## Follow-up tasks` (required),
  `## Additional Reads and Link Coverage`.
- Items are `- **Title:** ...` followed by indented `**Field:** value` lines. Field names are
  exact and case-sensitive; see the template.

## Commands
- Check an issue: `ruby scripts/check_issue.rb _issues/<file>.md`
- Build the site locally: `JEKYLL_NO_BUNDLER_REQUIRE=true jekyll build --unpublished`
  (or `bundle exec jekyll serve` after `bundle install`)

## Workflow rules
- Use the `new-issue` skill for each week's issue.
- Work on a branch and open a pull request. Brent reviews and merges; merging to the default
  branch publishes the issue.
- Use `published: false` in front matter for drafts that should not appear on the site.
- Don't change layouts, CSS or the issue format while writing an issue. Suggest it instead.
