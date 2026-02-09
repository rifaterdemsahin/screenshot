Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$baseDir = 'C:\projects\screenshot\3_UI\CapturedScreenshots'
$dir = Join-Path $baseDir $timestamp

# Create timestamped directory
New-Item -ItemType Directory -Path $dir -Force | Out-Null

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Multi-Monitor Screenshot Capture" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Saving to: $dir" -ForegroundColor Yellow
Write-Host ""

# Capture all monitors combined
Write-Host "Capturing all monitors combined..." -ForegroundColor Yellow

$minX = $minY = [int]::MaxValue
$maxX = $maxY = [int]::MinValue

foreach ($screen in [System.Windows.Forms.Screen]::AllScreens) {
    if ($screen.Bounds.X -lt $minX) { $minX = $screen.Bounds.X }
    if ($screen.Bounds.Y -lt $minY) { $minY = $screen.Bounds.Y }
    if ($screen.Bounds.Right -gt $maxX) { $maxX = $screen.Bounds.Right }
    if ($screen.Bounds.Bottom -gt $maxY) { $maxY = $screen.Bounds.Bottom }
}

$totalWidth = $maxX - $minX
$totalHeight = $maxY - $minY

if ($totalWidth -le 0 -or $totalHeight -le 0) {
    Write-Host "Error: Could not determine valid combined screen dimensions. Skipping combined screenshot." -ForegroundColor Red
} else {
    $bitmap = New-Object System.Drawing.Bitmap($totalWidth, $totalHeight)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    # The CopyFromScreen source coordinates are relative to the top-left of the virtual screen
    $graphics.CopyFromScreen($minX, $minY, 0, 0, $bitmap.Size)
    $bitmap.Save("$dir\screenshot_all.png")
    # Copy combined screenshot to clipboard
    [System.Windows.Forms.Clipboard]::SetImage($bitmap)
    Write-Host "Combined screenshot copied to clipboard." -ForegroundColor DarkGreen
    $graphics.Dispose()
    $bitmap.Dispose()
    Write-Host "OK - All monitors: screenshot_all.png" -ForegroundColor Green
}

Write-Host ""
Write-Host "Capturing individual monitors..." -ForegroundColor Yellow

# Capture each monitor separately
$screens = [System.Windows.Forms.Screen]::AllScreens
for ($i = 0; $i -lt $screens.Count; $i++) {
    $screen = $screens[$i]
    $bmp = New-Object System.Drawing.Bitmap($screen.Bounds.Width, $screen.Bounds.Height)
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $gfx.CopyFromScreen($screen.Bounds.Location, [System.Drawing.Point]::Empty, $screen.Bounds.Size)
    $bmp.Save("$dir\screenshot_monitor$($i+1).png")
    # Copy individual screenshot to clipboard
    [System.Windows.Forms.Clipboard]::SetImage($bmp)
    Write-Host "Monitor $($i+1) screenshot copied to clipboard." -ForegroundColor DarkGreen
    $gfx.Dispose()
    $bmp.Dispose()
    Write-Host "OK - Monitor $($i+1): screenshot_monitor$($i+1).png" -ForegroundColor Green
}

Write-Host ""
Write-Host "All screenshots saved to: $dir" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
