---
name: raeve-development-governance
description: Mandatory RAEVE governance workflow for any software, product, automation, RPA, API, UI, database, packaging, release, refactor, bug-fix, or AI-development task. Use before implementation when Codex is asked to build, modify, optimize, debug, integrate, package, publish, or plan a feature so requirements, boundaries, context, architecture, contracts, verification, release, rollback, documentation, and evolution are governed before execution.
---

# RAEVE Development Governance

## Core Rule

Use this skill before implementing any development-related task. Do not start code changes, data changes, packaging, release, or automation wiring until the RAEVE pass is complete and any unclear or risky point has been confirmed with the user.

For complex, high-risk, cross-module, database, release, RPA, API, or reusable AI-workflow tasks, read `references/raeve-model.md` before deciding the execution plan.

## RAEVE Pass

Before execution, produce a concise numbered pass covering these five domains:

1. 需求与边界：State the user-defined goal, business outcome, allowed scope, forbidden scope, inputs, outputs, acceptance criteria, and unknowns. Do not invent business requirements.
2. 架构与契约：Identify affected modules, existing architecture boundaries, data models, interfaces, event/state contracts, error handling, and integration points. Do not bypass architecture for a local fix.
3. 执行与变更：Choose the smallest viable change, reuse existing capabilities, define rollback points, record expected files/modules, and check whether `main` or core entry files should be split before adding logic.
4. 验证与发布：Define validation by user goal and business flow, not only code success. Include static checks, runtime checks, integration checks, UI checks, data checks, packaging/release checks, and restart/shutdown scenarios as relevant.
5. 演进与文档：Decide what documentation, ADR, contract, status model, release note, issue record, or knowledge-base update is needed so system facts remain in code and docs rather than chat memory.

## Execution Gate

Proceed only when:

- The task objective and acceptance criteria are clear.
- The modification boundary and rollback path are clear.
- Required materials have been read or the missing-material attempts are recorded.
- Data, credential, database, publishing, and destructive-operation risks are identified.
- Verification can be run honestly without mock, fake, or placeholder results unless explicitly requested.

If any gate fails, ask the minimum specific question needed or perform the smallest safe investigation first.

## During Implementation

- Keep implementation aligned with the approved RAEVE pass.
- Treat feedback locations as entry points; inspect the whole module for related issues.
- Record encountered problems with phenomenon, trigger, impact, attempted handling, current status, and fix priority.
- Stop before high-risk database, credential, deletion, migration, publishing, or authorization changes unless the user explicitly confirmed that specific risk.

## Delivery

Report:

- RAEVE scope actually applied.
- Files/modules changed.
- Verification actually performed.
- Remaining risks or blocked checks.
- Rollback path.

Never report completion based only on intent or unverified assumptions.
- 用户级软件式交互同步规则：RAEVE 前置治理必须把用户真实主路径作为需求与验证对象，明确真实入口、可选操作、必要确认、状态、进度、成功结果、失败原因、下一步和回退路径。架构与契约阶段必须区分普通用户入口与 `moduleId`、`action`、`taskId`、manifest、原始 JSON、调试 API、内部命令等开发/审计/诊断入口。验证与交付阶段必须分开报告底层能力是否完成、用户级交互是否完成、开发/审计接口是否完成、普通用户主路径是否完成、哪些入口仅用于调试；底层能力跑通不得替代用户功能完成。
- 完美交付同步规则：RAEVE 规划和交付判断不得使用“至少要有”“暂未实现”“先这样”“后续再补”“基本完成”“局部可用”等弱交付口径作为完成依据。需求与边界必须完整对应当前明确需求；架构与契约必须检查代码简洁、模块分区规范、功能全面、数据链路清楚、性能与稳定性；验证与发布必须确认用户主路径闭环且既有功能不退化。范围内缺口必须继续整改和复测，不能包装成交付。
- 强制架构审计同步规则：RAEVE 的架构与契约、验证与发布阶段必须把代码简洁性、系统防过重、模块拆分程度、主入口/主进程/核心聚合文件复杂度、重复逻辑、临时实现残留、模块边界、可维护性、扩展边界和性能退化列为不可省略检查项。发现代码臃肿、模块混乱、核心入口继续膨胀、启动/运行/打包/内存/依赖/数据库访问退化时，即使业务功能表面可用，也必须作为审计问题进入整改。
