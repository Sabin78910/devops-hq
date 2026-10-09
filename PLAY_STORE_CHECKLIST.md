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
| Data safety | Does your app collect or share user data? **No**. Everything stays on the device, and the apps have no internet permission. |
| Government app | No |
| Financial features (Expense, EMI) | None of the listed features (no loans issued, no banking, it's a calculator/tracker) |
| Health | No |

## 4. Upload the build (Test and release → Testing → Closed testing)
1. **Create track** (or use "Alpha") → **Create new release**
2. App signing: accept **Play App Signing** (Google holds the app key; your upload key stays in `~/Documents/PlayStoreKeys/`)
3. Upload the AAB:
   - Android apps: GitHub repo → **Actions** → latest "Google Play (internal track)" run → artifact **app-release-aab** → unzip → `app-release.aab`
   - Block Drop: Unity Build Automation → Build history → latest green build → download the **.aab** (see note below)
4. Release name: `1.0.0` · Notes: "First release"
5. **Testers:** create an email list with your testers' Gmail addresses → share the opt-in link with them
6. Review → **Start rollout to Closed testing**

## 5. Closed testing → Production
- New personal accounts must run closed testing with real testers for the period Play Console shows (check the exact tester count and days on the **Dashboard**).
- Keep testers opening the app during that time.
- Then **Dashboard → Apply for production** → answer the questions → wait for review.

## 6. Later: automatic uploads (optional)
Once each app exists in Play Console and has had one manual upload:
1. Google Cloud Console → enable the **Google Play Android Developer API** → create a service account → JSON key
2. Play Console → **Users and permissions** → invite the service-account email → give it release rights for the apps
3. Add the JSON to each Android repo as the secret `PLAY_SERVICE_ACCOUNT_JSON`
4. From then on, every merge to `main` uploads to the internal track automatically.

## Block Drop on Play: two extra Unity settings
In Unity Build Automation → Configurations → Default Android → Edit:
- **Android SDK version: 36**, to match the project's target API 36
- **Build App Bundle (AAB): on**. Play needs `.aab`, not `.apk`.
- **Credentials:** upload `~/Documents/PlayStoreKeys/upload-keystore.jks` (alias `upload`, your keystore password) instead of the debug keystore, for the Play release build
