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

## 人事部线程读取路由

1. 创建/接管/交接线程：总控 → 线程管理 → Memory 与资料管理 → 任务状态；建立资料包版本、已读证明、冲突和阻断记录。
2. 派发任务：读取需求与任务体系、任务发出和任务状态；只在需求与审计线程已有正式任务后协调派发，先核验接收线程状态和同模块并行冲突。
3. 跟踪审计与交付：读取审计与测试总线及状态节点；只记录事实、证据和交接条件，不替需求审计线程作技术或放行结论。
4. 资料变更：资料包动态变化时重新读取受影响节点；若 RAG 未配置、正文缺失、快照变化或资料与项目不一致，明确标为缺口/冲突。

