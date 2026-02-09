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
    $process = Start-Process -FilePath $paintNetPath -ArgumentList "`"$tempFilePath`"" -PassThru
    # Give Paint.NET some time to open and load the image
    Start-Sleep -Seconds 2 # Adjust this delay as needed

    # Send keystrokes: '4', '0', and '['
    # '{LEFTBRACKET}' is the SendKeys code for the '[' character.
    # Note: SendKeys can be unreliable and depends on Paint.NET being the active window and ready to receive input.
    Write-Host "Sending keystrokes '4', '0', '[' to Paint.NET..." -ForegroundColor DarkYellow
    [System.Windows.Forms.SendKeys]::SendWait("40{[}")

} else {
    Write-Host "Error: Clipboard does not contain an image." -ForegroundColor Red
    exit 1
}

Write-Host "Script completed." -ForegroundColor Cyan