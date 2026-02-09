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
    MsgBox(16, "Paint.NET Not Found", "Paint.NET not found at:`n" . PAINTNET_PATH . "`n`nPlease install Paint.NET or update the path in the script.")
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
            MsgBox(48, "Timeout", "No image detected in clipboard after 30 seconds.")
            return
        }
        
        TempFilePath := TEMP_DIR . "\clipboard_image_" . FormatTime(A_Now, "yyyyMMddHHmmssfff") . ".png"

        ToolTip("Step 3/4: Saving Image`nSaving clipboard image to temporary file...")
        try {
            A_Clipboard.Save(TempFilePath)
        } catch {
            ToolTip()
            MsgBox(16, "Error", "Failed to save image from clipboard!")
            return
        }
        
        if (!FileExist(TempFilePath)) {
            ToolTip()
            MsgBox(16, "Error", "Saved image file not found: " . TempFilePath)
            return
        }

        ToolTip("Step 4/4: Opening Paint.NET`nOpening Paint.NET with the image and sending keystrokes...")
        OpenPaintNET(PAINTNET_PATH, TempFilePath)
        Sleep(3000) ; Give Paint.NET time to open and load the image and activate

        SendCustomKeystrokes()
        
        ToolTip()
        MsgBox(64, "Success!", "Paint.NET automation completed successfully!")

        ; Optional: Clean up temporary file
        ; FileDelete(TempFilePath)
    }
    catch as e {
        ToolTip()
        MsgBox(16, "Error", "An error occurred:`n" . e.Message)
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
        if (A_Clipboard.HasImage) {
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
        Run("""" . paintNetPath . """ """ . imagePath . """")
    } catch as e {
        throw Error("Failed to open Paint.NET: " . e.Message)
    }
}

; Send the custom keystroke sequence
SendCustomKeystrokes() {
    ; Send ']' 40 times, then 'X', and 'D'
    Send("{] 40}XD")
}