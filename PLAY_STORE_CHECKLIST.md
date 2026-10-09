# Google Play Console checklist

Use this after your ID verification. Do these steps once per app.

| App | Package name | Repo (assets in `fastlane/metadata/android/en-US/`) |
|---|---|---|
| Expense Tracker | `com.sabin.expensetracker` | expense-tracker-android |
| EMI Calculator | `com.sabin.emicalculator` | emi-calculator-android |
| Notes | `com.sabin.notes` | notes-android |
| Block Drop Puzzle (game) | `com.sabin.blockdrop` | blockdrop-puzzle-unity |

Privacy policy URL (all apps): **https://sabin78910.github.io/privacy-policy/**

## 1. Create app
Play Console → **Create app**
- App name: the `title.txt` text
- Default language: English (United States)
- App or game: **App** (Block Drop: **Game**)
- Free or paid: **Free**
- Tick both declarations → **Create app**

## 2. Store listing (Grow → Store presence → Main store listing)
- Short description: `short_description.txt`
- Full description: `full_description.txt`
- App icon: `images/icon.png` (512×512)
- Feature graphic: `images/featureGraphic.png` (1024×500)
- Phone screenshots: `images/phoneScreenshots/1.png`, `2.png`
- App category: Finance (Expense, EMI) · Productivity (Notes) · Puzzle (Block Drop)
- Contact email: your support email

## 3. App content (Policy → App content)
| Form | Answer |
|---|---|
| Privacy policy | the URL above |
| App access | All functionality is available without special access |
| Ads | **No**, my app does not contain ads |
| Content rating | Fill the questionnaire. Category: Utility/Productivity (Block Drop: Game). Answer **No** to violence, sexuality, gambling, user interaction, sharing location, and purchases. |
| Target audience | **18 and over** (simplest for utilities; avoids the Families policy). Block Drop: 13+ unless you want Families. |
| News app | No |
| Data safety | Expense, EMI, Notes: **No** data collected (everything stays on the device, no internet permission). **Block Drop: see its section below.** |
| Government app | No |
| Financial features (Expense, EMI) | None of the listed features (no loans issued, no banking, it's a calculator/tracker) |
| Health | No |

## 4. Upload the build (Test and release → Testing → Closed testing)
1. **Create track** (or use "Alpha") → **Create new release**
2. App signing: accept **Play App Signing** (Google holds the app key; your upload key stays in `~/Documents/PlayStoreKeys/`)
3. Upload the AAB:
   - Android apps: GitHub repo → **Actions** → latest "Google Play (internal track)" run → artifact **app-release-aab** → unzip → `app-release.aab`
   - Block Drop: Unity Build Automation → Build history → latest green **Play Release** build → ⋯ → Download. Unity labels it ".APK" but it is an App Bundle: rename the file to `.aab` before uploading (build #4 is already saved as `~/Desktop/BlockDrop-PlayRelease-4.aab`)
4. Release name: `1.0.0` · Notes: "First release"
5. **Testers:** create an email list with your testers' Gmail addresses → share the opt-in link with them
6. Review → **Start rollout to Closed testing**

## 5. Closed testing → Production
- Personal accounts created after 13 Nov 2023 must run a closed test with **at least 12 testers opted in for the last 14 days in a row** before applying for production. If you drop below 12 at any point, the 14 days start again. Organisation accounts are exempt.
- Start recruiting now: 12+ friends or family with an Android phone and a Gmail address. Add a few spares in case someone drops out.
- Keep testers opening the app during those 14 days.
- Then **Dashboard → Apply for production** → answer the questions → wait for review.

## 6. Later: automatic uploads (optional)
Once each app exists in Play Console and has had one manual upload:
1. Google Cloud Console → enable the **Google Play Android Developer API** → create a service account → JSON key
2. Play Console → **Users and permissions** → invite the service-account email → give it release rights for the apps
3. Add the JSON to each Android repo as the secret `PLAY_SERVICE_ACCOUNT_JSON`
4. From then on, every merge to `main` uploads to the internal track automatically.

## Block Drop: Data safety is different (online leaderboards)
Block Drop sends an **anonymous player ID** and **scores** to Unity Gaming Services when online. In Data safety, answer:
- Does your app collect or share user data? **Yes**
- Data types collected:
  - **Device or other IDs**: the anonymous Unity player ID. Purpose: **App functionality**. Not shared.
  - **App activity → Other actions**: game scores. Purpose: **App functionality**. Not shared.
  - **Personal info → Name**: the optional nickname players can set, shown on public leaderboards. Purpose: **App functionality**. Optional. Not shared.
- Is data encrypted in transit? **Yes**
- Can users request deletion? **Yes**, via the contact link in the privacy policy
- Is collection optional? **Yes**. The game works fully offline.
- Unity acts as a service provider (processor), which Google doesn't count as "sharing". Check the current Play wording when you fill the form.
- Content rating: there is no chat, but players can choose a nickname that others see on the leaderboards. If the questionnaire asks whether users can interact or share content, answer **Yes** to stay on the safe side.

### Unity dashboard (one time)
cloud.unity.com → Block Drop Puzzle → **Leaderboards** → create:
- `Classic`: Highest to lowest · Best score · No reset  ✅ created
- `Daily`: Highest to lowest · Best score · Reset every day 00:00 UTC  ✅ created
- IDs are case-sensitive and must match `OnlineService.cs`.

## Block Drop: Unity Build Automation targets
- **Play Release**: App Bundle signed with the upload key. Build this one for Google Play (click Build manually).
- **Default Android**: unsigned test APK. Not needed (APKs are built locally). Turn **Auto-build off** so pushes don't use free build minutes.
- Store listing text and graphics: `blockdrop-puzzle-unity/store/`.
