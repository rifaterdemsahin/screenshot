; AutoHotkey v2.0 Script - Paint.NET Clipboard Automation (Simplified Version)
; This script captures a screenshot, waits for clipboard, opens Paint.NET, and sends keystrokes

#Requires AutoHotkey v2.0

; ===== CONFIGURATION =====
PAINTNET_PATH := "C:\Program Files\Paint.NET\PaintDotNet.exe"
TEMP_DIR := A_Temp . "\PaintNetClipboard"
CLIPBOARD_TIMEOUT := 30000  ; 30 seconds in milliseconds

; ===== SETUP =====
; Create temp directory
if (!DirExist(TEMP_DIR)) {
    DirCreate(TEMP_DIR)
}

; Verify Paint.NET installation
if (!FileExist(PAINTNET_PATH)) {
    MsgBox("Paint.NET not found at:`n" . PAINTNET_PATH, "Error", 16)
    ExitApp(1)
}

; ===== MAIN EXECUTION =====
ShowStatus("Step 1: Capturing Screenshot", "Triggering Win + Shift + S...")
TriggerScreenCapture()

ShowStatus("Step 2: Waiting for Clipboard", "Waiting for image (max 30 seconds)...")
if (!WaitForClipboardImage(CLIPBOARD_TIMEOUT)) {
    MsgBox("No image detected in clipboard after 30 seconds.", "Timeout", 48)
    ExitApp(1)
}

TempFilePath := TEMP_DIR . "\clipboard_image_" . FormatTime(A_Now, "yyyyMMddHHmmssfff") . ".png"

ShowStatus("Step 3: Saving Image", "Saving clipboard image to temporary file...")
try {
    psScript := "powershell -NoProfile -Command `"Add-Type -AssemblyName System.Drawing; $img = Get-Clipboard -Format Image; if ($img) { $img.Save('" . TempFilePath . "', [System.Drawing.Imaging.ImageFormat]::Png) }`""
    RunWait(psScript,, "Hide")
} catch {
    MsgBox("Failed to save image from clipboard!", "Error", 16)
    ExitApp(1)
}

if (!FileExist(TempFilePath)) {
    MsgBox("Saved image file not found: " . TempFilePath, "Error", 16)
    ExitApp(1)
}

ShowStatus("Step 4: Opening Paint.NET", "Opening Paint.NET with the image...")
OpenPaintNET(PAINTNET_PATH, TempFilePath)

ShowStatus("Step 5: Sending Keystrokes", "Sending ] x40, X, D...")
Sleep(3000)  ; Wait for Paint.NET to fully load and activate
SendCustomKeystrokes()

ShowStatus("Complete!", "All steps completed successfully!", 2000)
ExitApp(0)

; ===== FUNCTIONS =====

; Display status message (using ToolTip for less interruption)
ShowStatus(title, message, duration := 0) {
    ToolTip(title . "`n" . message)
    if (duration > 0) {
        Sleep(duration)
        ToolTip()
    }
}

; Trigger Win + Shift + S screenshot tool
TriggerScreenCapture() {
    Send("#+" . "s")
    Sleep(500)
}

; Wait for image to appear in clipboard
WaitForClipboardImage(timeout) {
    startTime := A_TickCount
    
    loop {
        if (DllCall("IsClipboardFormatAvailable", "UInt", 2)) {
            return true
        }
        
        if (A_TickCount - startTime >= timeout) {
            return false
        }
        
        Sleep(500)
    }
}

; Open Paint.NET with image file
OpenPaintNET(paintNetPath, imagePath) {
    try {
        Run('"' . paintNetPath . '" "' . imagePath . '"')
    } catch as e {
        MsgBox("Failed to open Paint.NET:`n" . e.Message, "Error", 16)
        ExitApp(1)
    }
}

; Send the custom keystroke sequence
SendCustomKeystrokes() {
    ; Send ']' 40 times, then 'X', and 'D'
    Send("{] 40}XD")
}