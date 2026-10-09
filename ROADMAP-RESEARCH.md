# 10-app research, audit and roadmap (9 Oct 2026)

**How it gets built:** each item below is a GitHub issue labelled `ready`. The cloud Claude agent in each repo
takes the oldest one, writes tests and code, opens a PR, and auto-merge lands it when CI is green, then it chains
to the next. It runs on GitHub, so it keeps going with the laptop off; if the Claude usage limit is hit, it
resumes on the next 2-hourly run after the limit resets.

**Design rule for "rewarding" features:** reward progress and habits (streaks, goals, celebrations), never punish,
no dark patterns, and respect *reduced motion* settings.

## Audit (before this round)
All 10 repos: CI green on `main`, 0 open issues, 59 earlier issues completed by the agent (persistence, filters,
dark theme, accessibility, PWA, pagination, rate limiting, model card, etc.).

| App | Top apps studied | What wins in the category | Being built now (issues) |
|---|---|---|---|
| Expense Tracker (Android) | Money Manager, Spendee, YNAB, Bluecoins | Fast entry, visual budgets, category charts | Budget bar #27 · Charts #28 · Logging streak #29 · Recurring + one-tap #30 · Backup to Drive #31 |
| EMI Calculator (Android) | EMI Calculator: Loan Manager (4.7★, 29k reviews) | Loan manager, compare, graphs | Charts #28 · Saved loans #29 · Prepayment savings #30 · Affordability #31 · Share #32 |
| Notes (Android) | Google Keep, ColorNote | Checklists, colours, labels, reminders | Checklists #28 · Colours #29 · Archive/Trash #30 · Tags #31 · Backup to Drive #32 |
| Loan Calculator (web) | NerdWallet, Bankrate | Extra payments, affordability, full cost | Extra payments #20 · Affordability #21 · Chart #22 · Compare #23 · Full monthly cost #24 |
| Todo (web) | Todoist, TickTick | Karma points/levels, streaks, recurring, priorities | Points/levels/goal #20 · Streak #21 · Celebration #22 · Priorities #23 · Recurring #24 |
| Weather (web) | AccuWeather, Weather Channel, CARROT, Apple Weather | 7-day, air quality/UV, "rain starts at", design | 7-day #21 · Air quality/UV #22 · Rain soon #23 · Favourites #24 · Animated sky #25 |
| Portfolio (web) | Hired-developer portfolios | Real work, case studies, live demos, speed | Case studies #20 · Live demos + API status #21 · SEO #22 · GitHub activity #23 |
| Inventory API (Node) | Inventory systems best practice | Movement audit trail, low-stock alerts | Movements #21 · Low-stock alerts #22 · API key #23 · CSV #24 · OpenAPI #25 |
| Bookstore API (Python) | Google Books, Open Library | Ratings/reviews, subjects, similar titles, ISBN | Reviews #25 · Author/genre #26 · Similar #27 · ISBN #28 · API key #29 |
| House Price ML | Zillow Zestimate, SHAP/conformal research | Price ranges, explanations, serving, drift | Intervals #21 · Explain #22 · HTTP server #23 · Drift #24 · Quality gate #25 |

## Notes
- Android apps stay **offline with no INTERNET permission**, so their Play "Data safety" stays "no data collected".
  Backup uses the system file picker, which lets users choose Google Drive.
- The two APIs get API keys for writes because they are public on Render. Add `API_KEY` in Render when the issues land.
- Ranking #1 on a store depends on reviews, installs and marketing as well as features; this round closes the
  feature gaps against the category leaders.

## Sources
- Expense apps: getfinny.app/blog/best-money-manager-apps-2026 · capterra.co.uk/software/1021163/spendee · gummysearch.com/tools/best-products/expense-tracker
- EMI apps: apps.appfollow.io/ios/emi-calculator-loan-manager/1491902865
- Notes: androidauthority.com/best-note-taking-apps-for-android-205356 · zapier.com/blog/best-note-app-for-android
- To-do: clickup.com/blog/ticktick-vs-todoist · hulry.com/firesides/gamification
- Weather: bgr.com/2176330/best-weather-apps-2026 · itechguides.com/the-best-weather-apps-for-2026-compared-by-use-case
- Portfolio: dev.to/jtrevdev/best-developer-portfolio-websites-and-why-they-work-3bdk
- Inventory: codemia.io inventory system design · mintlify.com inventory guides
- Books: api.market/blog/skycraft/books-api/best-books-api · developers.googleblog.com/new-books-api-for-developers
- ML: machinelearningmastery.com SHAP for tree models · datanovia.com conformal intervals · zillow.com/research/putting-accuracy-in-context-3255
- Mortgage calculators: mathos.ai best loan payment calculators · estatepass.ai/best/mortgage-calculator
