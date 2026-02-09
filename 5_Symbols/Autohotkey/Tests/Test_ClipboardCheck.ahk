; Test Script to verify Clipboard Image Detection and Saving using PowerShell
#Requires AutoHotkey v2.0

TestImageSave() {
    MsgBox("Please copy an image to your clipboard now (e.g. Win+Shift+S), then click OK.")
    
    ; Step 1: Check if clipboard has image data
    ; CF_BITMAP = 2, CF_DIB = 8
    hasImage := DllCall("IsClipboardFormatAvailable", "UInt", 2)
    
    if (hasImage) {
        MsgBox("Success: Image detected in clipboard (CF_BITMAP).")
    } else {
        MsgBox("Failure: No image detected in clipboard.")
        ExitApp()
    }

    ; Step 2: Try to save it using PowerShell
    TempFile := A_Temp . "\test_clipboard_" . A_TickCount . ".png"
    
    ; Construct PowerShell command
    ; We use System.Windows.Forms to be robust across PS versions if needed, but Get-Clipboard is standard in 5.1
    psScript := "powershell -NoProfile -Command `"$img = Get-Clipboard -Format Image; if ($img) { $img.Save('" . TempFile . "') } else { exit 1 }`""
    
    try {
        RunWait(psScript,, "Hide")
        
        if (FileExist(TempFile)) {
            MsgBox("Success: Image saved to " . TempFile)
            Run(TempFile) ; Open to verify
        } else {
            MsgBox("Failure: File was not created by PowerShell.")
        }
    } catch as e {
        MsgBox("Error running PowerShell: " . e.Message)
    }
}

TestImageSave()
