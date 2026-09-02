---
title: 'Profiles — System Overview'
description: 'Profile concept, lifecycle, discovery mechanism, and deployment modes in EASYDEPLOY.'
---

A Profile is a collection of post-installation configuration files. EASYDEPLOY injects them into Windows during deployment. Each Profile **consists of 2 files**:

```
EASYDEPLOY\Profiles\<ProfileName>\
├── unattend.xml        ← Windows Setup Answer File
└── post-setup.ps1      ← PowerShell script executed on first logon
```

:::caution
Each Profile needs both files to work fully: 1 `*.xml` and 1 `*.ps1`. EASYDEPLOY renames them automatically when copying, but you should use the standard names — the scanner lists a profile when the directory contains **at least one** correctly named file; with a missing file, the profile will not be fully applied.
:::

:::note
**Free & the profile-library workflow:** in Free mode, the engine only reads `1.Tweaks` and `2.TweaksApp` — any other folder in `EASYDEPLOY\Profiles\` is ignored and won't appear in OSConfigurator. The practical approach: keep your profile library on your workstation, and when needed **overwrite the contents of one of the two original folders** (keeping the exact name) before deploying. BootBuilder without a license also packages only these 2 profiles into the ISO; Advanced has no limit on profile count at build time.

Stopping Post-setup at the Tweaks baseline is deliberate — the post-install phase is the MSP's stage to demonstrate professional expertise to their customers (AD-DS/GPO, EntraID/Intune, PSADT/Chocolatey/Winget, MDM...).
:::

## 1. Profile Lifecycle

```
deploy (Business / Express mode)
    │
    │  Engine completes Windows installation (Step 11/11, exit code 0)
    ▼
NextStepService: Copy configuration files into the installed Windows image
    │  ├─ unattend.xml      → C:\Windows\Panther\unattend.xml
    │  └─ post-setup.ps1    → C:\CoreSystem\Post-setup.ps1
    ▼
Execute wpeutil reboot  →  Windows first boot, Setup reads unattend.xml (processing windowsPE, specialize, oobeSystem)
    ▼
OOBE screen: Automatically create accounts per the XML file, configure Autologon and run FirstLogonCommands
    ▼
First Desktop: Automatically run C:\CoreSystem\Post-setup.ps1 (tweaks, app installation, wallpaper setup, etc.)
```

## 2. Profile Discovery and Scanning Mechanism

EASYDEPLOY automatically scans the `EASYDEPLOY\Profiles` directory in priority order:

1. **All disk partitions** (USB boot drive prioritized first) — `[drive_letter]:\EASYDEPLOY\Profiles\*`
2. Directory alongside `easydeploy.exe` — `.\EASYDEPLOY\Profiles\*`
3. WinPE temporary partition — `X:\SetupFiles\`

:::caution
Fallback to default Profile: If the USB contains no profile, the system uses the default profile (equivalent to `1.Tweaks`).
:::

## 3. Built-in Standard Profiles

When building an ISO/USB, **EasyDeploy-BootBuilder** automatically packages two sample profiles at `EASYDEPLOY\Profiles\`:

| Profile | Details |
|---------|----------|
| **`1.Tweaks`** | Basic system tweaks: corporate wallpaper, junk file cleanup, High Performance power plan. |
| **`2.TweaksApp`** | Extends profile 1 with automatic app installation via Windows Package Manager (WinGet). |

This is a **production-ready** configuration that works out of the box and serves as a template for customization (see [Creating a New Profile](/en/easydeploy/profiles/creating-new-profile/)).


## 4. Profile Usage Differences Across Deployment Modes

| Deployment Mode | Profile Application Mechanism |
|--------|---------|
| Vanilla (key 1) | — Not applied — Clean Windows installation |
| Business (key 2) | ✅ Optional — You select the profile in the OSConfigurator UI |
| Express (F3) | ✅ Applied automatically — System points to the profile at key `deploy.profile` in `user-config.json` |

## 5. In-Depth Documentation

| Documentation | Objective |
|-------|----------|
| [unattend.xml](/en/easydeploy/profiles/unattend-xml/) | Customize Windows Setup and OOBE (accounts, autologon, first-logon commands) |
| [Post-setup.ps1](/en/easydeploy/profiles/post-setup-ps1/) | Customize the Windows environment after Desktop (tweaks, app installation, wallpaper) |
| [Creating a New Profile](/en/easydeploy/profiles/creating-new-profile/) | Procedure for creating and testing a new Profile |

## 6. Security Guidelines

:::danger
`unattend.xml` and `Post-setup.ps1` run with System/Administrator privileges. Only embed trusted, tested scripts. Do not store passwords or API keys in plain text.
:::
