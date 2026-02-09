Here's the updated script that creates a timestamped folder and saves all screenshots inside:

```powershell
$code = @'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$baseDir = 'C:\projects\screenshots'
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
$left = ([System.Windows.Forms.Screen]::AllScreens | Measure-Object -Property Bounds.X -Minimum).Minimum
$top = ([System.Windows.Forms.Screen]::AllScreens | Measure-Object -Property Bounds.Y -Minimum).Minimum
$right = ([System.Windows.Forms.Screen]::AllScreens | Measure-Object -Property Bounds.Right -Maximum).Maximum
$bottom = ([System.Windows.Forms.Screen]::AllScreens | Measure-Object -Property Bounds.Bottom -Maximum).Maximum

$bitmap = New-Object System.Drawing.Bitmap($right - $left, $bottom - $top)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($left, $top, 0, 0, $bitmap.Size)
$bitmap.Save("$dir\screenshot_all.png")
$graphics.Dispose()
$bitmap.Dispose()
Write-Host "OK - All monitors: screenshot_all.png" -ForegroundColor Green

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
    $gfx.Dispose()
    $bmp.Dispose()
    Write-Host "OK - Monitor $($i+1): screenshot_monitor$($i+1).png" -ForegroundColor Green
}

Write-Host ""
Write-Host "All screenshots saved to: $dir" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
'@

$code | Out-File "C:\projects\screenshots\capture.ps1" -Encoding utf8 -Force
Write-Host "Script ready. Run: powershell -ExecutionPolicy Bypass -File 'C:\projects\screenshots\capture.ps1'"
```

Now run:

```powershell
powershell -ExecutionPolicy Bypass -File "C:\projects\screenshots\capture.ps1"
```

It will create a folder like `C:\projects\screenshots\2026-02-09_06-15-30\` with all screenshots inside.
