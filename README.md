# YTMP3

Simple Bash script to download a YouTube video as an MP3 using [`yt-dlp`](https://github.com/yt-dlp/yt-dlp).

## Features
- Installs required tools (`yt-dlp`, `ffmpeg`, `xclip`) on Debian/Ubuntu systems when missing.
- Detects URLs in the clipboard (via `xclip`), falling back to prompting if none is found.
- Accepts a URL passed as an argument or reads it from the clipboard; otherwise prompts for input.

## Usage
```bash
./YTMP3.sh "https://www.youtube.com/watch?v=example"
# or
./YTMP3.sh  # will attempt clipboard, then prompt for a URL
```

> Note: Package installation uses `apt-get` and may require `sudo` privileges.
