#!/usr/bin/env bash
# Turns ON the scheduled Claude agent (7:00, 13:00, 19:00, 01:00). Run `disable.sh` to stop.
set -e
mkdir -p "$HOME/agent"
echo "${1:-blockdrop-puzzle-unity}" > "$HOME/agent/focus-repo"
cp "$(dirname "$0")/com.sabin.claude-agent.plist" "$HOME/Library/LaunchAgents/"
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.sabin.claude-agent.plist"
echo "Agent enabled for $(cat "$HOME/agent/focus-repo"). Log: ~/agent/agent.log"
