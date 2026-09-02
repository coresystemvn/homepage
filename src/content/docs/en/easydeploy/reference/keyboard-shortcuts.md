---
title: 'Keyboard Shortcuts in WinPE'
---

All actions on the EASYDEPLOY interface have keyboard shortcuts. You can use the **on-screen buttons** or press the corresponding **hotkey**.

## 1. OS Deployment Flows

| Shortcut | Function |
|------|-----------|
| **1** / NumPad1 | Launch Vanilla flow (SETUP WINDOWS [DEFAULT]) — Deploy a clean default Windows image (no profile applied) |
| **2** / NumPad2 | Launch Business flow (SETUP WINDOWS [BUSINESS]) — Deploy Windows with enterprise configuration (with profile) |
| **F3** | Launch Express install flow (F3) — Only available when `"enableF3Express": true` is set in `user-config.json` |

## 2. System Rescue Tools

| Shortcut | UI Button | Tool / Function |
|------|-----|---------|
| **F1** | — | Launch BitLocker tool — Unlock and access encrypted partitions in WinPE |
| **F2** | — | Launch WiFi configuration — Set up wireless network connection in WinPE |
| **F4** | — | Open Notepad text editor |
| **F5** | — | Open Diskpart disk partitioning tool (CLI) |
| **F6** | — | Open PowerShell command-line environment (CLI) |
| **F7** | DISK BACKUP | Launch MultiDrive partition backup and restore tool |
| **F8** | FILE EXPLORER | Launch Explorer++ file manager for data rescue |
| **F9** | HARDWARE INFO | Launch the HWiNFO64 hardware diagnostics tool |
| **F10** | WEB BROWSER | Launch Pale Moon rescue web browser |

## 3. Other System Functions

| Shortcut | Function |
|------|-----------|
| **F11** | Open About dialog — Display application version and license status |
| **F12** | Safely power off the device |

:::note
Tools **F7–F10** are Portable applications located in `Softwares\` on the USB (not included in the release package — add them via BootBuilder or a manual copy + `user-config.json`). They are routed via `toolPaths` in `system-config.json`. If the files are missing, the corresponding hotkey won't work. The 4 buttons are just quick-launch slots — footer labels and hotkeys adjust automatically to your configuration; tool count is unlimited, launch extras via F6 (PowerShell)/F8 (Explorer)/cmd. See [Configuration](/en/easydeploy/reference/configuration/) for details.

**F1** (BitLocker) and **F2** (WiFi) are built into the core and **always available**. F2 has a **3-second** cooldown and will warn if a wired LAN connection is active.
:::
