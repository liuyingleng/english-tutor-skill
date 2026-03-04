# 语音功能设计文档

## 🎙️ 概述

为 English Tutor 添加完整的语音学习功能，包括：
- 标准发音播放
- 用户跟读录音
- 发音对比分析
- 发音评分反馈
- 音频云存储

---

## 📋 功能需求

### 1. 音标发音示范
- AI 播放标准音标发音
- 提供例词发音
- 支持慢速/正常速度

### 2. 用户跟读录音
- 录制用户发音
- 支持多次录制
- 实时反馈

### 3. 发音对比
- 并排播放标准音和用户音
- 波形对比（可选）
- 高亮差异点

### 4. 发音评分
- 准确度评分（0-100）
- 流利度评分
- 完整度评分
- 具体问题点指出

### 5. 音频存储
- 云端存储（OSS）
- 飞书记录链接
- 历史回听

---

## 🏗️ 技术架构

### 整体流程

```
┌─────────────────────────────────────────────────┐
│              用户交互                            │
│  "学习音标 /iː/"                                 │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│           AI Agent (OpenClaw)                    │
│  1. 读取音标数据                                 │
│  2. 调用 TTS 生成标准音                          │
│  3. 播放给用户                                   │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│              用户跟读                            │
│  录音 → 上传到 OpenClaw                          │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│          音频处理流程                            │
│  ┌───────────────────────────────────────────┐  │
│  │ 1. 接收音频文件                           │  │
│  │ 2. 上传到 OSS (upload-audio.sh)          │  │
│  │ 3. 获取 URL                               │  │
│  │ 4. 发音评分 (pronunciation-score.py)     │  │
│  │ 5. 保存记录到飞书                         │  │
│  └───────────────────────────────────────────┘  │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│              反馈给用户                          │
│  - 评分：85/100                                  │
│  - 问题：/iː/ 发音略短                           │
│  - 建议：延长发音时间                            │
│  - 播放对比：[标准音] [你的录音]                │
└─────────────────────────────────────────────────┘
```

---

## 💾 存储方案

### 方案选择：OSS + 飞书

**OSS 存储结构**：
```
Bucket: english-tutor-audio
├── standard/                    # 标准发音（预生成）
│   ├── phonics/
│   │   ├── iː.mp3
│   │   ├── ɪ.mp3
│   │   └── ...（48个音标）
│   └── vocabulary/
│       ├── hello.mp3
│       ├── world.mp3
│       └── ...
│
└── users/                       # 用户录音
    └── {user_id}/
        ├── phonics/
        │   ├── 2026-03-04_14-30-25_iː_001.mp3
        │   ├── 2026-03-04_14-32-10_iː_002.mp3
        │   └── 2026-03-04_14-35-00_ɪ_001.mp3
        ├── vocabulary/
        │   ├── 2026-03-04_15-00-00_hello_001.mp3
        │   └── 2026-03-04_15-05-00_world_001.mp3
        └── speaking/
            ├── 2026-03-04_16-00-00_conversation_001.mp3
            └── ...
```

**飞书多维表格**：
```
表名：发音练习记录

字段：
├── 日期 (Date)
├── 时间 (DateTime)
├── 类型 (Select)
│   ├── 音标
│   ├── 单词
│   ├── 句子
│   └── 对话
├── 内容 (Text)
│   └── 例如：/iː/, hello, "How are you?"
├── 标准音频 (URL)
│   └── https://oss.../standard/phonics/iː.mp3
├── 用户录音 (URL)
│   └── https://oss.../users/xxx/phonics/2026-03-04_iː_001.mp3
├── 总分 (Number: 0-100)
├── 准确度 (Number: 0-100)
├── 流利度 (Number: 0-100)
├── 完整度 (Number: 0-100)
├── 问题点 (Text)
│   └── "/iː/ 发音略短"
├── 改进建议 (Text)
│   └── "延长发音时间，保持嘴型"
├── 练习次数 (Number)
│   └── 第几次练习这个内容
└── 备注 (Text)
```

---

## 🔧 实现细节

### 1. 标准发音生成

**方式1：预生成（推荐）**
```bash
# 使用 TTS 预生成所有标准发音
# 48个音标 + 常用词汇

# 音标发音
for phoneme in /iː/ /ɪ/ /e/ ...; do
  tts --text "$phoneme" --output "standard/phonics/${phoneme}.mp3"
done

# 例词发音
for word in see tea meet beat; do
  tts --text "$word" --output "standard/vocabulary/${word}.mp3"
done

# 上传到 OSS
./scripts/upload-audio.sh standard/phonics/iː.mp3 standard "iː"
```

**方式2：实时生成**
```bash
# 用户请求时实时生成
tts --text "/iː/" --output /tmp/iː.mp3
# 播放给用户
```

### 2. 用户录音流程

**在 SKILL.md 中添加**：
```markdown
## 音标跟读练习

当用户学习音标时：

1. 播放标准发音：
   ```bash
   # 从 OSS 获取标准音频 URL
   STANDARD_URL="https://oss.../standard/phonics/iː.mp3"
   
   # 使用 OpenClaw 的音频播放功能
   # 或者直接返回 URL 给用户
   ```

2. 提示用户跟读：
   ```
   🔊 [播放标准发音]
   
   现在请跟读这个音标：/iː/
   
   [开始录音] 按钮
   ```

3. 接收用户录音：
   ```bash
   # OpenClaw 接收音频文件
   USER_AUDIO="/tmp/user_recording.mp3"
   
   # 上传到 OSS
   UPLOAD_RESULT=$(./scripts/upload-audio.sh "$USER_AUDIO" "phonics" "iː")
   USER_URL=$(echo "$UPLOAD_RESULT" | jq -r '.url')
   ```

4. 发音评分：
   ```bash
   # 调用评分脚本
   SCORE_RESULT=$(python3 ./scripts/pronunciation-score.py \
     "$STANDARD_URL" \
     "$USER_AUDIO" \
     "/iː/")
   
   SCORE=$(echo "$SCORE_RESULT" | jq -r '.overall_score')
   FEEDBACK=$(echo "$SCORE_RESULT" | jq -r '.feedback')
   ```

5. 保存到飞书：
   ```bash
   # 使用 feishu_bitable_create_record
   feishu_bitable_create_record(
     app_token: "...",
     table_id: "...",
     fields: {
       "日期": "2026-03-04",
       "类型": "音标",
       "内容": "/iː/",
       "标准音频": "$STANDARD_URL",
       "用户录音": "$USER_URL",
       "总分": $SCORE,
       "问题点": "...",
       "改进建议": "..."
     }
   )
   ```

6. 反馈给用户：
   ```
   ✅ 录音完成！
   
   📊 评分：85/100
   
   📈 详细分析：
   - 准确度：90/100
   - 流利度：80/100
   - 完整度：85/100
   
   ⚠️ 需要改进：
   - /iː/ 发音略短
   
   💡 建议：
   - 延长发音时间，保持嘴型不变
   
   🔊 对比播放：
   [标准发音] [你的录音]
   
   📝 已保存到飞书，可随时回听
   
   要再练一次吗？
   ```
```

### 3. 发音评分算法

**基础版（当前）**：
```python
# scripts/pronunciation-score.py
# 返回模拟评分，用于测试流程
```

**进阶版（未来）**：
```python
import speech_recognition as sr
from pydub import AudioSegment
import librosa
import numpy as np

def score_pronunciation(standard_audio, user_audio, expected_text):
    # 1. 语音识别
    recognizer = sr.Recognizer()
    with sr.AudioFile(user_audio) as source:
        audio = recognizer.record(source)
    recognized_text = recognizer.recognize_google(audio)
    
    # 2. 文本匹配
    accuracy = calculate_text_similarity(expected_text, recognized_text)
    
    # 3. 音频特征对比
    standard_features = extract_audio_features(standard_audio)
    user_features = extract_audio_features(user_audio)
    
    # 4. 计算相似度
    similarity = calculate_audio_similarity(standard_features, user_features)
    
    # 5. 综合评分
    overall_score = (accuracy * 0.6 + similarity * 0.4) * 100
    
    return {
        "overall_score": overall_score,
        "accuracy": accuracy * 100,
        "recognized_text": recognized_text,
        ...
    }
```

---

## 🔐 配置说明

### OSS 配置

**腾讯云 COS（推荐）**：
```bash
# 安装 coscmd
pip install coscmd

# 配置环境变量
export OSS_PROVIDER=tencent
export OSS_BUCKET=english-tutor-audio
export OSS_REGION=ap-guangzhou
export OSS_ACCESS_KEY=your_access_key
export OSS_SECRET_KEY=your_secret_key
```

**阿里云 OSS**：
```bash
# 安装 ossutil
# https://help.aliyun.com/document_detail/120075.html

export OSS_PROVIDER=aliyun
export OSS_BUCKET=english-tutor-audio
export OSS_REGION=cn-hangzhou
export OSS_ACCESS_KEY=your_access_key
export OSS_SECRET_KEY=your_secret_key
```

**AWS S3**：
```bash
# 安装 aws-cli
pip install awscli

export OSS_PROVIDER=aws
export OSS_BUCKET=english-tutor-audio
export OSS_REGION=us-east-1
export OSS_ACCESS_KEY=your_access_key
export OSS_SECRET_KEY=your_secret_key
```

### 成本估算

**腾讯云 COS**：
- 存储：0.099 元/GB/月
- 流量：0.5 元/GB（CDN 加速）
- 请求：0.01 元/万次

**示例**：
- 每个音频文件：~100KB
- 每天录音 20 次：2MB
- 每月存储：60MB ≈ 0.006 元
- 每月流量：1GB ≈ 0.5 元
- **总计**：约 0.5 元/月

---

## 📱 用户体验流程

### 场景1：学习音标

```
用户：学习音标 /iː/

AI：
📖 音标：/iː/
发音：长元音，嘴唇扁平，舌位高前

🔊 [播放标准发音]

例词：
- see /siː/
- tea /tiː/
- meet /miːt/

现在请跟读：/iː/

[🎤 开始录音]

---

用户：[点击录音，说 "iː"]

AI：
✅ 录音完成！正在分析...

📊 评分：85/100

很好！你的发音基本准确。

⚠️ 小建议：
- 发音时间可以再长一点
- 保持嘴型不变

🔊 对比播放：
[▶️ 标准发音] [▶️ 你的录音]

📝 已保存到飞书"发音练习记录"

要再练一次吗？
[再练一次] [下一个音标]
```

### 场景2：查看历史录音

```
用户：查看我的发音练习记录

AI：
📊 发音练习记录

今天：
1. /iː/ - 85分 (14:30)
   🔊 [播放录音]
   
2. /ɪ/ - 78分 (14:35)
   🔊 [播放录音]

昨天：
1. /e/ - 90分
2. /æ/ - 82分

本周统计：
- 练习次数：15次
- 平均分：83分
- 进步：+5分

🔗 查看完整记录（飞书）
```

---

## 🚀 实施计划

### Phase 1：基础设施（1周）
- [x] OSS 上传脚本
- [x] 发音评分脚本（模拟版）
- [ ] 标准发音预生成
- [ ] 飞书表格创建

### Phase 2：核心功能（2周）
- [ ] 音标跟读流程
- [ ] 单词跟读流程
- [ ] 录音保存和回听
- [ ] 更新 SKILL.md

### Phase 3：评分优化（2周）
- [ ] 集成语音识别
- [ ] 音频特征提取
- [ ] 发音相似度计算
- [ ] 详细反馈生成

### Phase 4：用户体验（1周）
- [ ] 历史记录查询
- [ ] 进度统计
- [ ] 对比播放
- [ ] 移动端优化

---

## 📝 配置文件示例

**config/audio.json**：
```json
{
  "oss": {
    "provider": "tencent",
    "bucket": "english-tutor-audio",
    "region": "ap-guangzhou",
    "access_key": "your_key",
    "secret_key": "your_secret",
    "cdn_domain": "https://cdn.example.com"
  },
  "tts": {
    "provider": "openai",
    "model": "tts-1",
    "voice": "alloy"
  },
  "speech_recognition": {
    "provider": "google",
    "language": "en-US"
  },
  "audio_format": {
    "sample_rate": 16000,
    "channels": 1,
    "format": "mp3",
    "bitrate": "128k"
  }
}
```

---

## 🎯 总结

### 核心优势

1. **完整的学习闭环**
   - 听标准音 → 跟读 → 评分 → 改进

2. **数据持久化**
   - OSS 云存储，永久保存
   - 飞书记录，方便查看

3. **进度可追踪**
   - 每次练习都有记录
   - 可以看到自己的进步

4. **多端同步**
   - 在任何平台练习
   - 数据实时同步

### 下一步

1. 配置 OSS 账号
2. 预生成标准发音
3. 更新 SKILL.md 添加语音功能
4. 测试完整流程
5. 优化用户体验

**准备好开始实施了吗？** 🚀
