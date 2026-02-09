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
        MsgBox(48, "Error", "Paint.NET not found at " PaintNetPath "`n"
                           . "Please ensure Paint.NET is installed or update the 'PaintNetPath' variable in the script.")
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
    ToolTip("Step 2: Waiting for image in clipboard...")
    Loop 60 { ; Max 30 seconds (60 * 500ms)
        if (A_Clipboard.HasImage) {
            break
        }
        Sleep(500)
        if (A_Index >= 60) {
            ToolTip()
            MsgBox(48, "Timeout", "No image in clipboard after 30 seconds!")
            return
        }
    }
    
    ; Step 3: Save image from clipboard
    ToolTip("Step 3: Saving image from clipboard...")
    try {
        A_Clipboard.Save(FilePath)
    } catch {
        ToolTip()
        MsgBox(16, "Error", "Failed to save image from clipboard!")
        return
    }
    
    if (!FileExist(FilePath)) {
        ToolTip()
        MsgBox(16, "Error", "Saved image file not found: " FilePath)
        return
    }
    
    ; Step 4: Open Paint.NET
    ToolTip("Step 4: Opening Paint.NET...")
    Run(PaintNetPath " " FilePath)
    Sleep(4000) ; Give Paint.NET time to open and load the image
    
    ; Step 5: Send keystrokes
    ToolTip("Step 5: Sending keystrokes...")
    SendPaintNetKeystrokes()
    
    ToolTip()
    MsgBox(64, "Complete", "Done!")
    
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