# 英语学习周报

**周期**: {{week_start}} 至 {{week_end}}  
**学习者**: {{learner_name}}  
**当前等级**: {{current_level}}

---

## 📊 本周数据

| 指标 | 数据 |
|------|------|
| 学习天数 | {{study_days}}/7 天 |
| 总学习时长 | {{total_hours}} 小时 |
| 日均学习时长 | {{avg_hours}} 小时 |
| 新学词汇 | {{new_words}} 个 |
| 复习词汇 | {{reviewed_words}} 个 |
| 累计词汇量 | {{total_vocabulary}} 个 |
| 完成练习 | {{completed_exercises}} 道 |
| 正确率 | {{accuracy}}% |

---

## 🎯 学习进度

### 音标掌握情况
- 已学音标: {{learned_phonics}}/48
- 熟练音标: {{mastered_phonics}}/48
- 需加强: {{weak_phonics}}

### 词汇进度
- 本周新词: {{new_words}}
- 掌握程度:
  - 熟练: {{mastered_words}} ({{mastered_percentage}}%)
  - 认识: {{familiar_words}} ({{familiar_percentage}}%)
  - 模糊: {{weak_words}} ({{weak_percentage}}%)

### 语法进度
- 已学语法点: {{learned_grammar_topics}}
- 本周重点: {{this_week_grammar}}
- 掌握情况: {{grammar_mastery}}%

---

## 📈 能力提升

### 听力
- 本周听力材料: {{listening_materials_count}} 篇
- 平均理解度: {{listening_comprehension}}%
- 进步: {{listening_improvement}}

### 口语
- 对话练习: {{speaking_sessions}} 次
- 场景覆盖: {{speaking_scenarios}}
- 发音改进: {{pronunciation_improvement}}

### 阅读
- 阅读文章: {{reading_articles_count}} 篇
- 阅读速度: {{reading_speed}} 词/分钟
- 理解准确率: {{reading_accuracy}}%

### 写作
- 写作练习: {{writing_count}} 次
- 总字数: {{writing_word_count}} 词
- 主要改进: {{writing_improvements}}

---

## 🌟 本周亮点

{{#each highlights}}
- {{this}}
{{/each}}

---

## 💪 需要加强

{{#each weaknesses}}
- {{this.area}}: {{this.description}}
  - 建议: {{this.suggestion}}
{{/each}}

---

## 📝 每日学习记录

### 周一 ({{monday_date}})
- 学习时长: {{monday_hours}} 小时
- 完成任务: {{monday_tasks}}
- 备注: {{monday_notes}}

### 周二 ({{tuesday_date}})
- 学习时长: {{tuesday_hours}} 小时
- 完成任务: {{tuesday_tasks}}
- 备注: {{tuesday_notes}}

### 周三 ({{wednesday_date}})
- 学习时长: {{wednesday_hours}} 小时
- 完成任务: {{wednesday_tasks}}
- 备注: {{wednesday_notes}}

### 周四 ({{thursday_date}})
- 学习时长: {{thursday_hours}} 小时
- 完成任务: {{thursday_tasks}}
- 备注: {{thursday_notes}}

### 周五 ({{friday_date}})
- 学习时长: {{friday_hours}} 小时
- 完成任务: {{friday_tasks}}
- 备注: {{friday_notes}}

### 周六 ({{saturday_date}})
- 学习时长: {{saturday_hours}} 小时
- 完成任务: {{saturday_tasks}}
- 备注: {{saturday_notes}}

### 周日 ({{sunday_date}})
- 学习时长: {{sunday_hours}} 小时
- 完成任务: {{sunday_tasks}}
- 备注: {{sunday_notes}}

---

## 🎓 本周学习内容

### 新学词汇 Top 20
{{#each top_new_words}}
{{@index}}. **{{this.word}}** - {{this.meaning}}
{{/each}}

### 重点语法
{{#each grammar_topics}}
- {{this.topic}}: {{this.summary}}
{{/each}}

### 推荐材料
{{#each recommended_materials}}
- {{this.type}}: {{this.title}} ({{this.reason}})
{{/each}}

---

## 📅 下周计划

### 学习重点
{{#each next_week_focus}}
- {{this}}
{{/each}}

### 目标设定
- 学习天数目标: {{next_week_days_goal}} 天
- 学习时长目标: {{next_week_hours_goal}} 小时
- 新词目标: {{next_week_words_goal}} 个
- 特殊任务: {{next_week_special_tasks}}

---

## 💡 学习建议

{{#each suggestions}}
- {{this}}
{{/each}}

---

## 🏆 里程碑

{{#if milestones}}
本周达成的里程��:
{{#each milestones}}
- 🎉 {{this.title}}: {{this.description}}
{{/each}}
{{else}}
暂无新里程碑，继续加油！
{{/if}}

---

_报告生成时间: {{generated_at}}_  
_下次报告: {{next_report_date}}_
