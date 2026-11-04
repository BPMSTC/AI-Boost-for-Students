---
name: weekly-briefing
description: Researches the last 7 days of AI news and gives Brent a short, verified menu of stories to choose from for his weekly AI session and the student newsletter. Runs automatically every Tuesday morning; also use when Brent says "weekly briefing", "what's the AI news this week", or "give me the list".
---

# Weekly AI news briefing

Brent picks from this list to plan his weekly AI session. The newsletter (out Wednesday) then
recaps the session. Your job is research only: **do not write the issue, create a branch, or
open a pull request** until Brent replies with his picks.

Read `CLAUDE.md` first for the audience and the "never invent facts" rule.

## 1. Set the window
- Today's date (Central time) is the briefing date.
- The window is the 7 days before it, e.g. a Tuesday Nov 10 briefing covers Nov 3–9.
- Only stories **published inside the window** count. Older stories that are trending again
  can appear only if something new happened inside the window.

## 2. Check what's already been covered
Read every file in `_issues/`. List the stories and links already used, so you don't
repeat them. Note the latest issue's `Level Up` and `Is This OK?` types for rotation.

## 3. Search
Search the web for news inside the window in each of these areas. Use several searches per
area; prefer primary sources (company announcements, research papers, government sites) and
established news outlets over blogs and aggregators.

1. **Big-picture AI news**: the biggest stories of the week that a student will hear about.
2. **AI tools students use**: ChatGPT, Claude, Gemini, Copilot, Grammarly, Canva, Snapchat
   My AI, phone assistants, and similar: new features, price changes, outages, problems.
3. **Jobs and careers**: AI changing hiring, skills, and fields Mid-State students go into
   (IT, health care, manufacturing, trades, business, criminal justice, early childhood).
4. **Education and cheating**: AI in schools and colleges, detection tools, policies.
5. **Safety, privacy, deepfakes**: scams, fake images/audio/video, data privacy, AI mistakes.

## 4. Verify
For every story you keep:
- Open the source with WebFetch and confirm it says what your summary says.
- Confirm the publish date is inside the window.
- If a page won't load or the claim can't be confirmed, drop the story or mark it
  **Unverified** with the reason. Never guess a date, number, or quote.

## 5. Pick and rank
Keep **8 to 10 stories**, at least one from each area when the week has one. Rank by how much
the story matters to a community-college student (their classes, money, job, safety), not by
how much tech-industry buzz it has. Drop near-duplicates; keep the best source.

## 6. Reply with the briefing
Write it so it reads well on a phone. Plain words, no hype. Use exactly this layout:

```
# AI news briefing: <Mon D> – <Mon D, YYYY>

## Stories (best first)

**1. <Headline in plain words>**  ·  <Area>
<One or two sentences: what happened.>
Why students care: <one sentence>
Talking point: <one question or demo idea for the session>
Source: <Outlet>, <Mon D> — <URL>

**2. ...**

## Ideas for the other sections
- **Level Up: <type>** (last issue used <type>): <term, myth, or fake example tied to a story above>
- **Try This:** <a prompt idea tied to a story or tool above>
- **Is This OK? <type>** (last issue used <type>): <a one-line student scenario>

## Notes
- <Unverified items, broken links, or "none">

---
Reply with the numbers you want (e.g. "2 for Big Picture, 5 for Also This Week") after your
session, plus your session notes, and I'll write the issue and open a pull request.
```

## 7. When Brent replies
Use the `new-issue` skill. Pass it his picks and session notes, and these briefing notes as
research: the picked stories are already verified, so the researcher only needs to re-check
them and fill in anything new from his notes.
