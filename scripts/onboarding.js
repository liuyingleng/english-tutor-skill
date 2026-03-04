#!/usr/bin/env node

/**
 * English Tutor - Onboarding Flow
 * 引导新用户完成初始设置和水平评估
 */

const fs = require('fs');
const path = require('path');

// 数据存储路径
const MEMORY_DIR = path.join(process.env.HOME, '.openclaw/workspace/memory/english-learning');
const PROFILE_PATH = path.join(MEMORY_DIR, 'profile.json');

// 确保目录存在
function ensureDirectories() {
  const dirs = [
    MEMORY_DIR,
    path.join(MEMORY_DIR, 'vocabulary'),
    path.join(MEMORY_DIR, 'phonics'),
    path.join(MEMORY_DIR, 'grammar'),
    path.join(MEMORY_DIR, 'daily-logs'),
    path.join(MEMORY_DIR, 'progress'),
    path.join(MEMORY_DIR, 'feishu-sync')
  ];
  
  dirs.forEach(dir => {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
  });
}

// 引导流程状态
class OnboardingFlow {
  constructor() {
    this.profile = {
      name: '',
      startDate: new Date().toISOString().split('T')[0],
      goals: [],
      currentLevel: 'beginner',
      dailyTimeMinutes: 120,
      preferredTimes: [],
      learningStyle: 'mixed',
      interests: [],
      integrations: [],
      assessmentResults: null,
      customSettings: {}
    };
  }

  // Step 1: 欢迎
  welcome() {
    return {
      message: `👋 欢迎来到你的私人英语教练！

我会帮你从零开始，系统学习英语。
整个设置过程大约需要 5-10 分钟，让我了解你的情况。

准备好了吗？`,
      options: ['开始设置', '稍后再说'],
      nextStep: 'goals'
    };
  }

  // Step 2: 学习目标
  setGoals(selectedGoals) {
    const goalOptions = {
      'tech_reading': '📚 阅读技术文档无障碍',
      'daily_communication': '💬 日常交流（旅游、生活）',
      'workplace': '💼 职场英语（会议、邮件、面试）',
      'exam': '🎓 考试（雅思/托福/四六级）',
      'entertainment': '🎬 看剧/电影不用字幕',
      'writing': '✍️ 写技术博客/论文',
      'comprehensive': '🌍 全面提升'
    };

    this.profile.goals = selectedGoals;

    return {
      message: `很好！你选择了：\n${selectedGoals.map(g => goalOptions[g]).join('\n')}`,
      nextStep: 'assessment'
    };
  }

  // Step 3: 水平评估
  assessLevel(selfAssessment, testResults = null) {
    const levels = {
      'zero': { level: 'absolute_beginner', description: '零基础（从音标开始）' },
      'beginner': { level: 'beginner', description: '初级（会一些单词）' },
      'intermediate': { level: 'intermediate', description: '中级（能看懂简单文章）' },
      'upper_intermediate': { level: 'upper_intermediate', description: '中高级（能基本交流）' },
      'advanced': { level: 'advanced', description: '高级（接近母语）' }
    };

    this.profile.currentLevel = levels[selfAssessment].level;
    this.profile.assessmentResults = {
      selfAssessment,
      testResults,
      assessedAt: new Date().toISOString()
    };

    return {
      message: `评估完成！你的当前水平：${levels[selfAssessment].description}`,
      nextStep: 'schedule'
    };
  }

  // Step 4: 学习时间安排
  setSchedule(dailyMinutes, preferredTimes) {
    this.profile.dailyTimeMinutes = dailyMinutes;
    this.profile.preferredTimes = preferredTimes;

    const timeSlots = {
      'morning': '早上（6:00-9:00）',
      'forenoon': '上午（9:00-12:00）',
      'afternoon': '下午（12:00-18:00）',
      'evening': '晚上（18:00-22:00）',
      'night': '深夜（22:00-24:00）'
    };

    return {
      message: `时间安排：
- 每天学习 ${dailyMinutes} 分钟
- 偏好时段：${preferredTimes.map(t => timeSlots[t]).join('、')}`,
      nextStep: 'style'
    };
  }

  // Step 5: 学习风格和兴趣
  setStyleAndInterests(style, interests) {
    this.profile.learningStyle = style;
    this.profile.interests = interests;

    return {
      message: `学习风格：${style}\n兴趣领域：${interests.join('、')}`,
      nextStep: 'integration'
    };
  }

  // Step 6: 工具集成
  setIntegration(integrations) {
    this.profile.integrations = integrations;

    return {
      message: `已选择集成：${integrations.join('、')}`,
      nextStep: 'generate_plan'
    };
  }

  // Step 7: 生成学习计划
  generateLearningPlan() {
    const plan = this.createPersonalizedPlan();
    
    return {
      message: `✨ 学习计划已生成！

根据你的情况：
- 目标：${this.profile.goals.join('、')}
- 水平：${this.profile.currentLevel}
- 时间：每天 ${this.profile.dailyTimeMinutes} 分钟
- 风格：${this.profile.learningStyle}

📋 你的学习路线图：

${plan.roadmap}

准备好开始了吗？`,
      plan,
      nextStep: 'first_lesson'
    };
  }

  // 创建个性化学习计划
  createPersonalizedPlan() {
    const { currentLevel, dailyTimeMinutes, goals } = this.profile;

    // 根据水平和时间分配任务
    const timeAllocation = this.allocateTime(dailyTimeMinutes, currentLevel);

    // 生成路线图
    const roadmap = this.generateRoadmap(currentLevel, goals);

    return {
      timeAllocation,
      roadmap,
      milestones: this.generateMilestones(currentLevel),
      firstWeekPlan: this.generateFirstWeekPlan(currentLevel, timeAllocation)
    };
  }

  // 时间分配
  allocateTime(totalMinutes, level) {
    const allocations = {
      'absolute_beginner': {
        phonics: 0.3,
        vocabulary: 0.3,
        grammar: 0.2,
        listening: 0.2
      },
      'beginner': {
        phonics: 0.2,
        vocabulary: 0.3,
        grammar: 0.2,
        listening: 0.2,
        speaking: 0.1
      },
      'intermediate': {
        vocabulary: 0.25,
        grammar: 0.15,
        listening: 0.25,
        speaking: 0.15,
        reading: 0.15,
        writing: 0.05
      }
    };

    const allocation = allocations[level] || allocations['beginner'];
    const result = {};

    for (const [skill, ratio] of Object.entries(allocation)) {
      result[skill] = Math.round(totalMinutes * ratio);
    }

    return result;
  }

  // 生成路线图
  generateRoadmap(level, goals) {
    if (level === 'absolute_beginner') {
      return `【第1-2周】音标与发音基础
- 每天30分钟：学习国际音标（48个）
- 每天20分钟：发音练习
- 每天10分钟：简单词汇（100个高频词）

【第3-8周】词汇与基础语法
- 每天40分钟：词汇学习（每天20个新词）
- 每天30分钟：基础语法（时态、句型）
- 每天20分钟：听力训练（慢速材料）
- 每天10分钟：复习

【第9-24周】能力提升
- 阅读：技术文档、简单文章
- 听力：正常语速材料
- 口语：日常对话练习
- 写作：英文日记

【6个月后】实战应用
- 技术英语专项
- 真实场景交流
- 持续提升`;
    }

    return '根据你的水平定制的学习路线...';
  }

  // 生成里程碑
  generateMilestones(level) {
    return [
      { day: 7, title: '完成第一周', description: '掌握基础音标' },
      { day: 30, title: '坚持一个月', description: '词汇量达到500' },
      { day: 90, title: '三个月成就', description: '能进行简单对话' },
      { day: 180, title: '半年突破', description: '阅读简单技术文档' }
    ];
  }

  // 生成第一周计划
  generateFirstWeekPlan(level, timeAllocation) {
    return {
      week: 1,
      focus: '音标基础 + 高频词汇',
      dailyTasks: {
        phonics: '学习5个元音音标',
        vocabulary: '学习10个最高频词',
        practice: '发音练习和听力训练'
      },
      timeAllocation
    };
  }

  // 保存配置
  save() {
    ensureDirectories();
    fs.writeFileSync(PROFILE_PATH, JSON.stringify(this.profile, null, 2));

    // 初始化其他数据文件
    this.initializeDataFiles();

    return {
      success: true,
      message: '配置已保存！',
      profilePath: PROFILE_PATH
    };
  }

  // 初始化数据文件
  initializeDataFiles() {
    // 词汇数据
    const vocabData = {
      words: [],
      categories: {},
      lastUpdated: new Date().toISOString()
    };
    fs.writeFileSync(
      path.join(MEMORY_DIR, 'vocabulary/words.json'),
      JSON.stringify(vocabData, null, 2)
    );

    // SRS调度
    const srsData = {
      schedule: [],
      lastReview: null
    };
    fs.writeFileSync(
      path.join(MEMORY_DIR, 'vocabulary/srs-schedule.json'),
      JSON.stringify(srsData, null, 2)
    );

    // 音标进度
    const phonicsProgress = {
      learned: [],
      mastered: [],
      practicing: [],
      lastUpdated: new Date().toISOString()
    };
    fs.writeFileSync(
      path.join(MEMORY_DIR, 'phonics/progress.json'),
      JSON.stringify(phonicsProgress, null, 2)
    );

    // 统计数据
    const stats = {
      totalStudyDays: 0,
      totalStudyMinutes: 0,
      vocabularySize: 0,
      lessonsCompleted: 0,
      startDate: this.profile.startDate,
      lastStudyDate: null
    };
    fs.writeFileSync(
      path.join(MEMORY_DIR, 'progress/stats.json'),
      JSON.stringify(stats, null, 2)
    );
  }

  // 加载现有配置
  static load() {
    if (fs.existsSync(PROFILE_PATH)) {
      const data = fs.readFileSync(PROFILE_PATH, 'utf8');
      const flow = new OnboardingFlow();
      flow.profile = JSON.parse(data);
      return flow;
    }
    return null;
  }
}

// 导出
module.exports = { OnboardingFlow, ensureDirectories };

// CLI 使用
if (require.main === module) {
  const flow = new OnboardingFlow();
  console.log(JSON.stringify(flow.welcome(), null, 2));
}
