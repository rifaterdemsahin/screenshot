Write-Host "Starting screenshot capture..." -ForegroundColor Cyan
# Execute the capture.ps1 script
& "C:\projects\screenshot\5_Symbols\capture.ps1"

Write-Host "Screenshot capture complete. Waiting for 10 seconds before opening in Paint.NET..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "Opening clipboard image in Paint.NET..." -ForegroundColor Cyan
# Execute the open_paintnet_clipboard.ps1 script
& "C:\projects\screenshot\5_Symbols\open_paintnet_clipboard.ps1"

Write-Host "Orchestration script completed." -ForegroundColor Green
