; AutoHotkey v2.0 Script - Paint.NET Clipboard Automation
; Hotkey: Ctrl + Alt + 8
; This script captures a screenshot, waits for clipboard, opens Paint.NET, and sends keystrokes

#Requires AutoHotkey v2.0

; ===== CONFIGURATION =====
PAINTNET_PATH := "C:\Program Files\Paint.NET\PaintDotNet.exe"
TEMP_DIR := A_Temp . "\PaintNetClipboard"
CLIPBOARD_TIMEOUT := 30000  ; 30 seconds in milliseconds

; ===== HOTKEY DEFINITION =====
^!8:: {
    RunPaintNetAutomation()
}

; ===== SETUP =====
; Create temp directory
if (!DirExist(TEMP_DIR)) {
    DirCreate(TEMP_DIR)
}

; Verify Paint.NET installation
if (!FileExist(PAINTNET_PATH)) {
    MsgBox("Paint.NET not found at:`n" . PAINTNET_PATH . "`n`nPlease install Paint.NET or update the path in the script.", "Paint.NET Not Found", 16)
    ExitApp(1)
}

; ===== MAIN EXECUTION FUNCTION =====
RunPaintNetAutomation() {
    try {
        ToolTip("Step 1/4: Capturing Screenshot`nTriggering Win + Shift + S...")
        TriggerScreenCapture()
        Sleep(500) ; Give time for the Snipping Tool to activate

        ToolTip("Step 2/4: Waiting for Clipboard`nWaiting for image (max 30 seconds)...")
        if (!WaitForClipboardImage(CLIPBOARD_TIMEOUT)) {
            ToolTip()
            MsgBox("No image detected in clipboard after 30 seconds.", "Timeout", 48)
            return
        }
        
        TempFilePath := TEMP_DIR . "\clipboard_image_" . FormatTime(A_Now, "yyyyMMddHHmmssfff") . ".png"

        ToolTip("Step 3/4: Saving Image`nSaving clipboard image to temporary file...")
        try {
            psScript := "powershell -NoProfile -Command `"Add-Type -AssemblyName System.Drawing; $img = Get-Clipboard -Format Image; if ($img) { $img.Save('" . TempFilePath . "', [System.Drawing.Imaging.ImageFormat]::Png) }`""
            RunWait(psScript,, "Hide")
        } catch {
            ToolTip()
            MsgBox("Failed to save image from clipboard!", "Error", 16)
            return
        }
        
        if (!FileExist(TempFilePath)) {
            ToolTip()
            MsgBox("Saved image file not found: " . TempFilePath, "Error", 16)
            return
        }

        ToolTip("Step 4/4: Opening Paint.NET`nOpening Paint.NET with the image and sending keystrokes...")
        OpenPaintNET(PAINTNET_PATH, TempFilePath)
        Sleep(3000) ; Give Paint.NET time to open and load the image and activate

        SendCustomKeystrokes()
        
        ToolTip()
        MsgBox("Paint.NET automation completed successfully!", "Success!", 64)

        ; Optional: Clean up temporary file
        ; FileDelete(TempFilePath)
    }
    catch as e {
        ToolTip()
        MsgBox("An error occurred:`n" . e.Message, "Error", 16)
    }
}

; ===== FUNCTIONS =====

; Trigger Win + Shift + S screenshot tool
TriggerScreenCapture() {
    Send("#+" . "s")
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
        throw Error("Failed to open Paint.NET: " . e.Message)
    }
}

; Send the custom keystroke sequence
SendCustomKeystrokes() {
    ; Send ']' 40 times, then 'X', and 'D'
    Send("{] 40}XD")
}