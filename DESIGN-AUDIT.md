# Design audit and redesign plan (9 Oct 2026)

Screenshots of the live sites before the redesign: `reports/design-before/` (desktop 1280px and phone 390px).

## Findings
| App | Problems found |
|---|---|
| todo-web | Small grey text, identical blue buttons, no brand; on phones the input row overflows the screen |
| weather-dashboard-web | Empty page on first visit until you search; no hero, no visuals |
| loan-calculator-web | Long wall of fields; the result is far below the inputs |
| portfolio-web | Plain list, no images; on phones the header button and filter chips are cut off |
| Android apps (3) | Default Material look, no hero, no motion or illustrations |
| APIs and ML model | Raw JSON only; no page for humans |

## Direction (research-based)
2026 leaders use bento grids, layered glass for depth, bold type, purposeful micro-interactions and, on Android,
Material 3 Expressive (rich colour, expressive shapes, spring motion). Every animation respects reduced-motion settings.

| App | Personality | Palette | Font | Signature elements | Issues |
|---|---|---|---|---|---|
| Todo | Calm focus (Things 3, Todoist) | Violet #6D5DFC to #A78BFA, green done, amber streak | Plus Jakarta Sans | Progress-ring hero, animated checkboxes | #30-32 |
| Weather | Living sky (Apple Weather) | Sky gradient by condition, glass cards | Inter | Full-screen hero, glass bento, sunrise arc, AQI gauge | #31-33 |
| Loan | Trustworthy finance (NerdWallet) | Emerald #0F766E, mint #34D399, navy | Manrope | Sliders, sticky result, donut, savings badge | #30-32 |
| Portfolio | Developer premium (Linear, Vercel) | Dark #07070C, violet to cyan mesh | Space Grotesk + Inter | Gradient hero, bento with images, Block Drop featured | #28-30 |
| Expense | Material 3 Expressive | Seed emerald #10B981 / dynamic | Roboto Flex | Hero month card, tinted category icons | #37-38 |
| EMI | Material 3 Expressive | Seed indigo #4F46E5 / dynamic | Roboto Flex | Big EMI hero with donut, sliders | #38-39 |
| Notes | Material 3 Expressive | Seed amber #F59E0B / dynamic | Roboto Flex | Keep-style colourful staggered grid | #38-39 |
| Inventory / Bookstore API | Product page | Matches portfolio | system | Landing page with live data | #31 / #35 |
| House Price ML | Demo app | Matches portfolio | system | Prediction form with range bar and factors | #31 |

## Sources
- line25.com/articles/web-design-trends-2026 · theplusaddons.com/blog/web-design-trends-2026 · studiomeyer.io/en/blog/webdesign-trends-2026
- Material 3 Expressive: developer.android.com/design/ui/wear/guides/get-started/apply · composables.com/material3/materialexpressivetheme
- Award examples: winners.webbyawards.com (Craft, best UI) · designrush.com/best-designs/apps/productivity
