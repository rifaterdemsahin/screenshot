# 💻 5_Symbols: Implementation & Code

**Premise:** Where theory becomes reality.
**Content:** The core application source code (Vite + React).
**Conclusion:** The heart of the project.

---

## How to Run the Screenshot Capture Script

The `capture.ps1` script is a PowerShell script designed to capture screenshots of all connected monitors, both combined and individually.

### Prerequisites

*   Windows Operating System
*   PowerShell 5.1 or later

### Execution Steps

1.  **Open PowerShell:** Open a PowerShell terminal (e.g., by searching for "PowerShell" in the Start Menu).

2.  **Navigate to the Script Directory:**
    ```powershell
    Set-Location -Path "C:\projects\screenshot\5_Symbols"
    ```

3.  **Run the Script:**
    To run the script, you might need to bypass the execution policy for local scripts.
    ```powershell
    powershell -ExecutionPolicy Bypass -File .\capture.ps1
    ```

    Alternatively, if your execution policy allows it, you can just run:
    ```powershell
    .\capture.ps1
    ```

### Output

The script will:
*   Create a timestamped directory (e.g., `2026-02-09_09-58-50`) inside `C:\projects\screenshot\3_UI\CapturedScreenshots`.
*   Save `screenshot_all.png` (a combined image of all monitors) and `screenshot_monitorN.png` (individual screenshots for each monitor) within this timestamped directory.
*   **Copy each captured screenshot to the clipboard sequentially.** The last individual screenshot captured will remain in the clipboard after the script finishes.

---

## How to Open Latest Screenshots in Paint.NET

The `open_paintnet_screenshot.ps1` script is a PowerShell script designed to automatically find the most recently captured set of monitor screenshots and open up to the first 5 individual `screenshot_monitorN.png` files (where N is from 1 to 5) using Paint.NET.

### Prerequisites

*   Windows Operating System
*   PowerShell 5.1 or later
*   Paint.NET installed (default path assumed: `C:\Program Files\Paint.NET\PaintDotNet.exe`)

### Execution Steps

1.  **Open PowerShell:** Open a PowerShell terminal.

2.  **Navigate to the Script Directory:**
    ```powershell
    Set-Location -Path "C:\projects\screenshot\5_Symbols"
    ```

3.  **Run the Script:**
    ```powershell
    powershell -ExecutionPolicy Bypass -File .\open_paintnet_screenshot.ps1
    ```

### Notes

*   If Paint.NET is not found at the default path, you may need to edit the `$paintNetPath` variable within `open_paintnet_screenshot.ps1`.
*   The script will attempt to open `screenshot_monitor1.png` through `screenshot_monitor5.png`. If a specific monitor screenshot is not found (e.g., if you have fewer than 5 monitors or the file was not captured), it will be skipped.
*   The script does not explicitly control which monitor Paint.NET opens on. Paint.NET typically opens on the primary monitor or where it was last opened.



---

## How to Capture Selection and Open in Paint.NET

The `screenshot_and_edit.ps1` script orchestrates capturing a screen selection and subsequent opening of that selection in Paint.NET. It first triggers the Windows Snipping Tool shortcut (`Win + Shift + S`), waits for the user to make a selection (which places an image on the clipboard), then saves the clipboard image to a temporary file, launches Paint.NET with this temporary file, and finally sends a sequence of keystrokes to Paint.NET.

### Prerequisites

*   Windows Operating System
*   PowerShell 5.1 or later
*   Paint.NET installed (default path assumed: `C:\Program Files\Paint.NET\PaintDotNet.exe`)
*   User interaction required for screen selection.

### Execution Steps

1.  **Open PowerShell:** Open a PowerShell terminal.

2.  **Navigate to the Script Directory:**
    ```powershell
    Set-Location -Path "C:\projects\screenshot\5_Symbols"
    ```

3.  **Run the Script:**
    ```powershell
    powershell -ExecutionPolicy Bypass -File .\screenshot_and_edit.ps1
    ```

### Notes

*   This script now relies on the user making a screen selection after `Win + Shift + S` is triggered.
*   The script waits for a maximum of 30 seconds for an image to appear in the clipboard. If no selection is made within this time, Paint.NET will not be opened.
*   **Reliability:** Triggering `Win + Shift + S` programmatically can sometimes be unreliable. Also, the keystroke sending functionality within `open_paintnet_clipboard.ps1` remains subject to the same reliability concerns as documented in its own section.
*   The `capture.ps1` script (for full screen captures) is no longer called by this orchestration script.