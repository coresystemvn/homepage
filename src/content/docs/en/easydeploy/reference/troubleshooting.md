---
title: 'Troubleshooting Guide'
---

A catalog of common issues and resolution guidance.

## 1. Issues During Deployment

Windows deployment is the most critical phase; errors at this stage are typically related to disks, licensing, or network connectivity.

| Symptom | Cause / Resolution |
|-------------|---------------------------|
| Target disk not displayed | The system only shows disks eligible for OS installation (**deployable disks**) — the boot USB is automatically excluded to prevent accidental formatting. Select the correct disk; check the controller settings in BIOS (AHCI/RAID) — if the controller driver is missing, integrate the corresponding driver into WinPE. |
| Offline license error (Invalid / expired / wrong USB) | The `*.lic` file is incorrect, expired, or the inserted USB is not in the license's bound `Usb` list → **contact CoreSystem for a new `.lic` file** (or re-key if the USB is damaged/lost). |
| No internet connection in WinPE | Press **F2** to configure a wireless connection, or check the wired LAN cable; alternatively, switch to an offline OS source (`EASYDEPLOY\OS\`). |
| SSL/TLS security error when downloading installation file | The system clock in the WinPE environment (UTC) is significantly out of sync, causing TLS/SSL certificate validation failure → Switch to an offline ESD source or synchronize the real-time clock in BIOS. |
| Error: `Image is not available offline ... download URL is not reachable` | The system cannot find the offline `.esd` file on the USB and the device has no network connection to download from the Cloud → Visit <https://esd.coresystem.vn> to download the corresponding installation file and copy it to the correct `EASYDEPLOY\OS\` folder on the USB (keep the original file name). |
| Error: `Offline image hash mismatch` | The local `.esd` file has been renamed, modified, or corrupted → SHA-256 hash verification failed. Use the exact file downloaded from the Catalog. |
| Deployment failed (Failed) at a specific step | Analyze the error log at: `[USB]:\EASYDEPLOY\Log\deploy-error-<timestamp>.log` (search for keywords `[STEP x/11] ... FAIL` or `[FATAL]`); or view `X:\deploy-log.txt` directly on the RAM disk before the device reboots. |
| Boot loop (Reboot Loop) or unable to reach the OOBE screen | Verify the Bootloader partition configuration (`bcdboot`) and the boot device priority (Boot Order) in BIOS/UEFI; try deploying in Vanilla mode to rule out issues caused by custom scripts in the profile. |

:::note
EASYDEPLOY also supports diagnostic files on the RAM disk `X:\` (automatically deleted on reboot):

| Diagnostic File | Contents |
|------|----------|
| `X:\easydeploy-app.log` | EasyDeploy application activity log |
| `X:\deploy-log.txt` | Deployment process log (steps `[STEP x/11]`) |
| `X:\deploy-launch.txt` | Detailed diagnostic information on deployment launch |

:::


## 2. Issues Related to Profiles and Post-setup Scripts

Profiles determine how Windows is configured after installation — errors here are usually due to incorrect paths or missing files.

| Symptom | Cause / Resolution |
|-------------|---------------------------|
| Profile folder not appearing in the selection list | Verify that the profile folder is located at `EASYDEPLOY\Profiles\` on the USB and contains the full file pair (`unattend.xml` + `post-setup.ps1`). The scanner lists a profile when the folder contains **at least one** correctly named file — but a missing file makes the profile incomplete. |
| Deployment without custom profile | When the Profiles folder on the USB is empty, the Business (2) and Express (F3) flows automatically fall back to the **system default profile** (equivalent to the standard enterprise `1.Tweaks` scenario) — see [Profiles Overview](/en/easydeploy/profiles/profiles/). |
| `Post-setup.ps1` script does not launch | Check that `FirstLogonCommands` in `unattend.xml` correctly points to `C:\CoreSystem\Post-setup.ps1`; and verify that the script file is named exactly `Post-setup.ps1`. |
| PowerShell script executes but fails to fetch data | Device has no internet connection or proxy is blocked → Tasks requiring network downloads are automatically skipped (applies to built-in scenarios using `Wait-ForInternet`). Check network port or proxy configuration. |
| Script execution blocked by Windows security (Execution Blocked) | Keep the script unlock command `Unblock-File ...; & 'C:\CoreSystem\Post-setup.ps1'` in the `FirstLogonCommands` section of `unattend.xml`. |
| Temporary folders (Panther/CoreSystem) remain after installation | The automatic cleanup segment (Cleanup) via RunOnce in `post-setup.ps1` may have been removed by the technician → Re-add the cleanup script segment or delete manually on the workstation. |
| Profile content edited but device still installs with old configuration | Since EASYDEPLOY reads data directly from the USB, verify that you have overwritten the new configuration file to the correct USB deployment partition before booting and reinstalling. |

## 3. Issues Related to Rescue Tools

| Symptom | Cause / Resolution |
|-------------|---------------------------|
| Pressing hotkeys F7 to F10 does not open tools | The Portable applications have not been copied to the designated folder on the USB. Verify the relative path declared in `system-config.json` or the override configuration in `user-config.json`. |
| Web browser reports SSL/TLS certificate error when accessing the network in WinPE | The WinPE environment lacks updated system CA certificates → Try accessing websites that support plain HTTP (if safe), or download the file in advance on another workstation and copy it to the rescue USB. |
| Pressing F1 does not activate the BitLocker interface | The system did not detect any encrypted partitions on the device. |
| Unable to connect to WiFi wireless network | SSID or password is incorrect; or the device's network adapter is not supported by WinPE → Integrate a compatible WiFi adapter driver into the WinPE environment via BootBuilder. |

## 4. Issues Related to License Authentication

| Symptom | Cause / Resolution |
|-------------|---------------------------|
| `License is not valid.` | The offline license is incorrect, has missing characters, or has expired → **Contact CoreSystem to request a new license**. |
| `Please check your BIOS time settings.` | The real-time clock (RTC) in BIOS is significantly out of sync → Enter the device BIOS and adjust the time zone accurately. |
| `Please contact CoreSystem to renew your license.` | The license has expired → Contact CoreSystem Sales to renew. |
| License near-expiry warning (NearExpiry - under 14 days) | The enterprise should plan to register or renew the license to avoid deployment interruption. |

## 5. Issues Related to Telemetry Data Sync (Telemetry / BYOB)

| Symptom | Cause / Resolution |
|-------------|---------------------------|
| No data in my DB endpoint (BYOB) | BYOB telemetry is **only available with the MSP Advanced tier** — see the technical documentation bundled with the `.lic`. **Free** does not send — data is stored in **CSV on the USB** (`[USB]:\EASYDEPLOY\Log\deploy-results.csv`). |
| `usb_brand` or `usb_serial` shows empty (NULL) | This deployment was performed in a virtual machine (VM) environment, so there is no physical USB hardware identifier — this is expected behavior. |
| Difficulty tracking data by OS build number (os_build) | Prefer tracking by `os_version` (e.g., `25h2`), or query your DB with SQL: `SELECT os_version, os_build ... FROM deploy_results`. |

## 6. Technical Support Request Process

If you cannot resolve the issue yourself, collect:

1. A copy of the error log file: `[USB]:\EASYDEPLOY\Log\deploy-error-*.log` (if available).
2. Screenshots of the visual error (console command-line interface, license error message, etc.).
3. Information about the license in use (`*.lic` file) and service tier.

Submit a technical support request at: <https://www.coresystem.vn>
