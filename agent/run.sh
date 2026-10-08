#!/usr/bin/env bash
# Picks the oldest `ready` issue in ONE repo, lets Claude implement it, opens a DRAFT PR.
# Called by launchd (see com.sabin.claude-agent.plist). One app per run, no overlap.
set -uo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
OWNER="Sabin78910"
REPO_NAME="${1:-$(cat "$HOME/agent/focus-repo" 2>/dev/null || echo blockdrop-puzzle-unity)}"
APP_DIR="$HOME/Desktop/my_10_Apps/$REPO_NAME"
REPO="$OWNER/$REPO_NAME"
STATE="$HOME/agent"; mkdir -p "$STATE"
COOL="$STATE/cooldown"; LOG="$STATE/agent.log"

# skip for 5h after a usage-limit hit
if [ -f "$COOL" ] && [ $(( $(date +%s) - $(stat -f %m "$COOL") )) -lt 18000 ]; then exit 0; fi
# no overlapping runs
/usr/bin/shlock -f "$STATE/lock.pid" -p $$ || exit 0
trap 'rm -f "$STATE/lock.pid"' EXIT

cd "$APP_DIR" || exit 1
git checkout main -q && git pull --ff-only -q || exit 1
ISSUE=$(gh issue list -R "$REPO" --label ready -L 1 --json number,title --jq '.[0] // empty')
[ -z "$ISSUE" ] && exit 0
N=$(jq -r .number <<<"$ISSUE"); T=$(jq -r .title <<<"$ISSUE"); B="agent/issue-$N"
echo "$(date) $REPO #$N $T" >> "$LOG"
gh issue edit "$N" -R "$REPO" --remove-label ready --add-label in-progress
git checkout -b "$B"

OUT=$(caffeinate -s claude -p "Implement GitHub issue #$N: $T. Read CLAUDE.md first. Write tests, run them and lint, stop when green." \
  --permission-mode acceptEdits --allowedTools "Read,Write,Edit,Bash" --max-turns 40 2>&1); RC=$?
echo "$OUT" >> "$LOG"
echo "$OUT" | grep -qiE 'usage limit|rate limit' && touch "$COOL"

if [ $RC -eq 0 ] && [ -n "$(git status --porcelain)" ]; then
  git add -A && git commit -qm "Implement #$N: $T"
  git push -q origin "$B" && gh pr create -R "$REPO" --draft --title "#$N: $T" --body "Closes #$N — agent-generated, needs human review."
else
  gh issue edit "$N" -R "$REPO" --remove-label in-progress --add-label needs-human
fi
git checkout main -q
