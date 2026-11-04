# AI Boost for Students — Project Guide for Claude

## What this project is
A weekly newsletter that recaps Brent Presley's weekly AI update session for students at
Mid-State Technical College. Each week's topics become one issue. Issues are published as a
GitHub Pages site built with Jekyll, with a homepage that lists every issue, grouped by semester.

## What students should get from it
Every issue serves three goals, one section each:
1. **AI big picture** — what's happening in AI and why it matters to them (The Big Picture)
2. **AI acumen** — understanding how AI works and where it fails (Level Up)
3. **Using AI effectively and ethically** — a prompt to try (Try This) and a judgment call
   (Is This OK?)

It is deliberately short: about a 3-minute read on a phone. It is NOT the faculty
Artificial Insights newsletter. Don't add faculty sections (Tool Drop, Ed Pulse, etc.).

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
| `_layouts/` | `default.html` (header/footer) and `issue.html` (wraps each section in a card) |
| `assets/css/main.scss` | All styling. Colors are Sass variables at the top |
| `assets/js/issue.js` | Adds a "Copy prompt" button to the Try This prompt |
| `index.html` | Homepage: list of issues, newest first, grouped by `semester` |
| `scripts/check_issue.rb` | Validates an issue file before publishing |
| `.claude/agents/` | Subagents used by the weekly workflow |
| `.claude/skills/new-issue/` | The weekly "make an issue" workflow |

## The issue format (do not change it)
See `_templates/issue-template.md`. `scripts/check_issue.rb` enforces these rules:
- Front matter: `title`, `issue` (number), `date` (matches the file name), `semester`
  (e.g. `Fall 2026`), `this_week` (one sentence), `challenge` (one action). The last two are
  30 words or fewer and are shown at the top and bottom of the page.
- Exactly four sections, in this order, each with exactly one `###` headline:
  1. `## The Big Picture` — one story, a `**Why it matters to you:**` line, and a link.
  2. `## Level Up: <type>` — type rotates weekly: `Word of the Week`, `Myth vs. Fact`,
     `Spot the Fake`.
  3. `## Try This` — the prompt in a ```` ```text ```` block and a `**What to look for:**` line.
  4. `## Is This OK? <type>` — type rotates: `Academic Honesty`, `Privacy`. Ends with a
     `**My answer:**` line.
- Length: each section 120 words or fewer, whole issue 450 or fewer (prompt not counted).
  Aim for about 400.
- To rotate, look at the most recent issue in `_issues/` and pick a different type.

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
