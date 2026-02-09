Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Path to Paint.NET executable
$paintNetPath = "C:\Program Files\Paint.NET\PaintDotNet.exe"

# Temporary directory for saving clipboard images
$tempDir = Join-Path $env:TEMP "PaintNetClipboard"
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

# Check if Paint.NET exists
if (-not (Test-Path $paintNetPath)) {
    Write-Host "Error: Paint.NET not found at '$paintNetPath'." -ForegroundColor Red
    Write-Host "Please ensure Paint.NET is installed or update the '$paintNetPath' variable in the script." -ForegroundColor Red
    exit 1
}

# Check if clipboard contains an image
if ([System.Windows.Forms.Clipboard]::ContainsImage()) {
    Write-Host "Clipboard contains an image. Saving to temporary file..." -ForegroundColor Green
    $image = [System.Windows.Forms.Clipboard]::GetImage()

    # Generate a unique temporary filename
    $tempFileName = "clipboard_image_$(Get-Date -Format 'yyyyMMddHHmmssfff').png"
    $tempFilePath = Join-Path $tempDir $tempFileName

    $image.Save($tempFilePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $image.Dispose() # Dispose of the image object

    Write-Host "Temporary image saved to '$tempFilePath'." -ForegroundColor DarkGreen
    Write-Host "Opening '$tempFilePath' in Paint.NET..." -ForegroundColor Green

    # Open the temporary image in Paint.NET
    Start-Process -FilePath $paintNetPath -ArgumentList "`"$tempFilePath`""

    # Optionally, you might want to delete the temporary file after Paint.NET is opened.
    # However, Paint.NET might hold a lock on the file.
    # For simplicity, we'll leave it for now or delete it after a short delay.
    # A more robust solution might involve monitoring the Paint.NET process.
    # For now, files in TEMP are typically cleaned up by the system over time.
    # You could add a 'Remove-Item $tempFilePath -Force' here if you're sure Paint.NET won't lock it.

} else {
    Write-Host "Error: Clipboard does not contain an image." -ForegroundColor Red
    exit 1
}

Write-Host "Script completed." -ForegroundColor Cyan
