; AutoHotkey v2.0 Script - Paint.NET Clipboard Automation
; Hotkey: Ctrl + Alt + 8
; Simple and reliable - no complex string issues

#Requires AutoHotkey v2.0

^!8::MainScript()

MainScript() {
    ; Path to Paint.NET executable
    PaintNetPath := "C:\Program Files\Paint.NET\PaintDotNet.exe"

    ; Check if Paint.NET exists
    if (!FileExist(PaintNetPath)) {
        MsgBox("Paint.NET not found at " PaintNetPath "`n"
                           . "Please ensure Paint.NET is installed or update the 'PaintNetPath' variable in the script.", "Error", 48)
        return
    }

    TempDir := A_Temp
    FileName := "clipboard_" A_Now ".png"
    FilePath := TempDir "\" FileName
    
    ; Step 1: Screenshot
    ToolTip("Step 1: Triggering Screenshot Tool (Win + Shift + S)")
    Send("#+" "s") ; Simulate Win + Shift + S
    Sleep(1000) ; Give time for the Snipping Tool to activate
    
    ; Step 2: Wait for clipboard to contain an image
    ; Step 2: Wait for clipboard to contain an image (Standard Bitmap Format CF_BITMAP = 2)
    ToolTip("Step 2: Waiting for image in clipboard...")
    Loop 60 { ; Max 30 seconds
        if (DllCall("IsClipboardFormatAvailable", "UInt", 2)) {
            break
        }
        Sleep(500)
        if (A_Index >= 60) {
            ToolTip()
            MsgBox("No image in clipboard after 30 seconds!", "Timeout", 48)
            return
        }
    }
    
    ; Step 3: Save image from clipboard using PowerShell (AHK v2 Native handling is complex without GDI+)
    ToolTip("Step 3: Saving image from clipboard...")
    try {
        ; PowerShell command to save clipboard image
        psScript := "powershell -NoProfile -Command `"Add-Type -AssemblyName System.Drawing; $img = Get-Clipboard -Format Image; if ($img) { $img.Save('" . FilePath . "', [System.Drawing.Imaging.ImageFormat]::Png) }`""
        RunWait(psScript,, "Hide")
    } catch {
        ToolTip()
        MsgBox("Failed to save image from clipboard using PowerShell!", "Error", 16)
        return
    }
    
    if (!FileExist(FilePath)) {
        ToolTip()
        MsgBox("Saved image file not found: " FilePath, "Error", 16)
        return
    }
    
    ; Step 4: Open Paint.NET
    ToolTip("Step 4: Opening Paint.NET...")
    Run('"' . PaintNetPath . '" "' . FilePath . '"')
    Sleep(4000) ; Give Paint.NET time to open and load the image
    
    ; Step 5: Send keystrokes
    ToolTip("Step 5: Sending keystrokes...")
    SendPaintNetKeystrokes()
    
    ToolTip()
    MsgBox("Done!", "Complete", 64)
    
    ; Clean up temporary file - this might fail if Paint.NET locks the file
    ; For robust cleanup, consider monitoring Paint.NET process or using a different temp file strategy.
    ; FileDelete(FilePath)
}

SendPaintNetKeystrokes() {
    ; Send ']' 40 times, then 'X', and 'D'
    ; '{] 40}' is the SendKeys code for sending ']' 40 times.
    ; 'X' swaps foreground/background colors. 'D' resets colors to default.
    Send("{] 40}XD")
}