Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Drawing; // Added for ImageFormat

public class Keyboard
{
    [DllImport("user32.dll")]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

    public const byte VK_LWIN = 0x5B; // Left Windows key
    public const byte VK_SHIFT = 0x10; // Shift key
    public const byte VK_S = 0x53; // 'S' key

    public const uint KEYEVENTF_EXTENDEDKEY = 0x0001;
    public const uint KEYEVENTF_KEYUP = 0x0002;

    public static void PressKey(byte keyCode)
    {
        keybd_event(keyCode, 0, 0, UIntPtr.Zero); // Key down
    }

    public static void ReleaseKey(byte keyCode)
    {
        keybd_event(keyCode, 0, KEYEVENTF_KEYUP, UIntPtr.Zero); // Key up
    }
}
"@

# Ensure System.Windows.Forms and System.Drawing are loaded for Clipboard access and image manipulation
if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.Location -like "*System.Windows.Forms.dll*" })) {
    Add-Type -AssemblyName System.Windows.Forms
}
if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.Location -like "*System.Drawing.dll*" })) {
    Add-Type -AssemblyName System.Drawing
}

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

Write-Host "Triggering 'Win + Shift + S' to activate screen selection. Please make your selection..." -ForegroundColor Cyan

# Press Win + Shift + S
[Keyboard]::PressKey([Keyboard]::VK_LWIN)
[Keyboard]::PressKey([Keyboard]::VK_SHIFT)
[Keyboard]::PressKey([Keyboard]::VK_S)

# Release keys in reverse order
[Keyboard]::ReleaseKey([Keyboard]::VK_S)
[Keyboard]::ReleaseKey([Keyboard]::VK_SHIFT)
[Keyboard]::ReleaseKey([Keyboard]::VK_LWIN)

Write-Host "Waiting for an image to appear in the clipboard (max 30 seconds)..." -ForegroundColor Yellow

$clipboardTimeout = 30 # seconds
$sleepInterval = 0.5 # seconds
$timeWaited = 0

$imageInClipboard = $false

while ($timeWaited -lt $clipboardTimeout) {
    if ([System.Windows.Forms.Clipboard]::ContainsImage()) {
        $imageInClipboard = $true
        break
    }
    Start-Sleep -Seconds $sleepInterval
    $timeWaited += $sleepInterval
}

if ($imageInClipboard) {
    Write-Host "Image detected in clipboard. Saving to temporary file and opening in Paint.NET..." -ForegroundColor Green

    $image = [System.Windows.Forms.Clipboard]::GetImage()

    # Generate a unique temporary filename
    $tempFileName = "clipboard_image_$(Get-Date -Format 'yyyyMMddHHmmssfff').png"
    $tempFilePath = Join-Path $tempDir $tempFileName

    $image.Save($tempFilePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $image.Dispose() # Dispose of the image object

    Write-Host "Temporary image saved to '$tempFilePath'." -ForegroundColor DarkGreen

    # Open the temporary image in Paint.NET
    $process = Start-Process -FilePath $paintNetPath -ArgumentList "`"$tempFilePath`"" -PassThru
    # Give Paint.NET some time to open and load the image
    Start-Sleep -Seconds 2 # Adjust this delay as needed

    # Send keystrokes: ']' 40 times, then 'X', and 'D'
    Write-Host "Sending keystrokes '] 40 times', 'X', 'D' to Paint.NET..." -ForegroundColor DarkYellow
    [System.Windows.Forms.SendKeys]::SendWait("{] 40}XD")

} else {
    Write-Host "Timeout: No image detected in clipboard after $clipboardTimeout seconds. Paint.NET will not be opened." -ForegroundColor Red
}

Write-Host "Orchestration script completed." -ForegroundColor Cyan
