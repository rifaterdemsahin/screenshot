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

---

## How to Open Latest Screenshot in Paint.NET

The `open_paintnet_screenshot.ps1` script is a PowerShell script designed to automatically find the most recently captured `screenshot_monitor1.png` and open it using Paint.NET.

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
*   The script attempts to open `screenshot_monitor1.png`. If you wish to open a different monitor's screenshot, you will need to manually edit the script to change `"screenshot_monitor1.png"` to, for example, `"screenshot_monitor2.png"`.
*   The script does not explicitly control which monitor Paint.NET opens on. Paint.NET typically opens on the primary monitor or where it was last opened.