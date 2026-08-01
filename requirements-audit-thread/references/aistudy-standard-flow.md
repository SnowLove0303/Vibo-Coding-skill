# AIstudy 标准化开发流程访问索引

## 连接与读取规则

1. 先读取全局技能 aistudy-mcp-access，以它的当前连接方式和权限模型为准。
2. 本机只读入口：F:\XIANGMU\AIstudy-public\scripts\mcp\call-aistudy-mcp.mjs；应用根目录：F:\XIANGMU\AIstudy-public；运行数据根目录：F:\XIANGMU\AIstudy-public\.runtime。只读时设置 AISTUDY_MCP_ALLOW_EDIT=0。
3. 标准化开发流程课程：courseId=49863edd-0522-4619-97b4-56695cd25ef9；思维导图：mindMapId=mindmap_12be3b7f78da4a2f8cbf88227d747f22。
4. 正式任务先读取课程和当前思维导图，再用 read_node_context 读取目标节点；涉及规范正文、验收或资料维护时用 read_node_document。记录 Ref、读取时间、快照/哈希、是否截断和 RAG 状态。
5. 节点无正文、RAG 未配置、资料过期或资料与源码冲突时如实记录；不得推定为已读、已索引或既定规范。编辑仅在用户明确授权后进行，并使用当前快照写入、回读和格式化。

## 节点分类与内容

| 分类 | 节点与访问 Ref | 内容与使用时机 |
| --- | --- | --- |
| 总控 | 标准化开发流程：aistudy://node/49863edd/e7c762b2?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22 | 正式任务总链路、角色、交付和闭环门槛；所有线程必读。 |
| 协作与知识 | 线程管理：aistudy://node/49863edd/545d1ccc?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；Memory【层级划分与资料管理】：aistudy://node/49863edd/ac05d072?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22 | 线程交接、资料包、状态、全局限制与资料动态更新。若与 Global Memory 冲突，以 Global Memory 为准并记录待同步项。 |
| 需求与任务 | 需求与任务体系：aistudy://node/49863edd/e8c19add?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；需求文档层级：aistudy://node/49863edd/f42f2332?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；任务执行规范：aistudy://node/49863edd/b1914b92?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；任务发出模板与执行限制：aistudy://node/49863edd/7316aa62?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；任务状态、问题与完成判定：aistudy://node/49863edd/2678b787?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22 | 定义要做什么、如何形成正式任务、如何执行、问题如何分级、何时可以交付。 |
| 审计与测试 | 审计与测试体系：aistudy://node/49863edd/99c4f32d?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；一级：52bacf84；二级：38d7c6fc；三级：a61ad9cc；四级：b5cdf8c8（均在同课程/导图） | 代码质量、真实业务流程、真实热试车、全局独立终审；整改后从最早受影响关口重跑。 |

## 需求与审计线程读取路由

1. 形成需求：总控 → 需求与任务全部节点 → 产品/功能资料 → 当前项目事实；需求只定义业务目标、路径、边界、规则和验收。
2. 发出任务：读取任务发出、执行、状态节点，写明本次必须项、禁止项、非本次项、真实路径、风险和验收矩阵，不替技术线程预设代码方案。
3. 审计：审计与测试总线 → 对应一级至四级节点 → 当前源码/Git/运行/数据证据。执行线程自报、旧审计、辅助脚本与聊天摘要均不能替代独立结论。
4. 维护资料：先判断是否用户授权；编辑后回读和格式化，并标识资料与当前 Global Memory 的冲突。

