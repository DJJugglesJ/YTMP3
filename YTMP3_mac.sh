#!/usr/bin/env bash
# YTMP3 for macOS.
# Downloads a YouTube video as an MP3 with clipboard URL detection.

set -euo pipefail

YTDL_CMD="yt-dlp"

log() {
  printf "[YTMP3] %s\n" "$1"
}

require_command() {
  local cmd="$1" pkg="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    log "Missing $cmd. Installing $pkg via Homebrew..."
    if ! command -v brew >/dev/null 2>&1; then
      log "Homebrew is required but not found. Install it from https://brew.sh/ first."
      exit 1
    fi
    brew install "$pkg"
  else
    log "$cmd is available."
  fi
}

install_dependencies() {
  require_command "$YTDL_CMD" yt-dlp
  require_command ffmpeg ffmpeg
}

get_url() {
  if [[ $# -gt 0 ]]; then
    printf '%s' "$1"
    return
  fi

  if command -v pbpaste >/dev/null 2>&1; then
    local clipboard
    clipboard=$(pbpaste || true)
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
