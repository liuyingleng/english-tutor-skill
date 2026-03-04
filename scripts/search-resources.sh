#!/bin/bash
# 英语学习资源搜索工具
# 搜索视频、播客、文章等学习资源

set -euo pipefail

# 使用方法
usage() {
  cat <<EOF
Usage: $0 <level> <type> [topic]

参数：
  level   - 学习水平
            beginner      初级
            intermediate  中级
            advanced      高级
  
  type    - 资源类型
            video         视频（YouTube等）
            podcast       播客
            article       文章
            movie         电影/美剧
            all           所有类型
  
  topic   - 主题（可选）
            speaking      口语
            listening     听力
            grammar       语法
            vocabulary    词汇
            business      商务英语
            tech          技术英语
            daily         日常交流

输出：
  JSON 格式的资源列表

示例：
  $0 intermediate video speaking
  $0 beginner podcast
  $0 advanced article tech

EOF
  exit 1
}

# 检查参数
if [ $# -lt 2 ]; then
  usage
fi

LEVEL=$1
TYPE=$2
TOPIC=${3:-"general"}

# 验证 level
if [[ ! "$LEVEL" =~ ^(beginner|intermediate|advanced)$ ]]; then
  echo "错误：level 必须是 beginner, intermediate 或 advanced" >&2
  exit 1
fi

# 验证 type
if [[ ! "$TYPE" =~ ^(video|podcast|article|movie|all)$ ]]; then
  echo "错误：type 必须是 video, podcast, article, movie 或 all" >&2
  exit 1
fi

# 构建搜索查询
build_query() {
  local level=$1
  local type=$2
  local topic=$3
  
  local query=""
  
  case $type in
    video)
      case $level in
        beginner)
          query="English learning videos for beginners $topic easy slow"
          ;;
        intermediate)
          query="English learning videos intermediate $topic"
          ;;
        advanced)
          query="English learning videos advanced $topic native speaker"
          ;;
      esac
      ;;
    
    podcast)
      case $level in
        beginner)
          query="English learning podcast for beginners $topic slow"
          ;;
        intermediate)
          query="English podcast intermediate learners $topic"
          ;;
        advanced)
          query="English podcast advanced $topic native"
          ;;
      esac
      ;;
    
    article)
      case $level in
        beginner)
          query="English reading articles for beginners $topic simple"
          ;;
        intermediate)
          query="English articles intermediate level $topic"
          ;;
        advanced)
          query="English articles advanced $topic"
          ;;
      esac
      ;;
    
    movie)
      case $level in
        beginner)
          query="English movies for learners beginners $topic with subtitles"
          ;;
        intermediate)
          query="English movies intermediate learners $topic"
          ;;
        advanced)
          query="English movies advanced $topic native"
          ;;
      esac
      ;;
  esac
  
  echo "$query"
}

# 推荐的资源（预设）
get_recommended_resources() {
  local level=$1
  local type=$2
  local topic=$3
  
  cat <<EOF
{
  "level": "$level",
  "type": "$type",
  "topic": "$topic",
  "recommended": [
EOF

  # 根据类型和水平推荐
  if [ "$type" = "video" ] || [ "$type" = "all" ]; then
    cat <<EOF
    {
      "title": "English with Lucy",
      "url": "https://www.youtube.com/@EnglishwithLucy",
      "type": "video",
      "level": "beginner-intermediate",
      "description": "British English pronunciation, vocabulary, and grammar",
      "duration": "10-20 min per video"
    },
    {
      "title": "Rachel's English",
      "url": "https://www.youtube.com/@rachelsenglish",
      "type": "video",
      "level": "intermediate-advanced",
      "description": "American English pronunciation and accent training",
      "duration": "5-15 min per video"
    },
    {
      "title": "TED Talks",
      "url": "https://www.ted.com/talks",
      "type": "video",
      "level": "intermediate-advanced",
      "description": "Inspiring talks on various topics with subtitles",
      "duration": "5-20 min per talk"
    },
EOF
  fi

  if [ "$type" = "podcast" ] || [ "$type" = "all" ]; then
    cat <<EOF
    {
      "title": "6 Minute English (BBC)",
      "url": "https://www.bbc.co.uk/learningenglish/english/features/6-minute-english",
      "type": "podcast",
      "level": "intermediate",
      "description": "Short episodes on interesting topics",
      "duration": "6 min per episode"
    },
    {
      "title": "All Ears English",
      "url": "https://www.allearsenglish.com/",
      "type": "podcast",
      "level": "intermediate-advanced",
      "description": "American English conversation practice",
      "duration": "15-30 min per episode"
    },
    {
      "title": "The English We Speak (BBC)",
      "url": "https://www.bbc.co.uk/learningenglish/english/features/the-english-we-speak",
      "type": "podcast",
      "level": "intermediate",
      "description": "Learn idioms and expressions",
      "duration": "3 min per episode"
    },
EOF
  fi

  if [ "$type" = "article" ] || [ "$type" = "all" ]; then
    cat <<EOF
    {
      "title": "BBC Learning English",
      "url": "https://www.bbc.co.uk/learningenglish",
      "type": "article",
      "level": "all",
      "description": "News articles with vocabulary explanations",
      "duration": "5-10 min per article"
    },
    {
      "title": "Breaking News English",
      "url": "https://breakingnewsenglish.com/",
      "type": "article",
      "level": "all",
      "description": "News articles with exercises at 7 levels",
      "duration": "10-15 min per article"
    },
EOF
  fi

  if [ "$type" = "movie" ] || [ "$type" = "all" ]; then
    cat <<EOF
    {
      "title": "Friends (TV Series)",
      "url": "https://www.imdb.com/title/tt0108778/",
      "type": "movie",
      "level": "intermediate",
      "description": "Classic sitcom, great for daily conversation",
      "duration": "20 min per episode"
    },
    {
      "title": "The Crown (Netflix)",
      "url": "https://www.netflix.com/title/80025678",
      "type": "movie",
      "level": "advanced",
      "description": "British English, formal language",
      "duration": "50-60 min per episode"
    },
EOF
  fi

  # 移除最后的逗号
  cat <<EOF
    {
      "title": "Search Query",
      "url": "search",
      "type": "search",
      "query": "$(build_query "$level" "$type" "$topic")",
      "description": "Use web_search to find more resources"
    }
  ]
}
EOF
}

# 输出推荐资源
get_recommended_resources "$LEVEL" "$TYPE" "$TOPIC"
