---
title: 'Rescue Tools'
---

The WinPE environment comes with integrated rescue tools. Access them via shortcut keys on the main interface.

## Shortcut Catalog

| Key | Tool | Function |
|------|---------|-----------|
| **F1** | BitLocker | Unlock encrypted partitions |
| **F2** | WiFi | Connect to wireless network |
| **F4** | Notepad | View/edit text files and logs |
| **F5** | Diskpart | Manage partitions (CLI) |
| **F6** | PowerShell | Administrative terminal |
| **F7** | DISK BACKUP | Back up/restore disks (MultiDrive) |
| **F8** | FILE EXPLORER | File management (Explorer++) |
| **F9** | HARDWARE INFO | Hardware diagnostics (HWiNFO64) |
| **F10** | WEB BROWSER | Web browsing (Pale Moon) |
| **F11** | About | Version + license status |
| **F12** | Shutdown | Power off |

:::note
Portable applications live in `Softwares\` on the USB — **they are not included in the release package**: add them via BootBuilder at build time, or copy them manually and declare them in `user-config.json` (see [Configuration](/en/easydeploy/reference/configuration/)). If a file is missing, the corresponding key won't work.
:::

:::note
**Why only 4 buttons?** EasyDeploy is, first and foremost, a **deployment** tool — rescue plays a supporting role. The main window reserves 4 quick-launch buttons for Portable Apps, and their labels plus footer hotkeys **adjust automatically to the tools you plug in** (via `toolPaths`/`portableApps`).

In practice, you can copy **as many tools as you like** onto the USB — anything beyond the 4 slots is a click away through **F6 (PowerShell)**, **F8 (Explorer)**, or cmd right inside WinPE.
:::

## Common Scenarios

### Recover Data When Windows Fails to Boot

Press **F8** (FILE EXPLORER) → access the data partition → copy files to an external USB.

If the partition does not appear, the drive letter may be hidden or the partition may be BitLocker-encrypted → use **F1** to unlock it first.

### Back Up / Restore an Entire Disk

Press **F7** (MultiDrive) → select **Backup Image** → choose source → choose destination → back up.

To restore: open MultiDrive → **Restore** → point to the image file.

:::danger
Restore will erase all data on the destination disk. Verify carefully before proceeding.
:::

### Unlock a BitLocker Partition

Press **F1** → select the locked partition → enter the 48-digit Recovery Key → **UNLOCK DRIVE**.

:::note
Repeated incorrect entries may permanently lock the partition. Verify the key before entering.
:::

### Connect to WiFi in WinPE

Press **F2** → **SCAN NETWORKS** → select SSID → enter password → **CONNECT**.

Verify connectivity: **F6** (PowerShell) → run `ipconfig` or `ping 8.8.8.8`.

:::tip
You can set a default WiFi in `system-config.json` so WinPE connects automatically on boot.
:::

### View Logs When Deployment Fails

Error logs are located at `[USB]:\EASYDEPLOY\Log\deploy-error-*.log`. Use **F8** to open the folder → **F4** to view contents. Look for `[STEP x/11] ... FAIL` or `[FATAL]`.

Runtime logs (before reboot): **F6** (PowerShell) → `Get-Content X:\deploy-log.txt`.

### Manage Partitions Manually

Press **F5** (Diskpart) → `list disk` → `select disk N` → `clean` or `create partition`.

:::danger
The `clean` command permanently erases all data on the selected disk.
:::

## Quick Reference

| Scenario | Tool |
|------------|---------|
| Data recovery | FILE EXPLORER (**F8**) |
| Disk backup/restore | DISK BACKUP (**F7**) |
| Hardware diagnostics | HARDWARE INFO (**F9**) |
| Information lookup | WEB BROWSER (**F10**) + WiFi (**F2**) |
| BitLocker unlock | BitLocker (**F1**) |
| Network connectivity | WiFi (**F2**) + PowerShell (**F6**) |
| Partition management | Diskpart (**F5**) |
| Error log review | Notepad (**F4**) + Explorer (**F8**) |
