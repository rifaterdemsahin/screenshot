Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

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
# Ensure System.Windows.Forms is loaded for Clipboard access
if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.Location -like "*System.Windows.Forms.dll*" })) {
    Add-Type -AssemblyName System.Windows.Forms
}

while ($timeWaited -lt $clipboardTimeout) {
    # It's important to clear any non-image content that might be stuck
    # and then check again, or ensure we only check for image content.
    # ContainsImage() does this check, so just retry is fine.
    if ([System.Windows.Forms.Clipboard]::ContainsImage()) {
        $imageInClipboard = $true
        break
    }
    Start-Sleep -Seconds $sleepInterval
    $timeWaited += $sleepInterval
}

if ($imageInClipboard) {
    Write-Host "Image detected in clipboard. Opening in Paint.NET..." -ForegroundColor Green
    # Execute the open_paintnet_clipboard.ps1 script
    & "C:\projects\screenshot\5_Symbols\open_paintnet_clipboard.ps1"
} else {
    Write-Host "Timeout: No image detected in clipboard after $clipboardTimeout seconds. Paint.NET will not be opened." -ForegroundColor Red
}

Write-Host "Orchestration script completed." -ForegroundColor Cyan