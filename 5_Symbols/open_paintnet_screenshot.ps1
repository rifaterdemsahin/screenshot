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

Write-Host "Attempting to open the last 5 monitor screenshots in Paint.NET..." -ForegroundColor Green

$foundAny = $false
for ($i = 1; $i -le 5; $i++) {
    $monitorScreenshotFileName = "screenshot_monitor$($i).png"
    $monitorScreenshotPath = Join-Path $latestScreenshotDir.FullName $monitorScreenshotFileName

    if (Test-Path $monitorScreenshotPath) {
        Write-Host "Opening '$monitorScreenshotPath'..." -ForegroundColor Green
        Start-Process -FilePath $paintNetPath -ArgumentList "`"$monitorScreenshotPath`""
        $foundAny = $true
    } else {
        Write-Host "Info: '$monitorScreenshotFileName' not found. Skipping." -ForegroundColor Yellow
    }
}

if (-not $foundAny) {
    Write-Host "Warning: No monitor screenshots (1-5) were found to open." -ForegroundColor Yellow
}

Write-Host "Script completed." -ForegroundColor Cyan