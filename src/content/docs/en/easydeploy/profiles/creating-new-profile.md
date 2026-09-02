---
title: 'Creating a New Profile'
description: 'Step-by-step guide to creating, testing, and validating a custom EASYDEPLOY profile.'
---

This guide walks you through creating a custom Profile for a new device or customer, including testing and validation procedures.

## 1. Initialize the Profile Directory Structure

Create a new directory under `EASYDEPLOY\Profiles\` on the USB. It is recommended to prefix the name with a number for organized sorting:

```
[USB]:\EASYDEPLOY\Profiles\
├── 1.Tweaks          ← Built-in profile (system tweaks only)
├── 2.TweaksApp       ← Built-in profile (tweaks + automatic app installation)
└── 3.AcmeBank        ← New custom profile (MSP Advanced only)
    ├── unattend.xml
    └── post-setup.ps1
```

:::note
**Free tier includes 2 default profile sets:** `1.Tweaks`/`2.TweaksApp` — you should **edit the existing profiles directly** instead of creating a new `3.*`. On the Free tier, additional profiles will **be ignored at runtime** (even though they remain stored on the USB). **MSP Advanced** may create unlimited profiles; see the technical documentation bundled with the `.lic` file.
:::

:::caution
A Profile consists of both `unattend.xml` and `post-setup.ps1`. EASYDEPLOY lists a profile when the directory contains at least one file with the standard name — but a missing file makes the profile incomplete.
:::

## 2. Build the `unattend.xml` Configuration File

The fastest approach: Use [schneegans.de/windows/unattend-generator](https://schneegans.de/windows/unattend-generator/) to configure parameters, download the file, then:

1. Open the file in a code editor.
2. Verify that `FirstLogonCommands` correctly points to `C:\CoreSystem\Post-setup.ps1` (see [unattend.xml](/en/easydeploy/profiles/unattend-xml/#23-first-logon-commands) for details).
3. Encrypt the password in the `PlainText` field if the file will be shared among multiple technicians.

:::tip
Use the `unattend.xml` from profile `1.Tweaks` as a base template for customization instead of creating one from scratch.
:::

## 3. Build the `post-setup.ps1` Script

Extend the script based on the sample file (see detailed guide at [Post-setup.ps1](/en/easydeploy/profiles/post-setup-ps1/)):

```powershell
Write-Host "=== [CoreSystem] POST-SETUP: AcmeBank ===" -ForegroundColor Cyan
$GlobalTimeoutSec = 300
function Wait-ForInternet { … }            # Use the sample network check function
$HasInternet = Wait-ForInternet

# [Step 1/5] Automatically install AcmeBank standard applications
# [Step 2/5] Apply registry and local policy customizations
# [Step 3/5] Download corporate wallpaper and create Notes.txt support file
# [Step 4/5] Clean up system (clear logs, configure RunOnce to clean temp directories)
# [Step 5/5] Restore script ExecutionPolicy security policy
Restart-Computer   # Automatically reboot the device after setup completes
```

## 4. Deploy Files to the USB Device

- **Free:** edit `1.Tweaks`/`2.TweaksApp` directly and **overwrite** them on the USB at `EASYDEPLOY\Profiles\` — no rebuild required.
- **Advanced:** copy unlimited new profiles to `EASYDEPLOY\Profiles\` — no rebuild required (details bundled with the `.lic`).

## 5. Testing and Validation Procedure

Recommended testing procedure before production use:

1. **Check script syntax:** Run the validation command in PowerShell:
   `[ScriptBlock]::Create((Get-Content .\post-setup.ps1 -Raw))` — if no error is returned, the script syntax is fully valid.
2. **Test on a virtual machine:**
   - Boot the VM from the USB into WinPE → Select deployment mode **Business** (key **2**) → Select the newly created profile → Click **Deploy**.
   - Monitor the activity log `[EASYDEPLOY][STEP x/11]` until the installation completes and the device reboots.
   - After transitioning to the OOBE screen: Verify automatic account creation, verify automatic logon, verify that the `Post-setup.ps1` script executes completely and the Desktop appears as configured.
3. **Stability verification:** Reinstall the device a second time using the same profile to verify that the script runs stably and produces no errors when re-executed on an already configured environment.
4. **Test on a physical device:** Perform 1 complete cycle on a physical workstation before large-scale rollout.

:::danger
The engine only lists **deployable disks** suitable for OS installation — the boot USB is excluded from the list to prevent accidental formatting. Verify the correct target disk before clicking Deploy: data on the target disk **will be completely erased** during partitioning.
:::

## 6. Deployment Handover

After the Profile passes testing, hand over the following resources:

- The profile configuration directory (containing `unattend.xml` and the `post-setup.ps1` script).
- The deployment configuration file `user-config.json` (for the Express flow: update the `deploy.profile` key to point to the new profile directory name).
- Accompanying technical documentation: List of apps requiring Internet during installation, default administrator password (if any), and estimated total script execution time.

## Profile Build Checklist

- [ ] Profile directory is placed correctly under `EASYDEPLOY\Profiles\` on the USB (directory name uses an ordered numeric prefix).
- [ ] `unattend.xml` contains a FirstLogonCommands declaration pointing exactly to `C:\CoreSystem\Post-setup.ps1`.
- [ ] `post-setup.ps1` includes a built-in Internet connectivity check and wait function before invoking network-dependent tasks.
- [ ] No sensitive information (passwords, API keys, etc.) is stored in plain text in the files.
- [ ] Script is verified to be idempotent (re-running multiple times causes no conflicts or system errors).
- [ ] Testing completed successfully: at least 2 cycles on VM and 1 cycle on a physical device.
- [ ] `user-config.json` configuration file (for the Express flow) correctly declares the new profile directory name.

:::caution
**Default Profile:** The fallback meets operational standards equivalent to `1.Tweaks` — managed by CoreSystem. If customization is needed, contact CoreSystem. For custom profiles, you only need to create the directory and copy it to the USB.
:::
