# 📚 4_Formula: Guides & Best practices

## PowerShell Screenshot Scripts

This project contains several PowerShell scripts located in the `5_Symbols` folder for capturing and handling screenshots:

*   **`capture.ps1`**: Captures screenshots of all monitors, both combined and individually. It saves them to a timestamped folder in `3_UI/CapturedScreenshots` and copies each capture to the clipboard.
*   **`open_paintnet_screenshot.ps1`**: Opens the last 5 captured monitor screenshots in Paint.NET.
*   **`open_paintnet_clipboard.ps1`**: Opens the current image from the clipboard in Paint.NET.

---

## Limitations of Controlling GUI Image Editors

### The Challenge

When automating workflows that involve image editors, it is often desirable to launch the editor with specific settings pre-configured (e.g., a certain brush, color, or tool selected).

### Research Findings

Research into popular desktop and online image editors has shown that this is generally **not possible** through simple scripting or command-line arguments.

*   **Desktop Applications (e.g., Paint.NET, GIMP, Photoshop, Krita):** Their command-line interfaces are designed for file-level operations (like opening, converting, or printing) and automated batch processing, not for controlling the interactive state of the GUI. Settings like brush size, color, and selected tool are meant to be controlled by the user *within* the application.

*   **Online Editors (e.g., Photopea, Pixlr):** Similarly, these web applications do not expose their internal state, such as tool settings, through URL parameters.

### Conclusion

Directly launching a graphical image editor with pre-configured interactive tools (like a specific brush and color) is not a feasible goal for simple scripting. More complex solutions, such as fragile UI automation (simulating mouse clicks and keystrokes), would be required, and are not recommended for reliable automation.