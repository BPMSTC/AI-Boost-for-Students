# AI Boost for Students

A weekly newsletter recapping the AI topics from our weekly session at Mid-State Technical
College. One issue per week of the semester, published at the project's GitHub Pages site.

## Add this week's issue (by hand)
1. Copy `_templates/issue-template.md` to `_issues/YYYY-MM-DD-short-name.md`
   (for example `_issues/2026-11-11-week-11.md`).
2. Fill in the front matter and each section. Delete sections you don't need, except
   Quick Scan, Try This and the two Follow-up sections.
3. Put any images in `assets/images/issues/YYYY-MM-DD-short-name/`.
4. Check it: `ruby scripts/check_issue.rb _issues/YYYY-MM-DD-short-name.md`
5. Commit and push. The site updates in about a minute.

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
