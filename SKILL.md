# English Tutor Skill

**私人英语学习智能体 - 从零到流利的完整解决方案**

## 概述

这是一个为零基础学习者设计的全方位英语学习系统，提供：
- 🎯 个性化学习路径（基于引导评估）
- 📚 系统化课程（音标→词汇→语法→听说读写）
- 🔄 科学复习机制（SRS间隔重复）
- 📊 进度追踪与数据分析
- 🔗 知识库集成（飞书/Notion/Obsidian）
- ⏰ 智能提醒与主动推送

## 快速开始

### 首次使用

```
/english setup
```

这会启动引导流程，评估你的水平并生成学习计划。

### 每日学习

```
/english start      # 开始今天的学习
/english continue   # 继续上次的进度
```

## 核心功能

### 1. 引导与评估

- **初始设置**：`/english setup`
- **重新评估**：`/english assess`
- **调整计划**：`/english plan adjust`

### 2. 音标训练

- **学习音标**：`/phonics learn [音标]`
- **随机练习**：`/phonics practice`
- **音标测试**：`/phonics test`
- **发音示范**：`/phonics demo [音标]`

### 3. 词汇学习

- **学习新词**：`/vocab new [数量]`（默认20个）
- **复习旧词**：`/vocab review`（SRS推荐）
- **查词详解**：`/vocab lookup [单词]`
- **词汇测验**：`/vocab quiz`
- **词汇统计**：`/vocab stats`

### 4. 语法练习

- **今日语法**：`/grammar today`
- **语法练习**：`/grammar practice [主题]`
- **语法解释**：`/grammar explain [语法点]`

### 5. 听力训练

- **每日听力**：`/listen daily`
- **听写练习**：`/listen dictation`
- **调整语速**：`/listen speed [slow|normal|fast]`

### 6. 口语对话

- **自由对话**：`/speak chat`
- **场景对话**：`/speak scenario [场景]`
  - 场景：interview, meeting, daily, tech-discussion
- **发音纠正**：`/speak pronounce [词/句]`

### 7. 阅读训练

- **推荐文章**：`/read article`
- **技术文章**：`/read tech`
- **难句解析**：`/read explain [句子]`

### 8. 写作批改

- **写日记**：`/write diary`
- **写博客**：`/write blog`
- **检查文本**：`/write check [文本]`

### 9. 进度管理

- **查看进度**：`/english progress`
- **学习统计**：`/english stats`
- **学习日志**：`/english log [日期]`
- **里程碑**：`/english milestones`

### 10. 知识库同步

- **同步飞书**：`/sync feishu`
- **生成周报**：`/report weekly`
- **导出词汇**：`/export vocabulary`

### 11. 提醒设置

- **设置提醒**：`/remind setup`
- **暂停提醒**：`/remind pause`
- **恢复提醒**：`/remind resume`

## 学习路径

### 阶段一：基础建设（1-3个月）

**第1-2周：音标与发音**
- 48个国际音标
- 发音规则（连读、弱读、重音）
- 最小对立对练习

**第3-8周：词汇与语法**
- 高频词汇2000个
- 基础语法（时态、句型、从句）
- 简单听力材料

### 阶段二：能力提升（3-12个月）

- 阅读：技术文档、新闻文章
- 听力：正常语速材料、不同口音
- 口语：场景对话、技术讨论
- 写作：日记、技术博客

### 阶段三：实战应用（12个月+）

- 参与英文技术社区
- 阅读英文技术书籍
- 英文会议/演讲
- 语言交换

## 数据结构

学习数据存储在 `memory/english-learning/`：

```
memory/english-learning/
├── profile.json              # 学习者档案
├── vocabulary/
│   ├── words.json            # 词库
│   └── srs-schedule.json     # 复习计划
├── phonics/
│   └── progress.json         # 音标进度
├── grammar/
│   └── progress.json         # 语法进度
├── daily-logs/
│   └── YYYY-MM-DD.md         # 每日日志
├── progress/
│   └── stats.json            # 统计数据
└── feishu-sync/
    └── config.json           # 同步配置
```

## 飞书集成

自动创建以下文档结构：

```
📁 英语学习
├── 📖 学习笔记本
│   ├── 音标学习
│   ├── 词汇积累
│   └── 语法总结
├── 📝 每日学习日志
│   └── YYYY-MM-DD
├── 📚 个人词汇库
│   ├── 高频词汇
│   ├── 技术词汇
│   └── 错词本
└── 📊 学习报告
    ├── 周报
    └── 月报
```

## 技术实现

### SRS算法

使用改进的SuperMemo SM-2算法：
- 初始间隔：1天
- 简单：间隔×2.5
- 良好：间隔×1.3
- 困难：间隔×0.5
- 遗忘：重置为1天

### 难度调整

根据正确率动态调整：
- 正确率 > 80%：提升难度
- 正确率 < 60%：降低难度
- 60-80%：保持当前难度

## 开发计划

### v0.1（当前）
- ✅ 引导流程
- ✅ 音标训练
- ✅ 词汇学习（基础）
- ✅ 数据结构

### v0.2（本周）
- [ ] SRS复习系统
- [ ] 语法练习
- [ ] 听力训练
- [ ] 飞书同步

### v0.3（本月）
- [ ] 口语对话
- [ ] 阅读训练
- [ ] 写作批改
- [ ] 智能提醒

### v1.0（未来）
- [ ] 完整功能
- [ ] 性能优化
- [ ] 数据导出API
- [ ] 为Java应用准备接口

## 后续开发

### Java独立应用

这个skill是学习引擎，后续可以开发：

**前端（Web/Mobile）**
- 学习面板
- 进度可视化
- 互动练习界面

**后端（Spring Boot）**
- RESTful API
- 数据持久化（MySQL/PostgreSQL）
- 用户管理
- 更复杂的算法

**部署**
- 腾讯云轻量服务器
- Docker容器化
- CI/CD自动部署

## 贡献

这是你的私人项目，但欢迎：
- 提交issue报告问题
- 提交PR改进功能
- 分享学习心得

## 许可

MIT License - 自由使用、修改、分发

---

**开始你的英语学习之旅：`/english setup`** 🚀
