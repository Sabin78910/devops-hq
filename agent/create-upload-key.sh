#!/usr/bin/env bash
# Creates ONE Play Store upload key for your Android apps and stores it as GitHub secrets
# (KEYSTORE_BASE64, KEYSTORE_PASSWORD, KEY_ALIAS, KEY_PASSWORD) in each Android repo.
# Google holds the real app-signing key (Play App Signing); this upload key can be reset via
# Play Console support if lost — but BACK IT UP anyway.
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"
KEYTOOL="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool"
DIR="$HOME/Documents/PlayStoreKeys"; KS="$DIR/upload-keystore.jks"; ALIAS="upload"
REPOS="expense-tracker-android emi-calculator-android notes-android prism-pop-game ludo-live khabar-pulse nepse-lens"
mkdir -p "$DIR"; chmod 700 "$DIR"
if [ -f "$KS" ]; then echo "Keystore already exists at $KS — reusing it."; else
  read -rsp "Choose a keystore password (min 8 chars, hidden): " P1; echo
  read -rsp "Repeat password: " P2; echo
  [ "$P1" = "$P2" ] && [ ${#P1} -ge 8 ] || { echo "✗ Passwords don't match or too short."; exit 1; }
  read -rp "Your name for the certificate (e.g. Sabin Khanal): " CN
  "$KEYTOOL" -genkeypair -v -keystore "$KS" -alias "$ALIAS" -keyalg RSA -keysize 4096 -validity 10000 \
    -storepass "$P1" -keypass "$P1" -dname "CN=$CN, C=NP" >/dev/null 2>&1
  chmod 600 "$KS"; echo "✓ Created $KS"
fi
[ -n "${P1:-}" ] || { read -rsp "Keystore password (hidden): " P1; echo; }
"$KEYTOOL" -list -keystore "$KS" -storepass "$P1" >/dev/null 2>&1 || { echo "✗ Wrong password for $KS"; exit 1; }
B64=$(base64 -i "$KS")
for R in $REPOS; do
  printf '%s' "$B64"   | gh secret set KEYSTORE_BASE64   -R "Sabin78910/$R" >/dev/null
  printf '%s' "$P1"    | gh secret set KEYSTORE_PASSWORD -R "Sabin78910/$R" >/dev/null
  printf '%s' "$ALIAS" | gh secret set KEY_ALIAS         -R "Sabin78910/$R" >/dev/null
  printf '%s' "$P1"    | gh secret set KEY_PASSWORD      -R "Sabin78910/$R" >/dev/null
  echo "set: $R"
  gh workflow run play-store.yml -R "Sabin78910/$R" >/dev/null 2>&1 || true
done
unset P1 P2 B64
echo
echo "IMPORTANT: back up $KS and your password (e.g. password manager + USB drive)."
echo "Signed AAB builds started — download them from each repo's Actions tab (artifact 'app-release-aab')."
