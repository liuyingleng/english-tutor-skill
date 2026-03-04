# English Tutor - 英语学习助手

**基于 OpenClaw + 飞书知识库的智能英语教练**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🎯 项目简介

这是一个 OpenClaw Skill，通过 AI Agent + 飞书知识库的方式，提供个性化的英语学习体验。

**核心特点**：
- 🤖 **AI 驱动**：基于大语言模型，智能对话式教学
- 📱 **多平台支持**：Web、微信、Telegram、Discord、QQ 等任何接入 OpenClaw 的平台
- ☁️ **云端同步**：所有数据存储在飞书知识库，多端实时同步
- 🎓 **系统化学习**：音标、词汇、语法、听说读写全方位训练
- 🔄 **科学复习**：SRS 间隔重复算法，高效记忆
- 📊 **进度追踪**：自动生成学习报告，可视化进度

## 🚀 快速开始

### 前置要求

1. **安装 OpenClaw**
   ```bash
   npm install -g openclaw
   ```

2. **配置飞书集成**
   - 在飞书开放平台创建应用
   - 配置 OpenClaw 的飞书 skill
   - 参考：[飞书配置指南](https://docs.openclaw.ai/zh-CN/tools/feishu)

### 安装 Skill

```bash
# 克隆项目到 OpenClaw workspace
cd ~/.openclaw/workspace/skills/
git clone https://github.com/liuyingleng/english-tutor-skill.git english-tutor

# 或者使用 clawhub 安装（未来）
# clawhub install english-tutor
```

### 开始使用

在任何接入 OpenClaw 的平台上，对 AI 说：

```
我想学英语
```

AI 会引导你完成初始设置，然后开始学习！

## 📚 功能特性

### 1. 个性化引导
- 评估当前水平
- 了解学习目标
- 制定学习计划
- 自动创建飞书知识库结构

### 2. 音标训练
- 48个国际音标系统学习
- 发音说明 + 例词 + 中文对比
- TTS 语音示范
- 最小对立对练习

### 3. 词汇学习
- 高频词汇 2000+
- 技术英语专项词汇
- SRS 智能复习
- 词汇量统计

### 4. 语法练习
- 系统化语法主题
- 例句讲解
- 练习题测试

### 5. 听力训练
- 分级听力材料
- 听写练习
- 理解测试

### 6. 口语练习
- 场景对话模拟
- 发音纠正
- 流利度训练

### 7. 阅读训练
- 技术文档阅读
- 新闻文章
- 生词标注

### 8. 写作批改
- 主题写作
- 语法纠错
- 用词建议

### 9. 进度追踪
- 学习天数统计
- 词汇量增长曲线
- 自动生成周报

## 🗂️ 飞书知识库结构

安装后会自动在你的飞书创建以下结构：

```
📁 英语学习
  ├── 📄 学习档案
  │   └── 个人信息、学习目标、当前水平、学习计划
  ├── 📊 个人词汇库（多维表格）
  │   └── 单词、音标、释义、例句、SRS数据
  ├── 📝 每日学习日志/
  │   ├── 2026-03-04.md
  │   ├── 2026-03-05.md
  │   └── ...
  ├── 📈 学习进度报告/
  │   ├── 第1周.md
  │   ├── 第2周.md
  │   └── ...
  └── 🎯 学习计划
      └── 阶段目标、每日任务、里程碑
```

## 💬 使用示例

### 命令式

```
/english start          # 开始今天的学习
/phonics learn          # 学习音标
/vocab new              # 学习新词
/vocab review           # 复习旧词
/grammar today          # 今日语法
/progress               # 查看进度
```

### 对话式

```
用户：教我音标
AI：好的！今天我们学习5个元音音标...

用户：我想学新单词
AI：为你准备了20个高频词汇...

用户：帮我复习一下
AI：你有15个单词需要复习...

用户：今天学什么？
AI：根据你的学习计划，今天的任务是...

用户：我的进度怎么样？
AI：你已经坚持学习7天，词汇量达到150个...
```

## 🛠️ 技术实现

### 架构

```
OpenClaw 平台
    ↓
English Tutor Skill (SKILL.md)
    ↓
飞书 API (feishu-doc, feishu-wiki, feishu-bitable)
    ↓
飞书知识库（数据存储）
```

### 核心组件

- **SKILL.md**：AI 指令手册，定义如何教英语
- **data/**：静态学习资源（音标、词汇、语法）
- **scripts/**：辅助脚本（SRS算法、飞书同步）
- **templates/**：飞书文档模板

### SRS 算法

使用 SuperMemo SM-2 算法：

```bash
# 计算下次复习时间
./scripts/srs.sh '{"interval":1,"ease_factor":2.5,"repetitions":0}' 4

# 输出
{
  "interval": 6,
  "ease_factor": 2.6,
  "repetitions": 1,
  "next_review": "2026-03-10"
}
```

## 🌍 多平台支持

只要接入了 OpenClaw，就能使用：

- ✅ Web 聊天
- ✅ 微信
- ✅ Telegram
- ✅ Discord
- ✅ QQ
- ✅ Slack
- ✅ 飞书
- ✅ 钉钉

所有数据同步到飞书，无缝切换！

## 📖 文档

- [安装配置指南](SETUP.md)
- [使用手册](SKILL.md)
- [开发文档](CONTRIBUTING.md)
- [API 参考](API.md)

## 🤝 贡献

欢迎贡献！

- 提交 Issue 报告问题
- 提交 PR 改进功能
- 分享学习心得
- 完善词汇库和学习材料

## 📝 开发计划

- [x] 基础架构
- [x] 音标训练模块
- [x] 词汇学习模块
- [x] SRS 复习系统
- [ ] 语法练习模块
- [ ] 听力训练模块
- [ ] 口语练习模块
- [ ] 阅读训练模块
- [ ] 写作批改模块
- [ ] 进度可视化
- [ ] 多语言支持

## 📄 许可证

MIT License

## 🙏 致谢

- [OpenClaw](https://openclaw.ai) - AI Agent 平台
- [飞书开放平台](https://open.feishu.cn) - 知识库存储
- SuperMemo - SRS 算法

## 📧 联系方式

- GitHub: [@liuyingleng](https://github.com/liuyingleng)
- Issues: [提交问题](https://github.com/liuyingleng/english-tutor-skill/issues)

---

**开始你的英语学习之旅！** 🚀
