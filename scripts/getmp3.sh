#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <YouTube_URL>"
    exit 1
fi

URL="$1"

yt-dlp \
  --extract-audio \
  --audio-format mp3 \
  --audio-quality 5 \
  --embed-thumbnail \
  --embed-metadata \
  --add-metadata \
  --output "%(title)s.%(ext)s" \
  "$URL" || { echo "Download failed"; exit 2; }

