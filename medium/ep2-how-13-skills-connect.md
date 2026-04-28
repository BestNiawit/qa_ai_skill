# EP2: How 13 AI Skills Actually Connect — And Why We Started Thinking About Token Cost

*If you haven't read EP1, the short version: our QA team was using ChatGPT the wrong way. Everyone had their own prompts, their own output formats, and their own interpretation of what "done" looks like. We fixed it by building skills that embed team context instead of asking people to explain it every session. This is what happened after that.*

---

I want to start with something I got wrong.

When we finished the first few skills, I assumed the hardest part was over. We had `test-case-writer`, `bug-report-writer`, `test-report-writer` — the three things QA does every single sprint. I thought we'd just stack more skills on top and call it a workflow.

What I didn't realize is that **a collection of skills isn't a workflow**. It's just a collection.

The gap between "we have 13 tools" and "we have a system" took longer to close than building the tools themselves.

---

## The first time the chain actually worked

About two months in, a team member was handed a BRD on a Monday morning. New feature, medium complexity, needed TC by Thursday.

She ran through it like this:

```
Monday AM:   /requirement-analyzer  →  "Readiness: 71%. Here are 4 questions
                                         you need PM to answer before writing TC."

Monday PM:   Sent questions. PM replied same day (rare, but it happened).

Tuesday:     /requirement-analyzer again  →  "Readiness: 94%. Ready."
             /test-plan-writer             →  Draft plan with schedule estimate

Wednesday:   /data-type-matrix-generator  →  field-level coverage for 3 new inputs
             /test-case-writer             →  full TC, SIT + UAT mode

Thursday AM: /test-case-reviewer          →  flagged 2 gaps, suggested 1 merge
             (30 min to fix, approved by noon)
```

Thursday afternoon she had a reviewed, approved test case set. For a feature that would normally eat the whole week.

That was the first time it felt like a pipeline instead of a bunch of separate scripts.

---

## What the workflow actually looks like (not the pretty version)

Here's the honest diagram — including the parts that aren't clean:

```
INPUT: BRD / PRD / Spec / User Story
         │
         ▼
┌─────────────────────────────────┐
│  LANE 1 — Pre-Testing Gate      │
│                                 │
│  requirement-analyzer           │  ← sometimes loops 2-3x
│         │                       │    before PM confirms
│         ▼                       │
│  test-plan-writer               │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  LANE 2 — Test Design           │
│                                 │
│  data-type-matrix-generator     │  ← skip if requirement
│         │                       │    is already well-defined
│         ▼                       │
│  test-case-writer               │
│    ├── test-matrix-generator    │  ← for multi-variable
│    └── test-case-reviewer       │    combinations
└──────┬──────────────┬───────────┘
       │              │
       ▼              ▼
┌──────────────┐  ┌──────────────────────────┐
│  LANE 3      │  │  LANE 4 — Automation     │
│  Manual/UAT  │  │                          │
│              │  │  robot-test-generator    │
│  (execute    │  │  e2e-test-generator      │
│   the TCs)   │  │  perf-test-generator     │
└──────┬───────┘  └──────────┬───────────────┘
       └──────────┬───────────┘
                  │
                  ▼
┌─────────────────────────────────┐
│  LANE 5 — Reporting             │
│                                 │
│  bug-report-writer              │
│  perf-result-analyzer           │
│  test-report-writer             │
│  weekly-update-writer           │
└─────────────────────────────────┘
```

You don't run all 5 lanes every time. Small feature with no automation scope? Skip Lane 4. Well-written requirement with no ambiguous fields? Skip `data-type-matrix-generator`. Performance isn't in scope this sprint? Skip `perf-test-generator` and `perf-result-analyzer`.

The structure isn't a railroad. It's more like a decision tree where most branches are optional but at least one path always gets you to a review-ready output.

---

## The thing nobody talks about: Token Economy

This is the part I find myself explaining most when people ask about the system, and it's also the part that sounds the most abstract until it clicks.

**Token is not just money. Token is attention.**

Every token you send to a language model is part of what it has to hold in its head while generating a response. The more context you dump in, the more the model has to split its attention across things that may or may not be relevant to the actual question.

This matters in a very practical way. We ran a test early on — same requirement, two prompts:

**Prompt A (old way):** Explained severity scale, priority scale, output format, what "expected result" should look like, guardrails around sensitive data, and then pasted the full 400-line requirement.

**Prompt B (skill way):** `/test-case-writer` + the 400-line requirement. No explanation. The skill already knows everything from Prompt A because it's baked in.

Output quality: roughly equal.  
Token count: Prompt A used about 1,400 tokens just on instructions before even touching the requirement.

Multiply that by every session, every team member, every sprint. It adds up. But the bigger cost isn't money — it's that every extra token of instruction is a token not spent on actually understanding your requirement.

---

## Three principles we now design every skill around

**1. Skills should know what they need without being told.**

Severity scale, priority scale, output column order, what counts as a valid expected result, when to flag something as TBD instead of guessing — all of this lives inside the skill. The person calling it shouldn't need to re-explain team standards.

This sounds obvious. It wasn't obvious to us at first. Our early skills were basically "nice prompts saved as files." The shift happened when we stopped thinking "what should I tell the AI" and started thinking "what does this AI need to already know to do this without asking."

**2. Output of skill N is input of skill N+1. No reformatting.**

`requirement-analyzer` produces a structured readiness report in a format that `test-case-writer` can consume directly. `test-case-writer` produces TCs in a format that `robot-test-generator` understands. Each handoff is designed so the next skill doesn't have to spend tokens parsing data that arrived in the wrong shape.

The first time we violated this principle — we had a skill that produced a summary paragraph and expected the next skill to extract structured data from it — we spent three sessions debugging why the downstream skill kept missing fields. The answer was just: prose is expensive to parse and lossy. Tables and structured output are cheap.

**3. Separate what persists from what's session-specific.**

There are two kinds of context in this system:

- **Persistent context** (`project-context.md`): base URL, environment variables, team-specific business rules, glossary of domain terms. Every skill reads this automatically. Never paste this manually.
- **Session context**: the BRD you're analyzing today, the specific TC set you're reviewing right now. Loaded once, used, gone.

Before we made this distinction explicit, people were pasting the entire project context *plus* the document *plus* instructions into every session. By the time you got to the actual work, the model was already half-distracted.

---

## Where the chain breaks (and what we do about it)

Honest answer: Lane 4 is the weakest link.

Automation skills (`robot-test-generator`, `e2e-test-generator`) have a hard dependency on locator information — the actual HTML structure of the page you're testing. Without it, the AI generates plausible-looking selectors that don't exist, which is arguably worse than generating nothing because you find out at runtime instead of at review time.

Our solution is a rule: **no automation skill runs without a locator source**. That means either pasting the relevant HTML snippet, providing `data-testid` attributes we control, or accepting that the generated script will have placeholder locators that a human needs to fill in before running.

It's not elegant. But it's honest, and it prevents the thing we were trying to avoid in EP1 — an output that looks right but fails at execution.

The other break point is `perf-result-analyzer`. It works well when test results are structured. It falls apart when your performance tool outputs a non-standard format or when the test run had infrastructure noise that's hard to distinguish from actual regressions. We haven't solved this fully. Right now it's flagged in the skill as "requires human judgment on anomalies" and we mean it.

---

## What surprised us after six months

The biggest productivity gain wasn't from the heavy-lift skills like `test-case-writer` or `test-report-writer`.

It was from `weekly-update-writer`.

Nobody on the team liked writing weekly status updates. They're necessary, they take maybe 30-45 minutes to write properly, but they're not interesting work and they feel like time stolen from actual testing. The moment we had a skill that could read the week's bug reports, closed TCs, and blockers — and produce a first draft in two minutes — the collective mood of Friday afternoons changed noticeably.

Small friction, consistently removed, compounds.

The second surprise was how much the skills changed how we communicate with PM. When `requirement-analyzer` produces a structured list of open questions with severity tags, PMs started taking requirement gaps more seriously. Not because the AI was more authoritative than us — but because a structured document with "these 4 ambiguities could cause rework" is harder to ignore than a Slack message saying "hey this BRD is unclear."

Format changes behavior. We didn't expect that side effect.

---

## What's next

EP3 is going to be the one where I talk about what we built and threw away, why `data-type-matrix-generator` almost didn't make it into the system, and the argument we had internally about whether AI should ever be allowed to estimate effort in a test plan (short answer: it shouldn't, and here's why we tried it anyway).

The less-polished version of how this actually got built.

---

*The skills are open-source. If you're building something similar or want to see how any of this is structured, drop a comment and I'll share the repo.*
