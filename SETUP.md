# 安装配置指南

## 前置要求

### 1. 安装 OpenClaw

```bash
npm install -g openclaw
```

验证安装：
```bash
openclaw --version
```

### 2. 配置飞书集成

#### 步骤1：创建飞书应用

1. 访问 [飞书开放平台](https://open.feishu.cn/app)
2. 点击"创建企业自建应用"
3. 填写应用信息：
   - 应用名称：English Tutor
   - 应用描述：个人英语学习助手
   - 应用图标：上传图标

#### 步骤2：获取凭证

在应用详情页，找到：
- **App ID**
- **App Secret**

#### 步骤3：配置权限

在"权限管理"中，开通以下权限：

**文档权限**：
- `docx:document` - 文档读写
- `wiki:wiki` - 知识库管理
- `bitable:app` - 多维表格

**其他权限**（可选）：
- `im:message` - 消息发送（如果要飞书机器人提醒）
- `contact:user.base` - 获取用户信息

#### 步骤4：配置 OpenClaw

创建或编辑 OpenClaw 配置文件：

```bash
mkdir -p ~/.openclaw/config
nano ~/.openclaw/config/feishu.json
```

填入：
```json
{
  "appId": "你的App ID",
  "appSecret": "你的App Secret"
}
```

或者使用环境变量：
```bash
export FEISHU_APP_ID="你的App ID"
export FEISHU_APP_SECRET="你的App Secret"
```

#### 步骤5：验证配置

在 OpenClaw 中测试：
```bash
openclaw agent --message "测试飞书连接"
```

AI 应该能够访问飞书 API。

---

## 安装 English Tutor Skill

### 方法1：Git 克隆（推荐）

```bash
cd ~/.openclaw/workspace/skills/
git clone https://github.com/liuyingleng/english-tutor-skill.git english-tutor
```

### 方法2：手动下载

1. 下载项目压缩包
2. 解压到 `~/.openclaw/workspace/skills/english-tutor/`

### 方法3：使用 ClawHub（未来）

```bash
clawhub install english-tutor
```

---

## 验证安装

### 1. 检查文件结构

```bash
ls -la ~/.openclaw/workspace/skills/english-tutor/
```

应该看到：
```
SKILL.md
README.md
data/
scripts/
templates/
```

### 2. 测试 SRS 脚本

```bash
cd ~/.openclaw/workspace/skills/english-tutor
./scripts/srs.sh '{"interval":1,"ease_factor":2.5,"repetitions":0}' 4
```

应该输出 JSON 格式的结果。

### 3. 刷新 OpenClaw

```bash
openclaw gateway restart
```

或者在聊天中对 AI 说：
```
刷新 skills
```

---

## 首次使用

### 1. 启动引导

在任何接入 OpenClaw 的平台上，对 AI 说：

```
我想学英语
```

或者：

```
/english setup
```

### 2. 完成引导流程

AI 会引导你：
1. 选择学习目标
2. 评估当前水平
3. 设置学习时间
4. 创建飞书知识库
5. 生成学习计划

### 3. 开始学习

引导完成后，AI 会带你开始第一课（通常是音标学习）。

---

## 配置选项

### TTS（文本转语音）

如果你想使用语音功能，需要配置 TTS 服务。

#### 选项1：飞书 TTS

飞书应用自带 TTS 功能，无需额外配置。

#### 选项2：OpenAI TTS

```bash
export OPENAI_API_KEY="你的OpenAI API Key"
```

在 OpenClaw 配置中启用：
```json
{
  "tts": {
    "provider": "openai",
    "model": "tts-1",
    "voice": "alloy"
  }
}
```

#### 选项3：ElevenLabs

```bash
export ELEVENLABS_API_KEY="你的ElevenLabs API Key"
```

### 词典 API（可选）

默认使用内置词库，如果想使用在线词典：

#### 有道词典

```bash
export YOUDAO_APP_KEY="你的有道App Key"
export YOUDAO_APP_SECRET="你的有道App Secret"
```

#### 剑桥词典

```bash
export CAMBRIDGE_API_KEY="你的剑桥词典API Key"
```

---

## 多平台接入

### Web 聊天

直接访问 OpenClaw Web 界面，开始对话。

### 微信

1. 配置 OpenClaw 的微信集成
2. 扫码登录
3. 在微信中与 AI 对话

### Telegram

1. 创建 Telegram Bot（通过 @BotFather）
2. 配置 OpenClaw 的 Telegram 集成
3. 在 Telegram 中与 Bot 对话

### Discord

1. 创建 Discord Bot
2. 配置 OpenClaw 的 Discord 集成
3. 邀请 Bot 到服务器
4. 在频道中与 Bot 对话

### QQ

1. 配置 OpenClaw 的 QQ 集成
2. 登录 QQ 账号
3. 在 QQ 中与 AI 对话

---

## 故障排查

### 问题1：AI 不识别 English Tutor Skill

**解决方案**：
```bash
# 重启 OpenClaw
openclaw gateway restart

# 或者在聊天中
刷新 skills
```

### 问题2：无法访问飞书 API

**检查**：
1. 飞书 App ID 和 Secret 是否正确
2. 权限是否开通
3. 网络是否正常

**测试**：
```bash
curl -X POST "https://open.feishu.cn/open-apis/auth/v3/app_access_token/internal" \
  -H "Content-Type: application/json" \
  -d "{\"app_id\":\"你的App ID\",\"app_secret\":\"你的App Secret\"}"
```

### 问题3：SRS 脚本报错

**检查依赖**：
```bash
# 需要 jq 和 bc
which jq bc

# 如果没有，安装
# Ubuntu/Debian
sudo apt install jq bc

# macOS
brew install jq bc

# CentOS/RHEL
sudo yum install jq bc
```

### 问题4：TTS 不工作

**检查**：
1. TTS API Key 是否配置
2. 网络是否能访问 TTS 服务
3. OpenClaw 是否支持 TTS 工具

---

## 升级

### 更新 Skill

```bash
cd ~/.openclaw/workspace/skills/english-tutor
git pull origin main
```

### 更新 OpenClaw

```bash
npm update -g openclaw
openclaw gateway restart
```

---

## 卸载

### 删除 Skill

```bash
rm -rf ~/.openclaw/workspace/skills/english-tutor
```

### 清理飞书数据

在飞书中手动删除"英语学习"知识库空间。

---

## 下一步

安装完成后，阅读：
- [使用手册](SKILL.md) - 了解所有功能
- [README](README.md) - 项目概述
- [贡献指南](CONTRIBUTING.md) - 参与开发

**开始学习**：对 AI 说"我想学英语"！
