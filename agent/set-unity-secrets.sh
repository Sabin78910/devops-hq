#!/usr/bin/env bash
# Sets UNITY_LICENSE, UNITY_EMAIL, UNITY_PASSWORD on blockdrop-puzzle-unity so GameCI can
# test and build the game in the cloud. Your password is typed hidden and goes straight to GitHub.
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"
REPO="Sabin78910/blockdrop-puzzle-unity"
ULF=""
for f in "/Library/Application Support/Unity/Unity_lic.ulf" "$HOME/Library/Application Support/Unity/Unity_lic.ulf"; do
  [ -f "$f" ] && ULF="$f" && break
done
if [ -z "$ULF" ]; then
  cat <<'MSG'
✗ No Unity_lic.ulf license file found yet. Create it once (free Personal license):
  1. Open Unity Hub → click your profile icon → Manage licenses
  2. Click "Add" → "Get a free personal license" → Agree
  3. Run this script again.
MSG
  exit 1
fi
echo "Found license: $ULF"
read -rp  "Unity account email: " EMAIL
read -rsp "Unity account password (hidden): " PASS; echo
gh secret set UNITY_LICENSE  -R "$REPO" < "$ULF" >/dev/null && echo "set: UNITY_LICENSE"
printf '%s' "$EMAIL" | gh secret set UNITY_EMAIL    -R "$REPO" >/dev/null && echo "set: UNITY_EMAIL"
printf '%s' "$PASS"  | gh secret set UNITY_PASSWORD -R "$REPO" >/dev/null && echo "set: UNITY_PASSWORD"
unset PASS
gh workflow run ci.yml -R "$REPO" >/dev/null && echo "▶ Unity CI started: https://github.com/$REPO/actions"
