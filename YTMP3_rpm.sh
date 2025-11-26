#!/usr/bin/env bash
# YTMP3 for RPM-based Linux distributions.
# Downloads a YouTube video as an MP3 with clipboard URL detection.

set -euo pipefail

YTDL_CMD="yt-dlp"

log() {
  printf "[YTMP3] %s\n" "$1"
}

require_command() {
  local cmd="$1" pkg="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    log "Missing $cmd. Installing $pkg via dnf/yum..."
    if command -v sudo >/dev/null 2>&1; then
      if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y "$pkg"
      else
        sudo yum install -y "$pkg"
      fi
    else
      if command -v dnf >/dev/null 2>&1; then
        dnf install -y "$pkg"
      else
        yum install -y "$pkg"
      fi
    fi
  else
    log "$cmd is available."
  fi
}

install_dependencies() {
  require_command "$YTDL_CMD" yt-dlp
  require_command ffmpeg ffmpeg
  require_command xclip xclip
}

get_url() {
  if [[ $# -gt 0 ]]; then
    printf '%s' "$1"
    return
  fi

  if command -v xclip >/dev/null 2>&1; then
    local clipboard
    clipboard=$(xclip -o -selection clipboard || xclip -o || true)
    if [[ $clipboard =~ (https?://[^[:space:]"]+) ]]; then
      log "Detected URL in clipboard."
      printf '%s' "${BASH_REMATCH[1]}"
      return
    fi
    log "Clipboard checked but no URL detected."
  fi

  read -r -p "Enter the video URL: " manual_url
  printf '%s' "$manual_url"
}

main() {
  install_dependencies

  log "Copy the link to the video you wish to download or provide it when prompted."
  read -r -p "Press [Enter] key to continue" _

  url=$(get_url "${1:-}")
  if [[ -z "$url" ]]; then
    log "No URL provided. Exiting."
    exit 1
  fi

  log "Downloading and converting to mp3..."
  "$YTDL_CMD" -x --audio-format mp3 "$url"
  log "Done."
}

main "$@"
