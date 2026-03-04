#!/bin/bash
# OSS 音频上传工具
# 支持腾讯云 COS、阿里云 OSS、AWS S3

set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 <audio_file> <type> <content>

参数：
  audio_file  - 音频文件路径
  type        - 类型 (phonics/vocabulary/speaking)
  content     - 内容标识 (音标/单词/句子)

环境变量：
  OSS_PROVIDER    - 提供商 (tencent/aliyun/aws)
  OSS_BUCKET      - Bucket 名称
  OSS_REGION      - 区域
  OSS_ACCESS_KEY  - Access Key
  OSS_SECRET_KEY  - Secret Key

输出：
  JSON 格式的上传结果，包含 URL

示例：
  export OSS_PROVIDER=tencent
  export OSS_BUCKET=english-tutor-audio
  export OSS_REGION=ap-guangzhou
  $0 /tmp/recording.mp3 phonics "iː"

EOF
  exit 1
}

# 检查参数
if [ $# -ne 3 ]; then
  usage
fi

AUDIO_FILE=$1
TYPE=$2
CONTENT=$3

# 检查文件
if [ ! -f "$AUDIO_FILE" ]; then
  echo "错误：文件不存在 $AUDIO_FILE" >&2
  exit 1
fi

# 检查环境变量
: "${OSS_PROVIDER:?需要设置 OSS_PROVIDER}"
: "${OSS_BUCKET:?需要设置 OSS_BUCKET}"
: "${OSS_REGION:?需要设置 OSS_REGION}"
: "${OSS_ACCESS_KEY:?需要设置 OSS_ACCESS_KEY}"
: "${OSS_SECRET_KEY:?需要设置 OSS_SECRET_KEY}"

# 生成文件名
USER_ID=${USER_ID:-"default"}
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
FILE_EXT="${AUDIO_FILE##*.}"
OBJECT_KEY="users/${USER_ID}/${TYPE}/${TIMESTAMP}_${CONTENT}.${FILE_EXT}"

# 根据提供商上传
case $OSS_PROVIDER in
  tencent)
    # 腾讯云 COS
    # 需要安装 coscmd: pip install coscmd
    if ! command -v coscmd &> /dev/null; then
      echo "错误：请先安装 coscmd (pip install coscmd)" >&2
      exit 1
    fi
    
    # 配置 coscmd
    coscmd config -a "$OSS_ACCESS_KEY" -s "$OSS_SECRET_KEY" -b "$OSS_BUCKET" -r "$OSS_REGION" > /dev/null 2>&1
    
    # 上传文件
    coscmd upload "$AUDIO_FILE" "$OBJECT_KEY" > /dev/null 2>&1
    
    # 生成 URL
    URL="https://${OSS_BUCKET}.cos.${OSS_REGION}.myqcloud.com/${OBJECT_KEY}"
    ;;
    
  aliyun)
    # 阿里云 OSS
    # 需要安装 ossutil: https://help.aliyun.com/document_detail/120075.html
    if ! command -v ossutil &> /dev/null; then
      echo "错误：请先安装 ossutil" >&2
      exit 1
    fi
    
    # 配置 ossutil
    ossutil config -e "oss-${OSS_REGION}.aliyuncs.com" -i "$OSS_ACCESS_KEY" -k "$OSS_SECRET_KEY" > /dev/null 2>&1
    
    # 上传文件
    ossutil cp "$AUDIO_FILE" "oss://${OSS_BUCKET}/${OBJECT_KEY}" > /dev/null 2>&1
    
    # 生成 URL
    URL="https://${OSS_BUCKET}.oss-${OSS_REGION}.aliyuncs.com/${OBJECT_KEY}"
    ;;
    
  aws)
    # AWS S3
    # 需要安装 aws-cli: pip install awscli
    if ! command -v aws &> /dev/null; then
      echo "错误：请先安装 aws-cli (pip install awscli)" >&2
      exit 1
    fi
    
    # 配置 aws
    export AWS_ACCESS_KEY_ID="$OSS_ACCESS_KEY"
    export AWS_SECRET_ACCESS_KEY="$OSS_SECRET_KEY"
    export AWS_DEFAULT_REGION="$OSS_REGION"
    
    # 上传文件
    aws s3 cp "$AUDIO_FILE" "s3://${OSS_BUCKET}/${OBJECT_KEY}" > /dev/null 2>&1
    
    # 生成 URL
    URL="https://${OSS_BUCKET}.s3.${OSS_REGION}.amazonaws.com/${OBJECT_KEY}"
    ;;
    
  *)
    echo "错误：不支持的提供商 $OSS_PROVIDER" >&2
    exit 1
    ;;
esac

# 获取文件大小
FILE_SIZE=$(stat -f%z "$AUDIO_FILE" 2>/dev/null || stat -c%s "$AUDIO_FILE" 2>/dev/null)

# 输出 JSON
jq -n \
  --arg url "$URL" \
  --arg object_key "$OBJECT_KEY" \
  --arg file_size "$FILE_SIZE" \
  --arg provider "$OSS_PROVIDER" \
  --arg bucket "$OSS_BUCKET" \
  --arg uploaded_at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{
    success: true,
    url: $url,
    object_key: $object_key,
    file_size: ($file_size | tonumber),
    provider: $provider,
    bucket: $bucket,
    uploaded_at: $uploaded_at
  }'
