---
title: 'Customizing the Post-setup.ps1 Script'
description: 'Lifecycle, recommended structure, sample code blocks, and security guidelines for the Post-setup.ps1 first-logon script.'
---

The `Post-setup.ps1` file is a PowerShell script that runs automatically on the **first logon to the Desktop** after Windows completes setup. EASYDEPLOY copies the script to `C:\CoreSystem\Post-setup.ps1` on the system partition. Windows Setup invokes the script via `FirstLogonCommands` in `unattend.xml`.

This is the ideal environment to apply post-installation tweaks: system customization, automatic app installation, wallpaper setup, and temporary cleanup.

:::note
The file on the USB can be named `Post-setup.ps1` or `post-setup.ps1` (case-insensitive). When copied to `C:\CoreSystem\`, it is always normalized to `Post-setup.ps1`.

The `post-setup.ps1` file is a mandatory Profile component. Always keep it synchronized as a pair with `unattend.xml`.
:::

## 1. Script Lifecycle

```
Windows first boot after installation
    │
    ▼
Automatic Desktop logon (AutoLogon) (if configured)
    │
    ▼
FirstLogonCommands invokes PowerShell with:
      if (Test-Path C:\CoreSystem\Post-setup.ps1) { Unblock-File …; & … }
    │
    ▼
Script starts running (with Administrator privileges)
    │
    ▼
Script completes and reboots the device (Reboot) if required
```

## 2. Recommended Script Structure (Standard Template)

The built-in sample profile (`1.Tweaks`) is designed with an optimized logical structure. You can use it as a reference template:

```powershell
# 0. Define display header and timeout configuration
Write-Host "=== [CoreSystem] POST-SETUP ===" -ForegroundColor Cyan
$GlobalTimeoutSec = 300

# 1. Declare Internet connectivity check function (retry up to 6 times, 5-second interval)
function Wait-ForInternet { … }

# 2. Check network — internet-dependent tasks only run when connected
$HasInternet = Wait-ForInternet

# 3. [Step X/7] Sync files/resources from Cloud (e.g., Notes.txt, etc.)
# 4. [Step X/7] Download and set wallpaper
# 5. [Step X/7] Automatically install applications (via WinGet or msi/exe installers)
# 6. [Step X/7] Clean up system resources (clear Event Logs, clean Panther/CoreSystem after reboot)
# 7. [Step X/7] Restore ExecutionPolicy to RemoteSigned
```

:::tip
Numbering `[1/7] ... [7/7]` combined with colored `Write-Host` output helps you monitor progress easily. Convention: `Green` (OK), `Yellow` (Warning), `Red` (Error).
:::

## 3. Useful Sample Code Blocks

### 3.1. Internet Connectivity Check Loop (Required if the script needs to fetch network resources)

```powershell
function Wait-ForInternet {
    $retry = 0
    while ($retry -lt 6) {
        if (Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet) { return $true }
        Start-Sleep -Seconds 5
        $retry++
    }
    return $false
}
$HasInternet = Wait-ForInternet
```

### 3.2. Download and Configure Wallpaper from URL

```powershell
$Url = "https://coresystem.vn/osd/wallpaper.jpg"
$Dest = "C:\Windows\Web\Wallpaper\CoreSystem\wallpaper.jpg"
if ($HasInternet) {
    New-Item -ItemType Directory -Path (Split-Path $Dest) -Force | Out-Null
    Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing -TimeoutSec $GlobalTimeoutSec
    # Apply wallpaper change via P/Invoke calling SystemParametersInfo from user32.dll
}
```

### 3.3. Automatic App Installation via Windows Package Manager (WinGet — available on Windows 11)

```powershell
$apps = @("7zip.7zip", "Google.Chrome", "Microsoft.PowerToys")
foreach ($app in $apps) {
    if ($HasInternet) {
        winget install --id $app --accept-package-agreements --accept-source-agreements --silent
    }
}
```

:::note
WinGet may not have initialized immediately after logon. Profile `2.TweaksApp` already includes the command to activate the WinGet source beforehand.
:::

### 3.4. Clean Up System Logs and Automatically Remove Temporary Data

```powershell
Get-EventLog -LogName * -ErrorAction SilentlyContinue |
    ForEach-Object { Clear-EventLog -LogName $_.Log -ErrorAction SilentlyContinue }

# Remove Panther & CoreSystem directories on the next boot
$RunOnce = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnce -Name "CleanupPanther"   -Value "cmd.exe /c rmdir /s /q C:\Windows\System32\Panther" -Force
Set-ItemProperty $RunOnce -Name "CleanupCoreSystem" -Value "cmd.exe /c rmdir /s /q C:\CoreSystem"             -Force
```

### 3.5. Restore Script Execution Policy

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
```

## 4. Security Guidelines

:::danger
The script runs with Administrator privileges and has full network access. Strictly adhere to the following:

- Do not store passwords or API keys in plain text in the script.
- Only download files from trusted URL sources. Verify the hash after downloading.
- Keep the `Unblock-File` command in `unattend.xml` to unblock the script before execution.
- Always restore `ExecutionPolicy` to `RemoteSigned` at the end of the script.
:::

## 5. Operational and Deployment Recommendations

- **Quick customization:** Any changes to `Post-setup.ps1` on the USB **do not require rebuilding the application**. EASYDEPLOY reads directly from `EASYDEPLOY\Profiles\<ProfileName>\`. Overwrite the file and reboot to test.
- **Default profile:** Changing the default profile (when the USB is empty) is managed by **CoreSystem**. IT/MSP partners only manage their own profiles on the USB (see [Creating a New Profile](/en/easydeploy/profiles/creating-new-profile/)).
