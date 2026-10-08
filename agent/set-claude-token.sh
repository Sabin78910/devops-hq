#!/usr/bin/env bash
# Stores your Claude subscription token as CLAUDE_CODE_OAUTH_TOKEN in every repo.
# 1) run:  claude setup-token     (copy the token it prints)
# 2) run:  ./devops-hq/agent/set-claude-token.sh   and paste it (input is hidden)
set -euo pipefail
read -rsp "Paste CLAUDE_CODE_OAUTH_TOKEN: " TOKEN; echo
while read -r R; do
  [ -z "$R" ] && continue
  printf '%s' "$TOKEN" | gh secret set CLAUDE_CODE_OAUTH_TOKEN -R "Sabin78910/$R" && echo "set: $R"
done < "$(dirname "$0")/../repos.txt"
printf '%s' "$TOKEN" | gh secret set CLAUDE_CODE_OAUTH_TOKEN -R Sabin78910/devops-hq && echo "set: devops-hq"
unset TOKEN
