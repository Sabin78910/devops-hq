#!/usr/bin/env bash
launchctl bootout "gui/$(id -u)/com.sabin.claude-agent" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/com.sabin.claude-agent.plist"
echo "Agent disabled."
