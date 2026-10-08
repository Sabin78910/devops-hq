# DevOps HQ

A single overseer that watches every app repo from GitHub's cloud. It runs **24/7 without your laptop** and uses **zero Claude tokens**.

**Live status:** [status.md](status.md), refreshed every 6 hours.

| Layer | What | Where | Cost |
|---|---|---|---|
| 1. Always-on | CI, CodeQL, Dependabot, deploys in each repo; `watch.yml` every 6h; `weekly-audit.yml` on Sundays | GitHub Actions | free |
| 2. Scheduled Claude | `agent/run.sh` implements one `ready` issue per run and opens a **draft PR** | your Mac (launchd) | your Claude Pro allowance |
| 3. You | review and merge PRs, Play Console forms, testers | | |

## Alerts
When a repo turns red (failed CI, open security alerts), the watcher opens or updates an **`alert` issue** here, and GitHub emails you about it. Telegram alerts are optional: add the `TG_TOKEN` and `TG_CHAT` secrets.

To also see Dependabot and code-scanning alert counts, add a **read-only fine-grained PAT** as the secret `ORG_READ_TOKEN`.

## Scheduled agent (off by default)
```bash
./agent/enable.sh blockdrop-puzzle-unity   # focus repo; runs at 07:00 13:00 19:00 01:00
./agent/disable.sh
tail -f ~/agent/agent.log
```
The Mac must be awake for runs to happen (keep it on power, or schedule a wake with `sudo pmset repeat wakeorpoweron MTWRFSU 06:55:00`). The agent only picks up issues labeled `ready` and only opens **draft** PRs, which you review and merge.
