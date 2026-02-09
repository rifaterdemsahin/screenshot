# Path to Paint.NET executable
$paintNetPath = "C:\Program Files\Paint.NET\PaintDotNet.exe"

# Base directory for captured screenshots
$capturedScreenshotsBaseDir = "C:\projects\screenshot\3_UI\CapturedScreenshots"

# Check if Paint.NET exists
if (-not (Test-Path $paintNetPath)) {
    Write-Host "Error: Paint.NET not found at '$paintNetPath'." -ForegroundColor Red
    Write-Host "Please ensure Paint.NET is installed or update the '$paintNetPath' variable in the script." -ForegroundColor Red
    exit 1
}

# Get the latest screenshot directory
$latestScreenshotDir = Get-ChildItem -Path $capturedScreenshotsBaseDir -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $latestScreenshotDir) {
    Write-Host "Error: No screenshot directories found in '$capturedScreenshotsBaseDir'." -ForegroundColor Red
    exit 1
}

# Construct the path to screenshot_monitor1.png
$monitor1ScreenshotPath = Join-Path $latestScreenshotDir.FullName "screenshot_monitor1.png"

# Check if the screenshot for monitor 1 exists
if (-not (Test-Path $monitor1ScreenshotPath)) {
    Write-Host "Error: 'screenshot_monitor1.png' not found in the latest capture directory '$latestScreenshotDir.FullName'." -ForegroundColor Red
    exit 1
}

Write-Host "Opening '$monitor1ScreenshotPath' in Paint.NET..." -ForegroundColor Green

# Open the screenshot in Paint.NET
# Note: Directly controlling which monitor Paint.NET opens on is complex
# and often depends on Paint.NET's internal settings or last opened position.
# This command will simply open the file with Paint.NET.
Start-Process -FilePath $paintNetPath -ArgumentList "`"$monitor1ScreenshotPath`""

Write-Host "Script completed." -ForegroundColor Cyan
