#!/usr/bin/env bash

OUTDIR="$HOME/Music"

if [[ -z "$1" ]]; then
  echo "Использование: yt-music <ссылка>"
  exit 1
fi

URL="$1"

yt-dlp \
  -x \
  --audio-format mp3 \
  --audio-quality 0 \
  --embed-thumbnail \
  --embed-metadata \
  --add-metadata \
  --parse-metadata "%(webpage_url)s:%(meta_comment)s" \
  -o "$OUTDIR/%(title)s.%(ext)s" \
  "$URL"
