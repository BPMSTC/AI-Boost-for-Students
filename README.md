# AI Boost for Students

A short weekly newsletter (about a 3-minute read) recapping the AI topics from our weekly
session at Mid-State Technical College. One issue per week of the semester, published at the
project's GitHub Pages site.

Each issue has five sections:

| Section | Goal |
|---|---|
| The Big Picture | What's happening in AI and why it matters to you |
| Also This Week | A second, shorter news story with a link |
| Level Up | AI acumen: a word of the week, myth vs. fact, or spot the fake |
| Try This | Using AI effectively: one prompt to copy |
| Is This OK? | Using AI ethically: academic honesty or privacy |

Plus a one-line "This week" opener, one "Your Challenge" action, and an optional image.

## Add this week's issue (by hand)
1. Copy `_templates/issue-template.md` to `_issues/YYYY-MM-DD-short-name.md`
   (for example `_issues/2026-11-11-week-11.md`).
2. Fill in the front matter and the five sections. Rotate the Level Up and Is This OK?
   types from last week's.
   For an image, put it in `assets/images/issues/` (under 300 KB) and fill in `image`,
   `image_alt` and `image_credit`. No image this week? Delete those three lines.
   To shrink a big image: `convert big.png -resize 1200x\> -quality 80 small.jpg`
3. Check it (it also checks length): `ruby scripts/check_issue.rb _issues/YYYY-MM-DD-short-name.md`
4. Commit and push. The site updates in about a minute.

## Tuesday news briefing (automatic)
Every Tuesday at 5:45 AM Central, Claude researches the last 7 days of AI news and opens a new
Claude Code session with 8–10 verified stories to choose from (notification on your phone).
Reply in that session with your picks and session notes, and it writes the issue. The steps it
follows are in `.claude/skills/weekly-briefing/SKILL.md`; edit that file to change them.

## Add this week's issue (with Claude Code)
Open the repo in Claude Code and say "new issue" with your session notes. The `new-issue`
skill researches the topics, drafts the issue, checks it and opens a pull request for review.

## Preview the site on your computer
```bash
bundle install
bundle exec jekyll serve
```
Then open http://localhost:4000/AI-Boost-for-Students/

## Change the look
All styling is in `assets/css/main.scss`. The colors are variables at the top of that file.

## One-time setup: turn on GitHub Pages
Repository **Settings → Pages → Build and deployment**: Source "Deploy from a branch",
branch `main`, folder `/ (root)`.
