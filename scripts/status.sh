#!/usr/bin/env bash
# Prints a Markdown status table for every repo in repos.txt.
# Needs GH_TOKEN. github.token can read public repos; a read-only fine-grained PAT
# (ORG_READ_TOKEN) also unlocks Dependabot and code-scanning alert counts.
set -uo pipefail
OWNER="${OWNER:-Sabin78910}"
cd "$(dirname "$0")/.."
echo "# Status — $(date -u '+%Y-%m-%d %H:%M UTC')"
echo
echo "| | Repo | Last CI | Stale PRs (>3d) | Ready issues | Dependabot alerts | Code-scanning alerts |"
echo "|---|---|---|---|---|---|---|"
while read -r R; do
  [ -z "$R" ] && continue
  RUN=$(gh run list -R "$OWNER/$R" -b main -L 1 --json conclusion,status --jq '.[0] | (.conclusion // .status) // "none"' 2>/dev/null || echo "n/a")
  PRS=$(gh pr list -R "$OWNER/$R" --json createdAt --jq '[.[] | select((now - (.createdAt|fromdateiso8601)) > 259200)] | length' 2>/dev/null || echo 0)
  ISS=$(gh issue list -R "$OWNER/$R" --label ready --json number --jq length 2>/dev/null || echo 0)
  DEP=$(gh api "repos/$OWNER/$R/dependabot/alerts?state=open&per_page=100" --jq length 2>/dev/null || echo "?")
  CS=$(gh api "repos/$OWNER/$R/code-scanning/alerts?state=open&per_page=100" --jq length 2>/dev/null || echo "?")
  FLAG="🟢"
  [ "$PRS" != "0" ] && FLAG="🟡"
  { [ "$RUN" = "failure" ] || { [ "$DEP" != "?" ] && [ "$DEP" -gt 0 ]; } || { [ "$CS" != "?" ] && [ "$CS" -gt 0 ]; }; } && FLAG="🔴 RED"
  echo "| $FLAG | [$R](https://github.com/$OWNER/$R) | $RUN | $PRS | $ISS | $DEP | $CS |"
done < repos.txt
