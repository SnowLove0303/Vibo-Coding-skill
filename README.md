# Vibo-Coding-skill

Codex global skills maintained for Vibo-style software delivery, audit, development governance, thread coordination, and user-intervention workflows.

## Skills

| Skill | Purpose |
| --- | --- |
| `requirements-audit-thread` | Requirement shaping, audit planning, manual test design, issue remediation, and delivery judgment. |
| `development-thread` | Technical execution workflow for implementation, debugging, validation, packaging, and handoff. |
| `hr-thread` | Thread coordination, task dispatch, handoff, state tracking, and cross-thread anti-ping-pong rules. |
| `project-knowledge-pack` | Project knowledge package, fact baseline, change records, reusable resources, and thread context bundles. |
| `audit-level-1-code-architecture` | Code architecture, module boundaries, simplicity, performance, and regression-risk audit. |
| `audit-level-2-business-interaction` | User-level business interaction, real status, live feedback, old-function preservation, and delivery closure audit. |
| `audit-level-3-agentic-realpath-test` | Real-path functional value testing and agentic end-to-end verification. |
| `audit-level-4-final-governance` | Final governance review across requirements, execution logs, audit results, release risk, and rollback. |
| `raeve-development-governance` | RAEVE five-domain governance for software, automation, UI, API, database, packaging, and release tasks. |
| `user-intervention-gateway` | Reusable authorization/input gateway for tasks that require user approval or real user-provided information. |

## Maintenance Rules

- Each skill lives in its own folder.
- Keep each skill's `SKILL.md`, `agents/`, `scripts/`, `references/`, and other required resources inside that skill folder.
- Do not store tokens, cookies, credentials, local auth files, or private user data in this repository.
- Validate changed skills with `quick_validate.py` before pushing.
- When global memory rules change, update the relevant skill folders in the same maintenance pass.
