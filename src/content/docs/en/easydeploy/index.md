---
title: 'EASYDEPLOY — User Guide'
description: 'Windows deployment and rescue tools documentation on WinPE for MSP partners.'
---

**EASYDEPLOY** is a modern Windows deployment solution on WinPE, developed by **CoreSystem**. Boot your USB into WinPE and `easydeploy.exe` will start automatically. Just choose a deployment flow and the system will complete a fully automated Windows installation (11-step closed loop, hands-off) with rescue utilities ready when needed.

## Video Demo

<video src="/easydeploy/easydeploy.mp4" controls></video>

:::note
Video is 10× fast-forward of a complete Windows deployment via USB (14'45" → 1'28").
Actual time varies by network and disk speed.
:::

:::note
Documentation for **IT Helpdesk, SysAdmins, and MSPs** using EASYDEPLOY on WinPE for Windows deployment and system rescue.
:::

## Quick Start

Get started with EASYDEPLOY — choose what fits your needs.

| Item | Description |
|-----|-------------|
| [Quick Start](/en/easydeploy/getting-started/quick-start/) | Boot WinPE USB — Windows installs itself in ~15 minutes |
| [Deployment Modes](/en/easydeploy/getting-started/deploy-modes/) | Vanilla / Business / Express (F3) — choose the right mode |
| [Rescue Tools](/en/easydeploy/getting-started/rescue-tools/) | Data rescue, backup, and hardware diagnostics |

## MSP & Licensing

Manage service tiers and customize your USB for MSP operations.

| Item | Description |
|-----|-------------|
| [License Tiers](/en/easydeploy/msp/license-tiers/) | **Free** (perpetual, 2 profiles) / **MSP Advanced** (annual, unlimited) |
| [Getting Started](/en/easydeploy/msp/getting-started/) | Prepare your USB and `user-config.json` for the first deployment |
| [BootBuilder (Whitebox)](/en/easydeploy/msp/bootbuilder/) | Build custom USB/ISO — Free (2 profiles) and Advanced (unlimited) |

## Advanced — Profile Customization

Control how Windows is configured after installation.

| Item | Description |
|-----|-------------|
| [Profiles Overview](/en/easydeploy/profiles/profiles/) | Profile concept, storage location, and injection mechanism |
| [unattend.xml](/en/easydeploy/profiles/unattend-xml/) | Automate Windows Setup / OOBE (accounts, autologon, first-logon script) |
| [Post-setup.ps1](/en/easydeploy/profiles/post-setup-ps1/) | First-logon script — system tweaks and app installation |
| [Creating a New Profile](/en/easydeploy/profiles/creating-new-profile/) | Set up and test a standard profile for a new device |

## Reference

Detailed reference for configuration, shortcuts, offline mode, and troubleshooting.

| Item | Description |
|-----|-------------|
| [Configuration](/en/easydeploy/reference/configuration/) | `system-config.json`, `user-config.json`, and catalog `data.json` |
| [Keyboard Shortcuts](/en/easydeploy/reference/keyboard-shortcuts/) | Shortcuts on the WinPE main screen |
| [Offline Mode](/en/easydeploy/reference/offline-mode/) | Offline license and offline/hybrid ESD source management |
| [Troubleshooting](/en/easydeploy/reference/troubleshooting/) | Common errors and fixes |
| [Telemetry](/en/easydeploy/reference/telemetry/) | Collection policy — no personal data or license keys collected |
| [Glossary](/en/easydeploy/reference/glossary/) | Common terms (license, catalog, BYOC/BYOB, profile...) |

## Architecture Overview

**EasyDeploy is the heart of the solution** — the `easydeploy.exe` engine inside `sources\boot.wim` handles deployment. **BootBuilder** lets you build a WinPE USB in just a few clicks instead of spending weeks debugging drivers and the WinPE environment.

![EasyDeploy Architecture — 2-phase Build & Deploy](/easydeploy/architecture.svg)

```
[Build Phase — Workstation]                [Deploy Phase — WinPE]
EasyDeploy.zip + ESD + Drivers/Wallpaper → USB boot → easydeploy.exe (in boot.wim)
        ↓ BootBuilder (.cache → ISO → Rufus)           │
                                 ┌─────────────────────┼──────────────────────┐
                                 ▼                     ▼                      ▼
                           Install Windows        Rescue tools            Cloud (optional)
                           11-step engine        F1 BitLocker · F2 WiFi  License .lic (offline, Advanced)
                           (fully automated)     F4 Notepad · F5 Diskpart  Catalog data.json
                                                 F6 PowerShell · F7 Backup
                                                 F8 Explorer · F9 HWiNFO
                                                 F10 Browser · F11 About · F12 Shutdown
```

- **Engine `EASYDEPLOY CLI`**: automates enterprise-grade Windows installation — under 5 minutes for all 11 deployment steps, plus about 10 minutes of automated post-install; with Hybrid and Offline support.
- **Licensing**: **Offline License** for Advanced — `*.lic` file (ECDSA P-256, bound to USB-SN) placed on the USB. **Free requires no license** (perpetual).
- **OS Source**: prefers `.esd` already on the USB (`EASYDEPLOY\OS\`); if not found, downloads from the Catalog over the internet (SHA-256 verified). Look up ESD download links at <https://esd.coresystem.vn>.
- **Profile**: pair `unattend.xml` and `Post-setup.ps1` in `EASYDEPLOY\Profiles\<Profile_Name>\`. **Free includes 2 profiles** (`1.Tweaks`/`2.TweaksApp`) — just edit them directly; creating more has no effect (tip: keep your profile library on your workstation and overwrite the contents of the two original folders when needed). **Advanced is unlimited** — see [Profiles Overview](/en/easydeploy/profiles/profiles/).
- **Rescue**: Portable tools in `Softwares\` on the USB — not included in the release package; bring your own and add them via BootBuilder (at build time) or a manual copy + `user-config.json`.

### Extended Ecosystem (for MSP Advanced)

When you need more control, Advanced adds:

- **BYOC** — self-host catalog & ESD (including on LAN).
- **BYOB** — self-host telemetry endpoint for reporting.
- **Profile Security & ZeroTouch** — profile encryption with preshared-key, automated Boot USB → done (controlled environments only).
- **Reference-Backend** — infrastructure blueprint for BYOB (telemetry) for quick rollout.

> With **Free**, keys you add in `system-config.json`/`user-config.json` for the above will **have no effect at runtime** — the system uses defaults. See [Configuration](/en/easydeploy/reference/configuration/). Advanced details are in the technical docs bundled with the `.lic`.

## Download Security

The `EasyDeploy + BootBuilder` binary pair is distributed by CoreSystem. Each release has a **SHA256 hash** and a **YubiKey signature (`.sig`)** — binaries self-validate before running to ensure integrity and prevent repackaging. See [Getting Started](/en/easydeploy/msp/getting-started/).

## Support

- Website: <https://www.coresystem.vn>
- ESD Catalog (lookup download links, offline/hybrid): <https://esd.coresystem.vn>
- **Free:** Docs only — enough for solo IT consultants and micro-MSPs.
- **MSP Advanced:** Email support for core features (add-ons excluded) — contact `support@coresystem.vn`; Advanced plan inquiries: `inquiry@coresystem.vn`.

:::note
**Support scope:** **Free** — Docs only; **MSP Advanced** — Email (core features, add-ons not included).
:::
