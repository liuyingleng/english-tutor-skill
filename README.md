# English Tutor Skill - Development Guide

## 项目概述

这是一个完整的英语学习智能体系统，设计用于从零基础到流利的全程陪伴。

**核心特性**:
- 个性化引导和水平评估
- 系统化学习路径（音标→词汇→语法→听说读写）
- 科学复习机制（SRS间隔重复算法）
- 进度追踪和数据分析
- 知识库集成（飞书/Notion/Obsidian）
- 智能提醒系统

## 技术栈

**当前版本（OpenClaw Skill）**:
- Node.js 脚本
- JSON 数据存储
- Markdown 模板
- OpenClaw 工具集成

**未来版本（Java 独立应用）**:
- 后端：Spring Boot + MyBatis/JPA
- 前端：React/Vue + TypeScript
- 数据库：PostgreSQL/MySQL
- 缓存：Redis
- 部署：Docker + 腾讯云轻量服务器

## 目录结构

```
english-tutor/
├── SKILL.md                    # Skill 文档（用户手册）
├── README.md                   # 开发文档（本文件）
├── scripts/                    # 核心脚本
│   ├── onboarding.js           # ✅ 引导流程
│   ├── assessment.js           # TODO: 水平测试
│   ├── plan-generator.js       # TODO: 学习计划生成
│   ├── phonics-trainer.js      # TODO: 音标训练
│   ├── vocabulary-manager.js   # TODO: 词汇管理
│   ├── grammar-coach.js        # TODO: 语法教练
│   ├── listening-practice.js   # TODO: 听力练习
│   ├── speaking-partner.js     # TODO: 口语对话
│   ├── reading-guide.js        # TODO: 阅读指导
│   ├── writing-tutor.js        # TODO: 写作批改
│   ├── srs-engine.js           # TODO: SRS算法引擎
│   ├── progress-tracker.js     # TODO: 进度追踪
│   └── feishu-sync.js          # TODO: 飞书同步
├── data/                       # 数据文件
│   ├── phonics.json            # ✅ 音标数据（48个国际音标）
│   ├── vocabulary/
│   │   ├── high-frequency.json # ✅ 高频词库（前25词示例）
│   │   ├── tech-terms.json     # ✅ 技术词汇
│   │   └── categories.json     # TODO: 分类词库
│   ├── grammar/
│   │   ├── topics.json         # TODO: 语法点
│   │   └── exercises.json      # TODO: 练习题
│   ├── materials/
│   │   ├── articles.json       # TODO: 文章库
│   │   └── audio.json          # TODO: 音频资源
│   └── templates/
│       ├── daily-plan.md       # ✅ 每日计划模板
│       └── weekly-report.md    # ✅ 周报模板
├── assets/
│   └── phonics-chart.png       # TODO: 音标表图片
└── tests/                      # TODO: 测试文件
    └── ...
```

## 数据存储

学习数据存储在用户的 workspace：

```
~/.openclaw/workspace/memory/english-learning/
├── profile.json              # 学习者档案
├── vocabulary/
│   ├── words.json            # 所有学过的词
│   └── srs-schedule.json     # SRS复习计划
├── phonics/
│   └── progress.json         # 音标学习进度
├── grammar/
│   └── progress.json         # 语法进度
├── daily-logs/
│   └── YYYY-MM-DD.md         # 每日学习日志
├── progress/
│   └── stats.json            # 统计数据
└── feishu-sync/
    └── config.json           # 飞书同步配置
```

## 核心算法

### 1. SRS（间隔重复系统）

基于 SuperMemo SM-2 算法的改进版本：

```javascript
function calculateNextReview(item, quality) {
  // quality: 0-5 (0=完全忘记, 5=完美记住)
  
  if (quality < 3) {
    // 忘记了，重置间隔
    item.interval = 1;
    item.repetitions = 0;
  } else {
    if (item.repetitions === 0) {
      item.interval = 1;
    } else if (item.repetitions === 1) {
      item.interval = 6;
    } else {
      item.interval = Math.round(item.interval * item.easeFactor);
    }
    item.repetitions++;
  }
  
  // 调整难度系数
  item.easeFactor = Math.max(1.3, 
    item.easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
  );
  
  item.nextReview = new Date(Date.now() + item.interval * 24 * 60 * 60 * 1000);
  
  return item;
}
```

### 2. 难度自适应

根据用户表现动态调整：

```javascript
function adjustDifficulty(userStats) {
  const accuracy = userStats.correct / userStats.total;
  
  if (accuracy > 0.8) {
    return 'increase'; // 提升难度
  } else if (accuracy < 0.6) {
    return 'decrease'; // 降低难度
  } else {
    return 'maintain'; // 保持当前难度
  }
}
```

### 3. 学习计划生成

基于用户水平和时间分配：

```javascript
function generateDailyPlan(profile, date) {
  const { currentLevel, dailyTimeMinutes } = profile;
  
  // 时间分配比例
  const allocation = {
    'absolute_beginner': {
      phonics: 0.3,
      vocabulary: 0.3,
      grammar: 0.2,
      listening: 0.2
    },
    // ... 其他等级
  };
  
  // 生成具体任务
  const tasks = {
    phonics: generatePhonicsTasks(level, time),
    vocabulary: generateVocabTasks(level, time),
    // ...
  };
  
  return tasks;
}
```

## API 设计（为 Java 应用准备）

### RESTful Endpoints

```
# 用户管理
POST   /api/users/register          # 注册
POST   /api/users/login             # 登录
GET    /api/users/profile           # 获取档案
PUT    /api/users/profile           # 更新档案

# 引导流程
POST   /api/onboarding/start        # 开始引导
POST   /api/onboarding/assessment   # 提交评估
POST   /api/onboarding/complete     # 完成引导

# 学习计划
GET    /api/plan/daily              # 获取每日计划
GET    /api/plan/weekly             # 获取周计划
POST   /api/plan/adjust             # 调整计划

# 词汇学习
GET    /api/vocabulary/new          # 获取新词
GET    /api/vocabulary/review       # 获取复习词
POST   /api/vocabulary/learn        # 记录学习
POST   /api/vocabulary/test         # 提交测试

# 音标训练
GET    /api/phonics/list            # 音标列表
GET    /api/phonics/learn/:symbol   # 学习音标
POST   /api/phonics/practice        # 练习记录

# 语法学习
GET    /api/grammar/topics          # 语法主题
GET    /api/grammar/exercises       # 练习题
POST   /api/grammar/submit          # 提交答案

# 听力训练
GET    /api/listening/materials     # 听力材料
POST   /api/listening/complete      # 完成记录

# 口语练习
POST   /api/speaking/session        # 开始对话
POST   /api/speaking/evaluate       # 评估发音

# 阅读训练
GET    /api/reading/articles        # 文章列表
POST   /api/reading/complete        # 完成记录

# 写作批改
POST   /api/writing/submit          # 提交作文
GET    /api/writing/feedback/:id    # 获取反馈

# 进度追踪
GET    /api/progress/stats          # 统计数据
GET    /api/progress/history        # 历史记录
GET    /api/progress/milestones     # 里程碑

# 数据同步
POST   /api/sync/feishu             # 同步到飞书
GET    /api/sync/export             # 导出数据
```

### 数据模型

```java
// User Profile
class UserProfile {
    Long id;
    String name;
    String email;
    LocalDate startDate;
    List<String> goals;
    String currentLevel;
    Integer dailyTimeMinutes;
    List<String> preferredTimes;
    String learningStyle;
    List<String> interests;
    Map<String, Object> customSettings;
}

// Vocabulary Item
class VocabularyItem {
    Long id;
    String word;
    String phonetic;
    String pos;
    String meaning;
    List<String> examples;
    Integer frequency;
    String level;
    LocalDateTime learnedAt;
    Integer reviewCount;
    Double easeFactor;
    Integer interval;
    LocalDateTime nextReview;
}

// Learning Session
class LearningSession {
    Long id;
    Long userId;
    LocalDate date;
    String type; // phonics, vocabulary, grammar, etc.
    Integer durationMinutes;
    Map<String, Object> content;
    Map<String, Object> results;
    LocalDateTime createdAt;
}

// Progress Stats
class ProgressStats {
    Long userId;
    Integer totalStudyDays;
    Integer totalStudyMinutes;
    Integer vocabularySize;
    Integer lessonsCompleted;
    Map<String, Integer> skillLevels;
    LocalDateTime lastUpdated;
}
```

## 开发路线图

### Phase 1: 核心功能（当前）✅

- [x] 项目结构搭建
- [x] 引导流程脚本
- [x] 音标数据准备
- [x] 词汇数据准备（示例）
- [x] 模板文件

### Phase 2: 基础模块（本周）

- [ ] 音标训练模块
- [ ] 词汇学习模块
- [ ] SRS 复习引擎
- [ ] 进度追踪系统
- [ ] 飞书同步功能

### Phase 3: 扩展功能（本月）

- [ ] 语法练习模块
- [ ] 听力训练模块
- [ ] 口语对话模块
- [ ] 阅读训练模块
- [ ] 写作批改模块
- [ ] 智能提醒系统

### Phase 4: 优化与测试

- [ ] 性能优化
- [ ] 单元测试
- [ ] 集成测试
- [ ] 用户测试
- [ ] Bug 修复

### Phase 5: Java 应用开发

- [ ] Spring Boot 后端
- [ ] RESTful API
- [ ] 数据库设计
- [ ] 前端开发
- [ ] 部署上线

## 如何贡献

### 开发环境设置

```bash
# 克隆项目
cd ~/.openclaw/workspace/skills/english-tutor

# 安装依赖（如果需要）
npm install

# 运行测试
npm test
```

### 添加新功能

1. 在 `scripts/` 目录创建新模块
2. 在 `data/` 目录添加必要数据
3. 更新 `SKILL.md` 文档
4. 编写测试用例
5. 提交 PR

### 代码规范

- 使用 ES6+ 语法
- 函数命名：驼峰式（camelCase）
- 类命名：帕斯卡式（PascalCase）
- 常量命名：全大写下划线（UPPER_SNAKE_CASE）
- 注释：JSDoc 格式

## 测试

```bash
# 运行所有测试
npm test

# 运行特定测试
npm test -- onboarding

# 生成覆盖率报告
npm run coverage
```

## 部署

### OpenClaw Skill 部署

```bash
# 复制到 skills 目录
cp -r english-tutor ~/.openclaw/workspace/skills/

# 重启 OpenClaw
openclaw gateway restart
```

### Java 应用部署（未来）

```bash
# 构建 Docker 镜像
docker build -t english-tutor:latest .

# 推送到服务器
docker push your-registry/english-tutor:latest

# 在服务器上运行
docker-compose up -d
```

## 常见问题

### Q: 如何重置学习进度？

```bash
rm -rf ~/.openclaw/workspace/memory/english-learning/
```

### Q: 如何备份学习数据？

```bash
tar -czf english-learning-backup.tar.gz \
  ~/.openclaw/workspace/memory/english-learning/
```

### Q: 如何导出数据到 Java 应用？

数据已经是标准 JSON 格式，可以直接导入数据库。

## 许可证

MIT License

## 联系方式

- GitHub: [待创建]
- Issues: [待创建]
- Email: [你的邮箱]

---

**开始开发**: 从 `scripts/phonics-trainer.js` 开始实现第一个功能模块！
