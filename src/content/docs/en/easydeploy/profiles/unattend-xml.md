---
title: 'Customizing the unattend.xml Configuration File'
description: 'Structure and common passes of the unattend.xml answer file for Windows Setup and OOBE automation in EASYDEPLOY.'
---

The `unattend.xml` file is the standard **Answer File** for Windows Setup. EASYDEPLOY copies this file to `C:\Windows\Panther\unattend.xml` on the target OS partition. Settings take effect **on the first boot** (system configuration phase, not offline on WinPE).

:::tip
To simplify the process, you can use the automatic generator at [schneegans.de/windows/unattend-generator](https://schneegans.de/windows/unattend-generator/). Then manually edit it according to the guide below. The sample profile was also created using this tool.
:::

## 1. Basic XML Structure

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <!-- Pass 1: windowsPE — Configuration before Windows completes installation -->
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" …>
            <!-- System language, keyboard, and time zone -->
        </component>
    </settings>

    <!-- Pass 2: Specialize — Device identity initialization -->
    <settings pass="specialize">
        <component name="Microsoft-Windows-Deployment" …>
            <RunSynchronous>
                <!-- Synchronous commands before OOBE -->
            </RunSynchronous>
        </component>
    </settings>

    <!-- Pass 3: oobeSystem — Initial OOBE screen setup -->
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" …>
            <UserAccounts>…</UserAccounts>
            <AutoLogon>…</AutoLogon>
            <OOBE>…</OOBE>
            <FirstLogonCommands>…</FirstLogonCommands>
        </component>
    </settings>
</unattend>
```

:::note
EASYDEPLOY only copies the answer file to the `Panther` directory. Configuration passes are processed by the standard Windows Setup mechanism.

`unattend.xml` is part of the Profile structure. Always keep it synchronized as a pair with `post-setup.ps1`.
:::

## 2. Common Configuration Passes

### 2.1. Default Administrator Account (`oobeSystem → UserAccounts`)

Automatically create a local user account and assign it to the Administrators group:

```xml
<UserAccounts>
    <LocalAccounts>
        <LocalAccount wcm:action="add">
            <Name>ITAdmin</Name>
            <DisplayName>Administrator</DisplayName>
            <Group>Administrators</Group>
            <Password>
                <Value>to-strong-password</Value>
                <PlainText>true</PlainText>
            </Password>
        </LocalAccount>
    </LocalAccounts>
</UserAccounts>
```

### 2.2. Automatic Logon Configuration

Allows the `Post-setup.ps1` script to run automatically after installation without requiring manual logon:

```xml
<AutoLogon>
    <Enabled>true</Enabled>
    <Username>ITAdmin</Username>
    <LogonCount>1</LogonCount>
    <Password>
        <Value>to-strong-password</Value>
        <PlainText>true</PlainText>
    </Password>
</AutoLogon>
```

### 2.3. First Logon Commands

The pass that lets EASYDEPLOY invoke `Post-setup.ps1`. The sample configuration runs the PowerShell script and unblocks it:

```xml
<FirstLogonCommands>
    <SynchronousCommand wcm:action="add">
        <Order>1</Order>
        <Description>Run CoreSystem post-setup</Description>
        <CommandLine>powershell.exe -ExecutionPolicy Bypass -Command "if (Test-Path 'C:\CoreSystem\Post-setup.ps1') { Unblock-File -Path 'C:\CoreSystem\Post-setup.ps1' -ErrorAction SilentlyContinue; & 'C:\CoreSystem\Post-setup.ps1' }"</CommandLine>
    </SynchronousCommand>
</FirstLogonCommands>
```

:::caution
Keep the exact path `C:\CoreSystem\Post-setup.ps1`. This is the fixed location where EASYDEPLOY copies the script. If changed, the script will fail to launch.
:::

### 2.4. Synchronous Commands in the Specialize Pass

Execute commands before the OOBE screen appears. Suitable for system optimization (registry overrides, removing default apps, etc.):

```xml
<RunSynchronous>
    <RunSynchronousCommand wcm:action="add">
        <Order>1</Order>
        <Path>reg add HKLM\SOFTWARE\Policies\Microsoft\Windows /v DisableAppSuggestions /t REG_DWORD /d 1 /f</Path>
    </RunSynchronousCommand>
</RunSynchronous>
```

## 3. Common System Customization Parameters

| Customization Category | Pass | Notes |
|-----|------|---------|
| Time Zone & Language | `windowsPE` | Example: time zone `SE Asia Standard Time`, display language `en-us` |
| OOBE Automation | `oobeSystem → OOBE` | hide EULA `HideEULAPage`, security `ProtectYourPC: 3`, skip OOBE `SkipMachineOOBE`, etc. |
| Remove UWP Apps | `specialize` / `oobeSystem` | `Remove-AppxPackage` command by package name |
| Enable Long Paths & Remove Windows.old | `specialize` | Registry `EnableLongPaths` and cleanup of old backup directory |
| Disable Automatic BitLocker | `oobeSystem` | `PreventDeviceEncryption: true` — prevents automatic drive encryption |
| Explorer & Taskbar | `oobeSystem → Shell-Setup` | Restore classic context menu, left-align Taskbar, etc. |

## 4. Validation and Testing Procedure

- **Data structure:** Validate XML syntax using Notepad or a dedicated code editor.
- **Passes:** Use exact Pass and Component names. An incorrect identifier will cause the OS to silently ignore the configuration without reporting an error.
- **Testing:** Test the installation on a virtual machine before large-scale deployment (see [Creating a New Profile](/en/easydeploy/profiles/creating-new-profile/)).

## 5. Important Notes

:::danger
`<PlainText>true</PlainText>` stores the password in plain text in the XML. The file is only stored on the USB and accessible to IT. You should require users to change the password after device handover.
:::

:::tip
Any edits to `unattend.xml` on the USB do not require rebuilding the application. EASYDEPLOY reads directly from `EASYDEPLOY\Profiles\<ProfileName>\`. Overwrite the file and reboot to apply the new configuration.

If you want to change the default Profile, contact CoreSystem. IT/MSP partners only manage their own profiles on the USB.
:::
