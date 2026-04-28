<!--
  EP2 — Final published version
  Published: 2026-04-28
  URL: https://medium.com/@nirawit.mail/ep2-how-13-ai-skills-actually-connect-and-why-token-cost-started-bothering-me-f965f4de7eed
  Language: English
  Tone: casual, first-person, beginner-writer voice (no em dashes, no AI aphorisms)
  Images: see /medium/assets/ep2/
-->

# EP2: How 13 AI Skills Actually Connect, And Why Token Cost Started Bothering Me

> *Quick recap if you skipped EP1. Our QA team was using ChatGPT in a kind of messy way. Everyone had their own prompts, their own output format, their own version of what "done" meant. We tried to fix that by building skills with team context baked in, so people didn't have to re-explain everything every session. This post is what happened after that.*

. . .

## *Okay so I want to start by admitting something I got wrong.*

After we finished the first 3 skills I kind of thought the hard part was over. We had `test-case-writer`, `bug-report-writer`, `test-report-writer`, basically the three things QA does every sprint, and in my head we just had to keep stacking more skills on top and we'd be done.

Turns out that's not really how it works. **Having 13 skills doesn't mean you have a workflow.** It just means you have 13 skills sitting in a folder. Getting from "we have tools" to "we have an actual system that flows together" honestly took us way longer than building the tools in the first place, and that's the part I want to talk about in this post.

. . .

## The first time the chain actually worked end to end

About two months into all this, one of the team members got handed a BRD (basically a requirement doc from PM) on a Monday morning. It was a new feature, medium complexity, and she had to deliver test cases by Thursday. Tight but doable.

She didn't follow some master plan. She just opened the requirement, ran it through `requirement-analyzer` first to see if it was even ready to test, sent the gaps back to PM, and chained from there. The whole thing took about 3.5 days, and honestly most of that was waiting on PM replies.

Here's how she actually went through it:

> **[IMAGE: timeline-mon-thu]** — Mon AM `/requirement-analyzer` Readiness 71% → 4 questions for PM. Mon PM PM replied same day. Tue `/requirement-analyzer` Readiness 94% READY → `/test-plan-writer` draft + estimate. Wed `/data-type-matrix-generator` (3 new inputs) → `/test-case-writer` full TC SIT+UAT. Thu AM `/test-case-reviewer` flagged 2 gaps, suggested 1 merge → approved by noon.

The thing that actually stood out wasn't really the speed though. It was more that nothing went sideways. She didn't have to redo test cases because the requirement got misunderstood. PM didn't come back on Wednesday with "oh wait we changed the scope." The reviewer flagged 2 small gaps and suggested one merge, and that was basically it. The whole thing kind of just worked, which sounds boring written down, but if you've done QA for any amount of time you know how rare a clean week actually is.

For comparison, the same kind of feature maybe six months earlier probably would've eaten her entire sprint. Like 5 days of writing TCs, another day of rework once PM clarifications trickled in, and almost guaranteed one round of "wait this TC doesn't match the final spec anymore." So pulling the whole thing off in 3.5 days with no rework felt kind of unreal the first time we saw it happen.

That was kind of when I started realizing the skills themselves weren't really the point. The actual thing that had changed was that people could stop firefighting long enough to finish things. And it got me thinking about why this version felt so different from how we used to work. The answer ended up being weirder than I expected, and it's something nobody really talks about until they have to deal with it.

. . .

## What the workflow actually looks like (not the pretty version)

Here's the honest diagram including the parts that aren't clean:

> **[IMAGE: pipeline-5-lanes]** — INPUT (BRD/PRD/Spec/User Story) → Lane 1 Pre-Testing Gate (`requirement-analyzer` loops 2-3x until PM confirms → `test-plan-writer`) → Lane 2 Test Design (`data-type-matrix-generator` skip if already well-defined → `test-case-writer` → `test-matrix-generator` + `test-case-reviewer`) → Lane 3 Manual/UAT (execute, manual run, UAT signoff) parallel to Lane 4 Automation (`robot-test-generator`, `e2e-test-generator`, `perf-test-generator`) → Lane 5 Reporting (`bug-report-writer`, `test-report-writer`, `perf-result-analyzer`, `weekly-update-writer`). Both manual + automation results feed reporting. Loop-back to Lane 1 until requirements stabilize.

One thing I want to be honest about, you don't actually run all 5 lanes every sprint. Like if it's a small feature with no automation scope, we just skip Lane 4. If the requirement is well-written and there's nothing ambiguous, we skip `data-type-matrix-generator`. If performance testing isn't in scope this sprint, we skip both `perf-test-generator` and `perf-result-analyzer`. So it's not really a fixed pipeline where you have to run everything in order. It's more like, depending on what you're working on, you pick the path that makes sense. Most branches are optional, but there's always at least one route that gets you to something a reviewer can actually look at.

. . .

## The thing I keep ending up explaining: tokens

This sounds abstract until it clicks, so I'll keep it short. **Tokens aren't just about cost. They're also about attention.** Every token you send to the model is something it has to keep track of while it's writing the response. So the more context you dump in, the more its attention gets spread across stuff that may or may not even matter for what you're actually asking.

Pretty early on we ran a quick test to see if this was real or if I was overthinking it. Same requirement, two prompts:

> **[IMAGE: token-compare]** — Prompt A "the old way": severity scale (5 levels), priority scale (P0–P3), output format, expected result definition, sensitive-data guardrails, then the full 400-line requirement. Used ~1,400 tokens before the requirement even started. Prompt B "the skill way": just `/test-case-writer` + `<400-line requirement>`. ~0 tokens of instructions, all attention goes to the requirement. Output quality: roughly the same.
>
> *Caption: Same input, same output quality. The difference is what the model spent its attention on.*

Output quality came out roughly the same. But Prompt A burned around 1,400 tokens just on instructions before it even got to the requirement. Multiply that by every session, every team member, every sprint, and yeah it adds up money-wise. But the bigger thing for me wasn't really the money. It was realizing that **every extra token I spent on instructions** was a token the model wasn't spending on actually understanding the requirement.

. . .

## Where the chain still breaks (because of course it does)

Honestly, Lane 4 is the weakest part of the whole thing.

The automation skills (`robot-test-generator`, `e2e-test-generator`) really need locator information to do their job, meaning the actual HTML structure of the page you're testing. Without that, the AI just generates selectors that look totally plausible but don't actually exist on the page. Which is kind of worse than generating nothing, because you only find out at runtime instead of when you're reviewing the script.

So we made a rule: **no automation skill runs without some kind of locator source.** That means either you paste the relevant HTML snippet, or you give it `data-testid` attributes that we control, or you just accept that the generated script will have placeholder locators that a human has to go in and fix before running.

It's not pretty, I know. But at least it's honest, and it stops us from falling back into the EP1 problem, where the output looks right but blows up the moment you try to actually run it.

The other place things fall apart is `perf-result-analyzer`. It works fine when the test results come in a structured format. But it kind of breaks down when the performance tool outputs something weird, or when there's infrastructure noise that's hard to tell apart from a real regression. We haven't fully solved this one yet. For now the skill literally says "requires human judgment on anomalies" and we mean it, it's not just a disclaimer.

> **[IMAGE: locator-source]** — Without locator source: AI invents `css=.btn-primary-login` (doesn't exist), `id=user_email_input` (guessed), ambiguous xpath. Looks plausible at review, blows up at runtime. With `data-testid` hooks: `<input data-testid="login-email" />`, `Input Text css=[data-testid="login-email"]`. Stable across UI refactors, runs first try.
>
> *Caption: Left: what the AI invents on its own. Right: what we feed it instead.*

. . .

## Stuff that surprised me after six months

The biggest productivity gain didn't actually come from the heavy-lift skills like `test-case-writer` or `test-report-writer`. Honestly the thing that helped the most was `weekly-update-writer`, which kind of caught me off guard.

Nobody on the team liked writing weekly status updates. They're necessary, they take like 30 to 45 minutes to do properly, but they're not interesting work at all and they always felt like time being stolen from actual testing. The moment we had a skill that could just read the week's bug reports, closed TCs, and blockers, and spit out a first draft in two minutes, the mood on Friday afternoons changed in a way I didn't expect. Small annoying tasks, when you remove them consistently, kind of add up over time. I didn't really get that until I saw it happen.

The other surprise was how the skills ended up changing the way we talk to PM. When `requirement-analyzer` produces a structured list of open questions with severity tags on each one, PMs actually started taking requirement gaps more seriously. Not because the AI is somehow more authoritative than us. It's more that a document saying "these 4 ambiguities could cause rework" is just harder to ignore than a Slack message saying "hey this BRD is kinda unclear." So basically **the format itself ended up changing how people responded**, which wasn't something we set out to do at all.

> **[IMAGE: pm-format]** — BEFORE Slack DM: "hey this BRD is kinda unclear, can you take a look when free?" → easy to scroll past, no clear next step, gets answered later (or not). AFTER `requirement-analyzer` output: Readiness 71% | 4 open questions, with HIGH/MED/LOW severity tags. "Discount cap not specified for combo orders (could cause rework)", "Refund window: 'reasonable time' is undefined (blocks TC writing)", "Currency rounding rule missing for THB/USD (data-type-matrix flag)", "UI copy for empty cart not in spec (TC-able with assumption)" → harder to ignore, PM replies with specifics not vibes, rare but happened same day.
>
> *Caption: Same complaint, two formats. The right side is just harder to scroll past.*

. . .

## What's coming in EP3

EP3 is going to be the one where I talk about the stuff we built and then threw away, why `data-type-matrix-generator` almost didn't make it into the system at all, and the internal argument we had about whether AI should ever be allowed to estimate effort in a test plan. (Short answer: probably not, but I'll explain why we tried it anyway.)

Basically the messier, less polished story of how this actually got built.

. . .
