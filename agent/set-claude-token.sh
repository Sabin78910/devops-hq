#!/usr/bin/env bash
# Saves your Claude subscription token as CLAUDE_CODE_OAUTH_TOKEN in every repo — only if it WORKS.
# 1) claude setup-token      → select the whole token (starts with sk-ant-oat, may wrap 2 lines) → Cmd+C
# 2) run this script          → it reads the clipboard, tests the token, then saves it everywhere.
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"
TOKEN=$(pbpaste | tr -d '[:space:]')
if [[ "$TOKEN" != sk-ant-oat* ]]; then
  echo "Clipboard doesn't contain a token starting with sk-ant-oat (found ${#TOKEN} chars)."
  echo "Copy the full token from 'claude setup-token' and run again."; exit 1
fi
echo "Testing token (${#TOKEN} chars) with Claude..."
TMPHOME=$(mktemp -d)
if OUT=$(HOME="$TMPHOME" CLAUDE_CODE_OAUTH_TOKEN="$TOKEN" claude -p "Reply with exactly: TOKEN_OK" --max-turns 1 2>&1) && grep -q TOKEN_OK <<<"$OUT"; then
  echo "✓ Token works."
else
  echo "✗ Token rejected: $(head -c 200 <<<"$OUT")"; rm -rf "$TMPHOME"; exit 1
fi
rm -rf "$TMPHOME"
for R in $(cat "$(dirname "$0")/../repos.txt") devops-hq; do
  printf '%s' "$TOKEN" | gh secret set CLAUDE_CODE_OAUTH_TOKEN -R "Sabin78910/$R" >/dev/null && echo "set: $R"
done
unset TOKEN
printf '' | pbcopy
echo "Done (clipboard cleared). Tell Claude 'done' to restart the agent."
