# 架构文档

## 📐 整体架构

### 系统架构图

```
┌─────────────────────────────────────────────────────────┐
│                    用户交互层                             │
│  Web / 微信 / Telegram / Discord / QQ / 飞书 / 钉钉      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  OpenClaw 平台                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  AI Agent (Claude/GPT/Gemini)                    │   │
│  │  - 理解用户意图                                   │   │
│  │  - 读取 SKILL.md 指令                            │   │
│  │  - 调用工具执行任务                               │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  工具集 (Tools)                                   │   │
│  │  - exec: 执行 shell 命令                         │   │
│  │  - read/write: 文件操作                          │   │
│  │  - feishu_doc: 飞书文档                          │   │
│  │  - feishu_wiki: 飞书知识库                       │   │
│  │  - feishu_bitable: 飞书多维表格                  │   │
│  │  - web_search: 网页搜索                          │   │
│  │  - tts: 文本转语音                               │   │
│  └──────────────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│              English Tutor Skill                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │  SKILL.md (AI 指令手册)                          │   │
│  │  - 如何引导用户                                   │   │
│  │  - 如何教音标                                     │   │
│  │  - 如何管理词汇                                   │   │
│  │  - 如何使用 SRS 算法                             │   │
│  │  - 如何推荐学习资源                               │   │
│  │  - 如何同步飞书                                   │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  data/ (静态学习资源)                            │   │
│  │  - phonics.json: 48个国际音标                    │   │
│  │  - vocabulary/: 词汇库                           │   │
│  │  - grammar/: 语法库                              │   │
│  │  - materials/: 学习材料                          │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  scripts/ (辅助脚本)                             │   │
│  │  - srs.sh: SRS 算法计算                          │   │
│  │  - search-resources.sh: 资源搜索                 │   │
│  └──────────────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  飞书知识库                              │
│  ┌──────────────────────────────────────────────────┐   │
│  │  📁 英语学习                                      │   │
│  │    ├── 📄 学习档案                                │   │
│  │    ├── 📊 个人词汇库 (多维表格)                   │   │
│  │    ├── 📝 每日学习日志/                           │   │
│  │    ├── 📈 学习进度报告/                           │   │
│  │    ├── 🎯 学习计划                                │   │
│  │    └── 📚 学习资源                                │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 🔄 数据流

### 1. 用户学习流程

```
用户输入 "学习音标"
    ↓
OpenClaw 接收消息
    ↓
AI Agent 读取 SKILL.md
    ↓
理解意图：用户想学习音标
    ↓
执行指令：
  1. 读取 data/phonics.json
  2. 从飞书获取学习进度
  3. 选择下一个音标
  4. 展示给用户
  5. 使用 TTS 播放发音
  6. 记录学习进度到飞书
    ↓
返回结果给用户
```

### 2. SRS 复习流程

```
用户输入 "复习单词"
    ↓
AI 从飞书读取词汇库
    ↓
筛选今天需要复习的词
  (next_review <= today)
    ↓
展示词汇给用户
    ↓
用户回答（记得/不记得）
    ↓
调用 scripts/srs.sh 计算新的复习时间
    ↓
更新飞书词汇库
  - interval
  - ease_factor
  - next_review
    ↓
继续下一个词
```

### 3. 资源推荐流程

```
用户输入 "推荐口语视频"
    ↓
AI 解析意图：
  - 类型：video
  - 主题：speaking
  - 水平：从飞书读取用户水平
    ↓
调用 scripts/search-resources.sh
    ↓
返回推荐资源列表：
  - 预设推荐（YouTube频道、播客）
  - 搜索查询（用于 web_search）
    ↓
AI 格式化展示给用户
    ↓
保存到飞书"学习资源"文档
```

---

## 📁 文件结构

```
english-tutor/
├── SKILL.md                    # AI 指令手册（核心）
├── README.md                   # 项目说明
├── SETUP.md                    # 安装配置指南
├── USAGE.md                    # 使用文档
├── ARCHITECTURE.md             # 架构文档（本文件）
├── LEARNING_GUIDE.md           # 学习指南
│
├── data/                       # 静态学习资源
│   ├── phonics.json            # 48个国际音标
│   │   ├── vowels              # 元音
│   │   │   ├── monophthongs    # 单元音
│   │   │   └── diphthongs      # 双元音
│   │   ├── consonants          # 辅音
│   │   │   ├── plosives        # 爆破音
│   │   │   ├── fricatives      # 摩擦音
│   │   │   ├── affricates      # 塞擦音
│   │   │   ├── nasals          # 鼻音
│   │   │   └── approximants    # 近音
│   │   ├── learning_order      # 学习顺序
│   │   └── minimal_pairs       # 最小对立对
│   │
│   ├── vocabulary/             # 词汇库
│   │   ├── high-frequency.json # 高频词汇 2000+
│   │   ├── tech-terms.json     # 技术英语词汇
│   │   └── categories.json     # 分类词库
│   │
│   ├── grammar/                # 语法库
│   │   ├── topics.json         # 语法主题
│   │   └── exercises.json      # 练习题
│   │
│   └── materials/              # 学习材料
│       ├── articles.json       # 阅读文章
│       └── audio-urls.json     # 音频资源
│
├── scripts/                    # 辅助脚本
│   ├── srs.sh                  # SRS 算法计算
│   └── search-resources.sh     # 学习资源搜索
│
├── templates/                  # 飞书文档模板
│   ├── profile.json            # 学习档案模板
│   ├── daily-log.md            # 每日日志模板
│   └── weekly-report.md        # 周报模板
│
└── examples/                   # 使用示例
    ├── conversation.md         # 对话示例
    └── commands.md             # 命令参考
```

---

## 🧩 核心组件

### 1. SKILL.md

**作用**：AI 的"教学大纲"

**内容**：
- 引导流程指令
- 各功能模块的实现逻辑
- 工具调用方式
- 数据存储规范
- 用户交互模式

**示例**：
```markdown
## 学习音标

当用户说"学习音标"时：

1. 读取音标数据：
   ```bash
   cat ~/.openclaw/workspace/skills/english-tutor/data/phonics.json
   ```

2. 从飞书获取进度：
   使用 feishu_doc 读取"学习档案"

3. 选择下一个音标

4. 展示给用户

5. 记录进度到飞书
```

### 2. data/phonics.json

**作用**：音标学习资源

**数据结构**：
```json
{
  "vowels": {
    "monophthongs": [
      {
        "symbol": "/iː/",
        "description": "长元音，嘴唇扁平",
        "examples": ["see", "tea"],
        "chinese_similar": "类似'衣'",
        "tips": "保持嘴型不变"
      }
    ]
  },
  "learning_order": [...],
  "minimal_pairs": [...]
}
```

### 3. data/vocabulary/

**作用**：词汇库

**数据结构**：
```json
{
  "words": [
    {
      "word": "hello",
      "phonetic": "/həˈləʊ/",
      "pos": "interjection",
      "meaning": "你好",
      "examples": ["Hello, how are you?"],
      "frequency": 1,
      "level": "beginner"
    }
  ]
}
```

### 4. scripts/srs.sh

**作用**：SRS 算法计算

**输入**：
```json
{
  "interval": 1,
  "ease_factor": 2.5,
  "repetitions": 0
}
```

**输出**：
```json
{
  "interval": 6,
  "ease_factor": 2.6,
  "repetitions": 1,
  "next_review": "2026-03-10"
}
```

**算法**：SuperMemo SM-2

### 5. scripts/search-resources.sh

**作用**：搜索学习资源

**输入**：
```bash
./search-resources.sh intermediate video speaking
```

**输出**：
```json
{
  "level": "intermediate",
  "type": "video",
  "topic": "speaking",
  "recommended": [
    {
      "title": "English with Lucy",
      "url": "https://...",
      "type": "video",
      "level": "beginner-intermediate",
      "description": "...",
      "duration": "10-20 min"
    }
  ]
}
```

---

## 🔗 飞书集成

### 数据存储结构

```
📁 英语学习 (Wiki Space)
  │
  ├── 📄 学习档案 (Doc)
  │   ├── 基本信息
  │   │   ├── 姓名
  │   │   ├── 学习目标
  │   │   ├── 当前水平
  │   │   └── 开始日期
  │   ├── 学习计划
  │   │   ├── 每日时间
  │   │   ├── 学习时段
  │   │   └── 学习风格
  │   └── 学习进度
  │       ├── 已学音标列表
  │       ├── 词汇量
  │       └── 完成课程数
  │
  ├── 📊 个人词汇库 (Bitable)
  │   ├── 字段：
  │   │   ├── 单词 (Text)
  │   │   ├── 音标 (Text)
  │   │   ├── 词性 (Select)
  │   │   ├── 释义 (Text)
  │   │   ├── 例句 (Text)
  │   │   ├── 学习日期 (Date)
  │   │   ├── 复习次数 (Number)
  │   │   ├── 难度系数 (Number)
  │   │   ├── 间隔天数 (Number)
  │   │   ├── 下次复习 (Date)
  │   │   └── 掌握程度 (Select: 生疏/熟悉/熟练)
  │   └── 视图：
  │       ├── 全部词汇
  │       ├── 今日复习
  │       ├── 最近学习
  │       └── 按掌握程度
  │
  ├── 📝 每日学习日志/ (Folder)
  │   ├── 2026-03-04.md
  │   │   ├── 学习时长
  │   │   ├── 完成任务
  │   │   ├── 新学内容
  │   │   ├── 复习内容
  │   │   └── 学习心得
  │   ├── 2026-03-05.md
  │   └── ...
  │
  ├── 📈 学习进度报告/ (Folder)
  │   ├── 第1周.md
  │   │   ├── 学习数据统计
  │   │   ├── 能力提升分析
  │   │   ├── 本周亮点
  │   │   ├── 需要加强
  │   │   └── 下周计划
  │   ├── 第2周.md
  │   └── ...
  │
  ├── 🎯 学习计划 (Doc)
  │   ├── 总体目标
  │   ├── 阶段划分
  │   ├── 每日任务模板
  │   └── 里程碑设定
  │
  └── 📚 学习资源 (Doc)
      ├── 视频资源
      ├── 播客资源
      ├── 文章资源
      └── 工具推荐
```

### API 调用

**创建文档**：
```javascript
feishu_doc(
  action: "create",
  title: "学习档案",
  content: "..."
)
```

**创建多维表格**：
```javascript
feishu_bitable_create_app(
  name: "个人词汇库"
)
```

**添加词汇**：
```javascript
feishu_bitable_create_record(
  app_token: "...",
  table_id: "...",
  fields: {
    "单词": "hello",
    "音标": "/həˈləʊ/",
    "释义": "你好",
    ...
  }
)
```

**更新复习数据**：
```javascript
feishu_bitable_update_record(
  app_token: "...",
  table_id: "...",
  record_id: "...",
  fields: {
    "复习次数": 3,
    "下次复习": "2026-03-10",
    ...
  }
)
```

---

## 🔧 扩展性

### 添加新功能

1. **更新 SKILL.md**
   - 添加新功能的指令
   - 定义数据流
   - 说明工具调用

2. **添加数据文件**（如需要）
   - 在 `data/` 目录添加 JSON 文件

3. **添加脚本**（如需要）
   - 在 `scripts/` 目录添加 shell/python 脚本

4. **更新文档**
   - USAGE.md：添加使用说明
   - README.md：更新功能列表

### 添加新的学习资源

1. **词汇库扩充**
   ```bash
   # 编辑 data/vocabulary/high-frequency.json
   # 添加新词条
   ```

2. **语法主题**
   ```bash
   # 编辑 data/grammar/topics.json
   # 添加新语法点
   ```

3. **学习材料**
   ```bash
   # 编辑 data/materials/articles.json
   # 添加新文章
   ```

### 集成新的第三方服务

1. **词典 API**
   - 在 SKILL.md 中添加 API 调用指令
   - 配置 API Key

2. **语音识别**
   - 添加 Python 脚本
   - 集成语音识别库

3. **其他知识库**
   - 参考飞书集成方式
   - 添加对应的同步逻辑

---

## 🚀 性能优化

### 1. 数据缓存

- 静态数据（音标、词汇库）本地缓存
- 减少飞书 API 调用频率

### 2. 批量操作

- 批量读取词汇
- 批量更新复习数据

### 3. 异步处理

- 飞书同步异步进行
- 不阻塞用户交互

---

## 🔒 安全性

### 1. 数据隐私

- 所有数据存储在用户自己的飞书空间
- 不上传到第三方服务器

### 2. API 安全

- 飞书 API Key 加密存储
- 不在日志中暴露敏感信息

### 3. 输入验证

- 验证用户输入
- 防止注入攻击

---

## 📊 监控与日志

### 1. 学习数据统计

- 每日学习时长
- 词汇量增长
- 复习完成率

### 2. 错误日志

- API 调用失败
- 脚本执行错误
- 用户反馈问题

---

## 🔮 未来规划

### 短期（1-2个月）

- [ ] 语音识别集成
- [ ] 发音评分功能
- [ ] AI 生成练习题
- [ ] 学习曲线可视化

### 中期（3-6个月）

- [ ] 多用户支持
- [ ] 学习小组功能
- [ ] 成就系统
- [ ] 游戏化学习

### 长期（6个月+）

- [ ] 移动端 App
- [ ] 离线模式
- [ ] 社区功能
- [ ] 内容市场

---

## 📚 参考资料

- [OpenClaw 文档](https://docs.openclaw.ai)
- [飞书开放平台](https://open.feishu.cn/document)
- [SuperMemo SM-2 算法](https://www.supermemo.com/en/archives1990-2015/english/ol/sm2)
- [国际音标 (IPA)](https://www.internationalphoneticassociation.org/)

---

**下一步**：阅读 [学习指南](LEARNING_GUIDE.md) 了解如何高效学习英语
