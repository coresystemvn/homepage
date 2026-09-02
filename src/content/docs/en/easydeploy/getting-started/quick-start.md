---
title: 'Quick Start — Windows Installs Itself in ~15 Minutes'
---

Goal: Boot USB → choose deployment flow → done, fully unattended. No additional software needed.

> **Reference timing:** under 5 minutes for the engine to run all 11 deployment steps, plus about 10 minutes of automated post-install (OOBE + post-setup) — ~15 minutes per machine with ZeroTouch; Express adds just 2 key presses (F3 + confirm). Actual time depends on network and disk speed.

## 1. Preparation

1. Plug the USB into the target PC.
2. Power on and press the Boot Menu key (**F12, F9, or Esc** depending on model) → select boot from USB.
3. Once WinPE loads, the **EASYDEPLOY** interface appears automatically.

:::caution
Check network connectivity before installing. If offline, press **F2** to connect to WiFi, or make sure an `.esd` file exists in `EASYDEPLOY\OS\` on the USB.
:::

## 2. Choose Deployment Flow

On the main screen, choose one of three flows:

| Key | Flow | Description |
|------|-------|-------|
| **1** | Vanilla | Clean Windows, no customization |
| **2** | Business | Windows + business profile (recommended) |
| **F3** | Express | Fully automated via `user-config.json` |

**Business (2):** Select OS → select Profile → select disk → **START OS DEPLOYMENT**.

**Express (F3):** The system reads `user-config.json` automatically → shows a confirmation dialog → runs.

:::tip
If the USB has no profile, the system uses the default profile (`1.Tweaks`).
:::

## 3. Monitor and Finish

- Watch progress `[STEP x/11]` on screen. The device reboots automatically when done.
- After reboot, Windows enters the OOBE screen or Desktop per your profile.

## Quick Troubleshooting

| Symptom | Fix |
|-------------|-------|
| No target disk shown | Check BIOS (AHCI/RAID) and ensure the correct driver |
| License error | Check `*.lic` in `EASYDEPLOY\`, correct USB-SN |
| No internet | Press **F2** for WiFi, or use offline `.esd` |
| Deploy failed | See log at `[USB]:\EASYDEPLOY\Log\deploy-error-*.log` |

## Useful Links

- [Deployment Modes](/en/easydeploy/getting-started/deploy-modes/) — Details on each flow
- [BootBuilder](/en/easydeploy/msp/bootbuilder/) — Build custom USB (MSP)
- [License Tiers](/en/easydeploy/msp/license-tiers/) — Service tiers
