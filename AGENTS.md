# AGENTS.md

## Purpose

This repository contains Owen-125B.

## Working agreement

- Preserve existing user changes and keep assumptions explicit.
- Do not store secrets, credentials, private keys, or production tokens in Git.
- Use a separate branch or worktree for independent changes.
- Run relevant tests and review the diff before proposing a merge.
- Merge, production deployment, live trading, and irreversible actions require owner approval.
- Use `REQUIREMENTS.md` for scope, `ARCHITECTURE.md` for system boundaries, and `OPEN_QUESTIONS.md` for unresolved owner decisions.
- Store machine-readable owner decisions in `.codex/decisions/` and worker state in `.codex/checkpoints/`.
