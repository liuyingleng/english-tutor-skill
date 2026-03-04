#!/bin/bash
# SRS (Spaced Repetition System) 算法
# 基于 SuperMemo SM-2 算法

set -euo pipefail

# 使用方法
usage() {
  cat <<EOF
Usage: $0 <word_json> <quality>

参数：
  word_json  - 单词的当前数据（JSON格式）
  quality    - 回忆质量 (0-5)
               5: 完美记住
               4: 正确但有点犹豫
               3: 正确但很困难
               2: 错误但似曾相识
               1: 错误且完全不记得
               0: 完全忘记

输出：
  JSON 格式的更新数据，包含：
  - interval: 新的复习间隔（天）
  - ease_factor: 新的难度系数
  - repetitions: 重复次数
  - next_review: 下次复习日期

示例：
  $0 '{"interval":1,"ease_factor":2.5,"repetitions":0}' 4
EOF
  exit 1
}

# 检查参数
if [ $# -ne 2 ]; then
  usage
fi

word_json="$1"
quality="$2"

# 验证 quality 范围
if ! [[ "$quality" =~ ^[0-5]$ ]]; then
  echo "错误：quality 必须是 0-5 之间的整数" >&2
  exit 1
fi

# 解析当前数据
current_interval=$(echo "$word_json" | jq -r '.interval // 1')
current_ease=$(echo "$word_json" | jq -r '.ease_factor // 2.5')
repetitions=$(echo "$word_json" | jq -r '.repetitions // 0')

# SuperMemo SM-2 算法
if [ "$quality" -lt 3 ]; then
  # 回忆失败，重置间隔
  new_interval=1
  new_repetitions=0
else
  # 回忆成功
  if [ "$repetitions" -eq 0 ]; then
    new_interval=1
  elif [ "$repetitions" -eq 1 ]; then
    new_interval=6
  else
    # interval = interval * ease_factor
    new_interval=$(echo "$current_interval * $current_ease" | bc | awk '{print int($1+0.5)}')
  fi
  new_repetitions=$((repetitions + 1))
fi

# 调整难度系数
# ease_factor = ease_factor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
ease_delta=$(echo "0.1 - (5 - $quality) * (0.08 + (5 - $quality) * 0.02)" | bc -l)
new_ease=$(echo "$current_ease + $ease_delta" | bc -l)

# 难度系数最小值为 1.3
if (( $(echo "$new_ease < 1.3" | bc -l) )); then
  new_ease=1.3
fi

# 计算下次复习日期
if command -v gdate &> /dev/null; then
  # macOS (需要 brew install coreutils)
  next_review=$(gdate -d "+${new_interval} days" +%Y-%m-%d)
else
  # Linux
  next_review=$(date -d "+${new_interval} days" +%Y-%m-%d)
fi

# 输出 JSON
jq -n \
  --argjson interval "$new_interval" \
  --argjson ease "$(printf '%.2f' "$new_ease")" \
  --argjson repetitions "$new_repetitions" \
  --arg next_review "$next_review" \
  '{
    interval: $interval,
    ease_factor: $ease,
    repetitions: $repetitions,
    next_review: $next_review
  }'
