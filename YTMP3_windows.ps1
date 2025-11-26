# YTMP3 for Windows (PowerShell)
# Downloads a YouTube video as an MP3 with clipboard URL detection.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Write-Log {
    param([string]$Message)
    Write-Host "[YTMP3] $Message"
}

function Require-Package {
    param(
        [string]$Command,
        [string]$PackageId,
        [string]$DisplayName
    )

    if (-not (Get-Command $Command -ErrorAction SilentlyContinue)) {
        Write-Log "$DisplayName is missing. Installing with winget..."
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            throw "winget is required to install $DisplayName. Install it from the Microsoft Store and re-run this script."
        }
        winget install --id $PackageId -e --accept-package-agreements --accept-source-agreements
    }
    else {
        Write-Log "$DisplayName is available."
    }
}

function Install-Dependencies {
    Require-Package -Command "yt-dlp" -PackageId "yt-dlp.yt-dlp" -DisplayName "yt-dlp"
    Require-Package -Command "ffmpeg" -PackageId "Gyan.FFmpeg" -DisplayName "ffmpeg"
}

function Get-Url {
    param([string]$ArgUrl)

    if ($ArgUrl) {
        return $ArgUrl
    }

    try {
        $clipboard = Get-Clipboard -Raw
    }
    catch {
        $clipboard = $null
    }

    if ($clipboard -and ($clipboard -match '(https?://[^\s\"]+)')) {
        Write-Log "Detected URL in clipboard."
        return $Matches[1]
    }

    Write-Log "Clipboard checked but no URL detected."
    return Read-Host "Enter the video URL"
}

function Main {
    Install-Dependencies

    Write-Log "Copy the link to the video you wish to download or provide it when prompted."
    Read-Host "Press Enter to continue" | Out-Null

    $url = Get-Url -ArgUrl $args[0]
    if (-not $url) {
        Write-Log "No URL provided. Exiting."
        exit 1
    }

    Write-Log "Downloading and converting to mp3..."
    yt-dlp -x --audio-format mp3 "$url"
    Write-Log "Done."
}

Main
