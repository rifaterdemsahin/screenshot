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

## How to Open Clipboard Image in Paint.NET

The `open_paintnet_clipboard.ps1` script is a PowerShell script designed to check if the clipboard contains an image, save it temporarily, and then open that temporary image in Paint.NET.

### Functionality

Upon opening the image, the script will attempt to send the keystrokes ']' (40 times), 'X', and 'D' to Paint.NET.
*   Sending ']' 40 times is intended to significantly increase the brush size.
*   'X' is a common shortcut to swap the foreground and background colors.
*   'D' is typically used to reset the foreground and background colors to their defaults (black and white).

### Prerequisites

*   Windows Operating System
*   PowerShell 5.1 or later
*   Paint.NET installed (default path assumed: `C:\Program Files\Paint.NET\PaintDotNet.exe`)
*   An image copied to the clipboard.

### Execution Steps

1.  **Open PowerShell:** Open a PowerShell terminal.

2.  **Navigate to the Script Directory:**
    ```powershell
    Set-Location -Path "C:\projects\screenshot\5_Symbols"
    ```

3.  **Run the Script:**
    ```powershell
    powershell -ExecutionPolicy Bypass -File .\open_paintnet_clipboard.ps1
    ```

### Notes

*   **Reliability:** Sending keystrokes to an external application can be unreliable. The script includes a short delay to allow Paint.NET to load, but there's no guarantee Paint.NET will be fully ready or the active window when the keystrokes are sent.
*   If Paint.NET is not found at the default path, you may need to edit the `$paintNetPath` variable within `open_paintnet_clipboard.ps1`.
*   The script requires an image to be present in the clipboard to function.
*   Temporary files are created in `%TEMP%\PaintNetClipboard` and are not automatically deleted by the script.
