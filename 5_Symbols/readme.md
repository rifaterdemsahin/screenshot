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
*   Create a timestamped directory (e.g., `2026-02-09_09-58-50`) inside `C:\projects\screenshot\7_Testing\CapturedScreenshots`.
*   Save `screenshot_all.png` (a combined image of all monitors) and `screenshot_monitorN.png` (individual screenshots for each monitor) within this timestamped directory.
