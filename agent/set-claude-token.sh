#!/usr/bin/env bash
# Stores your Claude subscription token as CLAUDE_CODE_OAUTH_TOKEN in every repo.
# 1) run:  claude setup-token     (copy the whole token — it may wrap over 2 lines)
# 2) run:  this script, paste the token, then press Enter on an EMPTY line to finish.
set -euo pipefail
echo "Paste the token (wrapped lines are fine), then press Enter on an empty line:"
TOKEN=""
while IFS= read -rs LINE; do [ -z "$LINE" ] && break; TOKEN+="$LINE"; done
TOKEN=$(printf '%s' "$TOKEN" | tr -d '[:space:]')
if [[ "$TOKEN" != sk-ant-oat* ]] || [ ${#TOKEN} -lt 90 ]; then
  echo "That doesn't look like a full token (should start with sk-ant-oat and be ~100+ chars; got ${#TOKEN})."
  echo "Run 'claude setup-token' again and copy all of it."; exit 1
fi
echo "Token looks valid (${#TOKEN} chars). Saving..."
while read -r R; do
  [ -z "$R" ] && continue
  printf '%s' "$TOKEN" | gh secret set CLAUDE_CODE_OAUTH_TOKEN -R "Sabin78910/$R" >/dev/null && echo "set: $R"
done < "$(dirname "$0")/../repos.txt"
printf '%s' "$TOKEN" | gh secret set CLAUDE_CODE_OAUTH_TOKEN -R Sabin78910/devops-hq >/dev/null && echo "set: devops-hq"
unset TOKEN
echo "Done. Re-add the 'ready' label to any issue to start the agent."
