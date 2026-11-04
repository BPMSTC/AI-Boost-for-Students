# AI Boost for Students — Project Guide for Claude

## What this project is
A weekly newsletter that recaps Brent Presley's weekly AI update session for students at
Mid-State Technical College. Each week's topics become one issue. Issues are published as a
GitHub Pages site built with Jekyll, with a homepage that lists every issue, grouped by semester.

## What students should get from it
Every issue serves three goals:
1. **AI big picture** — what's happening in AI and why it matters to them (The Big Picture,
   plus a shorter second story in Also This Week)
2. **AI acumen** — understanding how AI works and where it fails (Level Up)
3. **Using AI effectively and ethically** — a prompt to try (Try This) and a judgment call
   (Is This OK?)

It is deliberately short: about a 3-minute read on a phone. One optional image per issue. It is NOT the faculty
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
| `assets/images/issues/` | The optional image for each issue (one per issue, under 300 KB) |
| `assets/css/main.scss` | All styling. Colors are Sass variables at the top |
| `assets/js/issue.js` | Adds a "Copy prompt" button to the Try This prompt |
| `index.html` | Homepage: list of issues, newest first, grouped by `semester` |
| `scripts/check_issue.rb` | Validates an issue file before publishing |
| `.claude/agents/` | Subagents used by the weekly workflow |
| `.claude/skills/new-issue/` | The weekly "make an issue" workflow |
| `.claude/skills/weekly-briefing/` | Tuesday news research: a verified list of stories for Brent to pick from |

## The issue format (do not change it)
See `_templates/issue-template.md`. `scripts/check_issue.rb` enforces these rules:
- Front matter: `title`, `issue` (number), `date` (matches the file name), `semester`
  (e.g. `Fall 2026`), `this_week` (one sentence), `challenge` (one action). The last two are
  30 words or fewer and are shown at the top and bottom of the page.
- Optional image: `image` (file name in `assets/images/issues/`, under 300 KB, about 1200 px
  wide), `image_alt` (one sentence for screen readers, 30 words or fewer) and `image_credit`
  (e.g. `Screenshot by Brent Presley`, `AI-generated with <tool>`). If `image` is set, the
  other two are required. It shows under the page title. No images in the body. Only use
  images Brent supplies or that are clearly free to use; never news-site photos. Label
  AI-generated images as AI-generated.
- Exactly five sections, in this order, each with exactly one `###` headline:
  1. `## The Big Picture` — one story, a `**Why it matters to you:**` line, and a link.
  2. `## Also This Week` — a second, smaller story: 2–3 sentences and a link, 80 words or
     fewer. No "why it matters" line.
  3. `## Level Up: <type>` — type rotates weekly: `Word of the Week`, `Myth vs. Fact`,
     `Spot the Fake`.
  4. `## Try This` — the prompt in a ```` ```text ```` block and a `**What to look for:**` line.
  5. `## Is This OK? <type>` — type rotates: `Academic Honesty`, `Privacy`. Ends with a
     `**My answer:**` line.
- Length: each section 120 words or fewer, whole issue 530 or fewer (prompt not counted).
  Aim for about 470.
- Issues dated before 2026-11-05 used the old four-section, 450-word format; the checker
  still checks them that way. Don't add Also This Week to them.
- To rotate, look at the most recent issue in `_issues/` and pick a different type.

## Commands
- Check an issue: `ruby scripts/check_issue.rb _issues/<file>.md`
- Build the site locally: `JEKYLL_NO_BUNDLER_REQUIRE=true jekyll build --unpublished`
  (or `bundle exec jekyll serve` after `bundle install`)

## Workflow rules
- Every Tuesday at 5:45 AM Central, a scheduled task starts a new session that runs the
  `weekly-briefing` skill. Brent picks stories from it, holds his session, then replies with
  his picks and notes in that same session, which runs `new-issue`.
- Use the `new-issue` skill for each week's issue.
- Work on a branch and open a pull request. Brent reviews and merges; merging to the default
  branch publishes the issue.
- Use `published: false` in front matter for drafts that should not appear on the site.
- Don't change layouts, CSS or the issue format while writing an issue. Suggest it instead.
