---
title: 'Deployment Modes'
---

EASYDEPLOY orchestrates 4 deployment methods: **Vanilla**, **Business**, **Express** (F3), and **ZeroTouch** (Advanced — fully automatic on USB boot, see [License Tiers](/en/easydeploy/msp/license-tiers/)). The first three are selected directly from the interface.

## Quick Comparison

| | **Vanilla** (key 1) | **Business** (key 2) | **Express** (F3) |
|---|---|---|---|
| UI Label | SETUP WINDOWS [DEFAULT] | SETUP WINDOWS [BUSINESS] | — (F3) |
| Profile | — | Yes | Yes (from `deploy.profile`) |
| Parameters | You choose via OSConfigurator | You choose via OSConfigurator | Auto-read from `user-config.json` |
| Use when | Clean Windows install | Enterprise-standard rollout | Large-scale deployment |

## Vanilla — Clean Windows

Press **1** or select **SETUP WINDOWS [DEFAULT]** → choose OS/edition + disk → **START OS DEPLOYMENT**.

Installs clean Windows with no profile. The device boots to Microsoft's standard OOBE.

## Business — With Business Profile

Press **2** or select **SETUP WINDOWS [BUSINESS]** → choose OS → choose **Profile** → choose disk → **START OS DEPLOYMENT**.

After extracting Windows, the engine copies `unattend.xml` and `Post-setup.ps1` to the target partition. Windows reads the answer file on boot and runs the script on first logon. See [Profiles Overview](/en/easydeploy/profiles/profiles/).

**Built-in profiles:** BootBuilder packages 2 profiles in `EASYDEPLOY\Profiles\`:
- **`1.Tweaks`** — basic system tweaks (wallpaper, cleanup, high performance…)
- **`2.TweaksApp`** — inherits tweaks + installs apps via WinGet

If the USB has no profile, the system uses the default profile (equivalent to `1.Tweaks`).

## Express — Automated via F3

Press **F3** → a confirmation dialog → runs fully automated.

Reads `user-config.json` automatically. If parameters are missing, OSConfigurator appears for manual selection.

:::note
Express requires `"enableF3Express": true` in `user-config.json`.
:::

## System Requirements

**Target machine (Windows install):** WinPE deploys Windows 11 — the target machine must meet, at minimum, [Microsoft's Windows 11 system requirements](https://www.microsoft.com/windows/windows-11-specifications).

**Workstation (running BootBuilder):** the engine runs on **PowerShell 7.4+** — all required components are bundled; the stronger the RAM/CPU, the faster the build.

## Supported Windows Builds

The deployment engine works with **any Windows language** — verified in practice on English, Japanese, Korean, and Chinese. The catalog at esd.coresystem.vn currently lists **9 popular languages** and will expand on demand:

| Criteria | Value |
|---|---|
| **Version** | Windows 11 `23H2` → `24H2` → `25H2` (26H2 may be added in the near future) |
| **Edition** | `Home` / `Pro` / `Enterprise` (others hidden by default; enable via `system-config.json` → `"filterCatalog": false`) |
| **Language** | `en-us` / `ja-jp` / `ko-kr` / `zh-cn` / `zh-tw` / `de-de` / `fr-fr` / `pt-br` / `es-es` / … (expanding on demand) |
| **Activation** | `Retail` / `Volume` |

:::note
**Windows activation is out of scope for EASYDEPLOY.** The tool only orchestrates installation (version, edition, language, disk, profile) — activation depends on the customer's model (Retail, Volume/KMS, MAK...). Clarify the activation model when preparing configuration.
:::

## 11-Step Deployment Engine

All three modes share the same 11-step engine — under 5 minutes for the deployment steps, plus about 10 minutes of automated post-install: ~15 minutes per machine, fully hands-off with ZeroTouch (actual time depends on network and disk speed):

| # | Step | Summary |
|---|------|---------|
| 1 | Initialize | Check configuration and license |
| 2 | Disk Scan | Filter valid target disks |
| 3 | USB Boot | Reclaim/restore USB drive letter |
| 4 | Partition | Create EFI, MSR, Windows, Recovery (GPT) |
| 5 | OS Source | Prefer offline `.esd` → fallback to CDN download |
| 6 | Edition | Select Windows Image edition index |
| 7 | Extract | `Expand-WindowsImage` to `C:\` |
| 8 | Bootloader | `bcdboot` creates boot files |
| 9 | Driver | Inject drivers from WinPE to new system |
| 10 | Cleanup | Remove temp files |
| 11 | Profile | Inject profile (Business/Express) → reboot to OOBE |

:::tip
If an error occurs, see log at `[USB]:\EASYDEPLOY\Log\deploy-error-<timestamp>.log`.
:::
