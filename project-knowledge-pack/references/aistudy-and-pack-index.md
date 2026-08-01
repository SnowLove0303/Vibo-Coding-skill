# AIstudy 与项目资料包索引

## AIstudy 标准化开发流程

| 分类 | 节点 Ref | 用途 |
| --- | --- | --- |
| 总控 | aistudy://node/49863edd/e7c762b2?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22 | 标准化开发总链路、真实闭环和交付门槛。 |
| 协作与资料 | aistudy://node/49863edd/545d1ccc?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；aistudy://node/49863edd/ac05d072?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22 | 线程管理、资料包、Memory、交接和资料更新。 |
| 需求与任务 | aistudy://node/49863edd/e8c19add?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；aistudy://node/49863edd/f42f2332?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；aistudy://node/49863edd/b1914b92?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；aistudy://node/49863edd/7316aa62?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；aistudy://node/49863edd/2678b787?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22 | 需求层级、任务形成、执行、状态和完成判定。 |
| 审计与测试 | aistudy://node/49863edd/99c4f32d?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；aistudy://node/49863edd/52bacf84?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；aistudy://node/49863edd/38d7c6fc?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；aistudy://node/49863edd/a61ad9cc?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22；aistudy://node/49863edd/b5cdf8c8?map=mindmap_12be3b7f78da4a2f8cbf88227d747f22 | 一级代码审计、二级业务审计、三级热试车和四级独立终审。 |

## 资料包事实源

1. Global Memory：全局限制；每次线程启动必读，不当作项目可编辑事实。
2. 项目源码、Git、数据库、配置和真实运行：技术事实源；优先级高于历史报告。
3. AIstudy 节点：长期知识与规范事实源；读取时记录 Ref、快照、正文和 RAG 状态。
4. 需求、任务、审计和用户人工测试：业务与质量事实源；必须能追溯到具体任务或证据。
5. manifest.json：当前项目资料索引与核验状态；不是代码、凭据或长篇知识库。
6. changes 目录：事实变化与同步责任；一条变更单只记录一个可定位变化。

## 角色读取路由

人事部：总控 → 协作与资料 → 任务状态 → 当前 manifest 与变更单。

需求与审计：总控 → 需求与任务 → 审计与测试 → 产品/功能资料 → 当前项目事实。

技术开发：总控 → 正式任务 → 任务执行与审计要求 → 当前源码、Git、运行和数据事实。

