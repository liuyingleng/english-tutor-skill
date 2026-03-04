# 每日学习计划

**日期**: {{date}}  
**学习者**: {{learner_name}}  
**当前等级**: {{current_level}}  
**学习天数**: 第 {{day_number}} 天

---

## 今日目标

- [ ] 音标练习（{{phonics_time}}分钟）
- [ ] 词汇学习（{{vocab_time}}分钟）
- [ ] 语法学习（{{grammar_time}}分钟）
- [ ] 听力训练（{{listening_time}}分钟）
- [ ] 口语练习（{{speaking_time}}分钟）
- [ ] 阅读训练（{{reading_time}}分钟）
- [ ] 写作练习（{{writing_time}}分钟）

**预计总时长**: {{total_time}}分钟

---

## 详细任务

### 🔤 音标练习

**今日音标**: {{today_phonics}}

{{#each phonics_tasks}}
- {{this.task}}
  - 示例词: {{this.examples}}
  - 练习方式: {{this.method}}
{{/each}}

---

### 📚 词汇学习

**新词**: {{new_words_count}}个  
**复习词**: {{review_words_count}}个

#### 新词列表
{{#each new_words}}
{{@index}}. **{{this.word}}** /{{this.phonetic}}/
   - 词性: {{this.pos}}
   - 释义: {{this.meaning}}
   - 例句: {{this.example}}
{{/each}}

#### 需要复习的词
{{#each review_words}}
- {{this.word}} (上次学习: {{this.last_review}})
{{/each}}

---

### 📖 语法学习

**今日语法点**: {{grammar_topic}}

{{grammar_explanation}}

#### 练习题
{{#each grammar_exercises}}
{{@index}}. {{this.question}}
   答案: {{this.answer}}
{{/each}}

---

### 🎧 听力训练

**材料**: {{listening_material}}  
**难度**: {{listening_level}}  
**时长**: {{listening_duration}}

**任务**:
1. 第一遍：整体听，理解大意
2. 第二遍：逐句听，尝试听写
3. 第三遍：对照原文，标注生词

---

### 💬 口语练习

**今日场景**: {{speaking_scenario}}

**对话提示**:
{{speaking_prompts}}

**发音重点**:
{{pronunciation_focus}}

---

### 📰 阅读训练

**文章**: {{reading_article_title}}  
**来源**: {{reading_source}}  
**难度**: {{reading_level}}

**阅读任务**:
1. 快速浏览，了解主题
2. 精读，标注生词和难句
3. 总结文章大意

---

### ✍️ 写作练习

**主题**: {{writing_topic}}  
**要求**: {{writing_requirements}}  
**建议字数**: {{writing_word_count}}

---

## 学习提示

{{#each tips}}
- {{this}}
{{/each}}

---

## 完成情况

- 开始时间: ___:___
- 结束时间: ___:___
- 实际用时: ___ 分钟
- 完成度: ____%

**今日收获**:
_（学习结束后填写）_

**遇到的困难**:
_（学习结束后填写）_

**明日重点**:
_（学习结束后填写）_

---

_生成时间: {{generated_at}}_
