---
name: user-intervention-gateway
description: Use when a Codex task, test, setup, delivery, authorization, configuration, or verification flow requires the user to either approve/deny an authorization prompt or enter/select real information before the task can continue. Provides a reusable waiting interaction pattern and script so users are not asked to edit long commands, JSON, environment variables, or config files manually.
---

# User Intervention Gateway

## Purpose

Use this skill whenever user intervention is truly required during execution. The only normal intervention types are:

1. Authorization: show a clear allow/deny confirmation and wait for the user.
2. Input: show a clear input/selection prompt and wait for the user.

After the user completes the prompt, immediately continue the task flow. Do not turn user intervention into scattered command editing.

## Required Behavior

1. First solve everything that can be solved automatically: path detection, default value discovery, dependency checks, state checks, result verification, retries, and follow-up execution.
2. If user intervention remains necessary, launch `scripts/UserInterventionGateway.ps1` or an equivalent project-local wrapper.
3. Keep the process waiting until the user approves, denies, cancels, or submits the requested information.
4. Use the returned JSON result to continue immediately.
5. Put technical commands only in developer/audit evidence, not in user-facing artificial test steps.

## Authorization Flow

Use for OAuth, browser/app permission prompts, destructive action confirmation, account selection confirmation, external service authorization, or release/publish confirmation.

Required user-facing fields:

- What is being authorized.
- Why it is needed now.
- What will happen after Allow.
- What will happen after Deny or Cancel.

Command pattern:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\skills\user-intervention-gateway\scripts\UserInterventionGateway.ps1" -Mode Authorize -Title "授权确认" -Message "允许本次任务连接指定服务并继续执行。"
```

## Input Flow

Use for non-sensitive business input, file/path selection, account/resource choice, environment choice, or a user business decision.

Required user-facing fields:

- What the user should enter or choose.
- Accepted format, if any.
- Default value, if safe and useful.
- What happens after submission.
- How Cancel is handled.

Command pattern:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Codex\skills\user-intervention-gateway\scripts\UserInterventionGateway.ps1" -Mode Input -Title "信息输入" -Prompt "请输入本次要使用的资源名称"
```

## Sensitive Inputs

Do not write passwords, tokens, cookies, private keys, or secrets into files, logs, command history, chat summaries, or AGENTS.md. Prefer official login flows, system credential managers, approved connectors, or secure input paths.

If a sensitive value cannot be handled safely, stop and explain the risk, then wait for explicit user confirmation.

## User-Facing Test Rule

When preparing user manual testing, describe only the interaction path:

`入口路径 -> 选择项 -> 输入项 -> 确认项 -> 预期可见结果 -> 异常反馈`

Do not give the user long PowerShell commands, JSON, internal IDs, `taskId`, `moduleId/action`, environment variable edits, or config-file surgery as the manual test path.

## Evidence Rule

Developer/audit evidence may include the exact script command, returned JSON, logs, and validation output. Keep that evidence separate from the user manual testing flow.
