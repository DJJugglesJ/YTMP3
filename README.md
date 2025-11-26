# YTMP3

Simple Bash script to download a YouTube video as an MP3 using [`yt-dlp`](https://github.com/yt-dlp/yt-dlp).

## Features
- Clipboard URL detection before prompting for input (via `xclip` on Linux, `pbpaste` on macOS, and `Get-Clipboard` on Windows).
- Optional URL argument; otherwise reads from the clipboard and falls back to a prompt.
- Installs required tools on supported platforms:
  - Debian/Ubuntu: `yt-dlp`, `ffmpeg`, `xclip` (via `apt-get`).
  - RPM-based Linux: `yt-dlp`, `ffmpeg`, `xclip` (via `dnf`/`yum`).
  - macOS: `yt-dlp`, `ffmpeg` (via Homebrew).
  - Windows: `yt-dlp`, `ffmpeg` (via `winget`).

## Usage

### Debian/Ubuntu (apt)
```bash
./YTMP3.sh "https://www.youtube.com/watch?v=example"
# or
./YTMP3.sh  # attempts clipboard, then prompts for a URL
```
> Uses `apt-get` and may require `sudo` privileges. Requires `xclip` for clipboard detection.

### RPM-based Linux (dnf/yum)
```bash
./YTMP3_rpm.sh "https://www.youtube.com/watch?v=example"
# or
./YTMP3_rpm.sh
```
> Uses `dnf`/`yum` and may require `sudo` privileges. Requires `xclip` for clipboard detection.

### macOS (Homebrew)
```bash
./YTMP3_mac.sh "https://www.youtube.com/watch?v=example"
# or
./YTMP3_mac.sh
```
> Requires Homebrew. Clipboard detection uses `pbpaste`.

### Windows (PowerShell + winget)
```powershell
powershell -ExecutionPolicy Bypass -File .\YTMP3_windows.ps1 "https://www.youtube.com/watch?v=example"
# or
powershell -ExecutionPolicy Bypass -File .\YTMP3_windows.ps1
```
> Requires PowerShell with `winget` available to install `yt-dlp` and `ffmpeg`. Clipboard detection uses `Get-Clipboard`.
