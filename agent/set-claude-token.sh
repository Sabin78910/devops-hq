#!/usr/bin/env bash
# One command: creates a Claude subscription token, verifies it, and saves it as
# CLAUDE_CODE_OAUTH_TOKEN in every repo. No copy/paste needed; the token is never shown again.
#   ./set-claude-token.sh            → runs `claude setup-token` and captures the token automatically
#   ./set-claude-token.sh --clipboard → uses a token you already copied (Cmd+C)
set -euo pipefail
export PATH="/opt/homebrew/bin:$PATH"
umask 077

if [ "${1:-}" = "--clipboard" ]; then
  TOKEN=$(pbpaste | tr -d '[:space:]')
else
  LOG=$(mktemp)
  trap 'rm -f "$LOG"' EXIT
  echo "Opening Claude login (approve in the browser)..."
  script -q "$LOG" claude setup-token >/dev/null
  TOKEN=$(python3 - "$LOG" <<'PY'
import re, sys
t = open(sys.argv[1], errors="ignore").read()
t = re.sub(r"\x1b\[[0-9;?]*[A-Za-z]|\x1b\][^\x07]*\x07|\r", "", t)
i = t.rfind("sk-ant-oat")
if i < 0: sys.exit(0)
seg = t[i:].split("Store this token")[0]
print("".join(re.findall(r"[A-Za-z0-9_\-]", seg)))
PY
)
  rm -f "$LOG"
  clear
fi

if [[ "$TOKEN" != sk-ant-oat* ]] || [ ${#TOKEN} -lt 90 ] || [ ${#TOKEN} -gt 160 ]; then
  echo "✗ Couldn't get a valid token (got ${#TOKEN} chars). Run the script again."; exit 1
fi
echo "Testing token with Claude..."
if OUT=$(env -u ANTHROPIC_API_KEY CLAUDE_CODE_OAUTH_TOKEN="$TOKEN" claude -p "Reply with exactly: TOKEN_OK" --max-turns 1 2>&1) && grep -q TOKEN_OK <<<"$OUT"; then
  echo "✓ Token works."
else
  echo "✗ Token rejected: $(head -c 200 <<<"$OUT")"; exit 1
fi
for R in $(cat "$(dirname "$0")/../repos.txt") devops-hq; do
  printf '%s' "$TOKEN" | gh secret set CLAUDE_CODE_OAUTH_TOKEN -R "Sabin78910/$R" >/dev/null && echo "set: $R"
done
unset TOKEN
[ "${1:-}" = "--clipboard" ] && printf '' | pbcopy
echo "Done. Tell Claude 'done' to restart the agent."
