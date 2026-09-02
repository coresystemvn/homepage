---
title: 'Service Plans and License Tiers'
---

EASYDEPLOY offers two plans: **Free** for IT/Micro-MSP and **MSP Advanced** for MSP partners who want to own their infrastructure.

## Overview

| Tier | Audience | License | Profiles | Catalog | Security & Automation |
|------|-----------|---------|----------|---------|-------------------|
| **Free** | Solo IT, Micro-MSP, personal use | **Not required** — perpetual | **2** (`1.Tweaks`, `2.TweaksApp`) | **Cloud catalog** + embedded fallback (`esd.coresystem.vn`) | — |
| **MSP Advanced** | MSPs with teams & infrastructure | **Annual**, bound per **USB-SN** batch | **Unlimited** | **Self-catalog** | Profile Encryption, ZeroTouch, BYOB Telemetry |

:::note
When Advanced expires, the system **automatically reverts to Free (2 profiles)** — a `NearExpiry` warning appears before each install during the last 14 days, and a **14-day grace period** follows the expiry date (see [Offline Mode](/en/easydeploy/reference/offline-mode/)). Advanced features (`profileEncryption`, `zeroTouch`, `self-catalog`, `telemetry`) only take effect with a valid license — otherwise, settings in `user-config.json` / `system-config.json` will be ignored. BootBuilder will still build, limited to 2 profiles.
:::

## Free Plan — Ready to Use, No License Required

- **Audience:** you want fast, lightweight Windows deployment with no strings attached — suitable for most Solo IT and Micro-MSP needs.
- **License:** not required, perpetual.
- **ISO Creation:** unlimited — download the binary duo `EasyDeploy + BootBuilder` (with `links.md`), build the ISO yourself on a workstation (requires ADK, PE Addon + PowerShell 7.4).
- **Driver:** industrial standard — meets most office PC requirements.
- **Express Deploy (F3):** fully included.
- **Support:** Documentation on the homepage.

> The binary duo is released by CoreSystem, each version includes a **SHA256 hash** and **hash signature (`.sig`)** — binaries automatically validate before running to ensure integrity and prevent risks from repackaged files.

## MSP Advanced Plan — For Scale Operations

Includes all Free benefits, plus:

| Benefit | Brief Description |
|-----------|------------|
| **Self-catalog** | Self-host the catalog (`catalog.url` + `cloudCatalog`) — control the ESD source, even within a LAN |
| **Unlimited Profiles** | Create unlimited custom profiles beyond the 2 default templates |
| **Profile Encryption** | Protect `unattend.xml` + `post-setup.ps1` with a preshared key (`profileEncryption`, `encrypt-profile.ps1`) |
| **Zero Touch** | Boot USB → automatically run Express without F3 (`zeroTouch`) — apply only in controlled environments |
| **BYOB Telemetry** | Send deployment data to your own endpoint (`telemetry` block) |
| **Reference-Backend** | Complementary infrastructure blueprint: Cloudflare Worker + D1 / Node + SQLite (with production-ready documentation). Self-operated by the MSP — features unlock via license enforcement inside EasyDeploy |

:::tip
Technical details for the Advanced feature set are bundled in the **technical documentation accompanying the Advanced `.lic`** — public docs retain only the EasyDeploy + BootBuilder core.
:::

## Quick Comparison

| Capability | Free | Advanced |
|----------|:----:|:--------:|
| Catalog | Cloud + embedded | Self-catalog |
| Profiles | 2 only (1.Tweaks, 2.TweaksApp) | Unlimited |
| Profile Encryption | — | ✅ |
| Backend Telemetry (BYOB) | — | ✅ |
| ISO Creation | ✅ unlimited | ✅ unlimited |
| Driver Integration | ✅ industrial standard | ✅ industrial standard |
| License | Not required | Annual, USB-SN bound |
| Express Deploy (F3) | ✅ | ✅ |
| ZeroTouch | — | ✅ |
| Support | Docs only | Email (core features, no add-on) |

## Renewal & Fallback

- Advanced is an **annual subscription per USB-SN batch**. When it expires, you can continue using **Free mode (2 profiles)**.
- For renewal, re-key (USB lost/damaged), or upgrading from Free to Advanced — contact `support@coresystem.vn`. All licensing operations are centrally managed by CoreSystem.

## Note on USB-SN (Applies to Advanced)

With Advanced, each USB acts as a bound “deployment card” tied to its SN — copying to another USB will not work. USB-SN data resides only on the USB (CSV) or on your self-hosted BYOB endpoint — CoreSystem does not store it.

### 3-Layer USB Protection

The MSP's USB is a revenue-generating asset — the system protects it in 3 layers:

| Layer | Mechanism | Prevents |
|-----|--------|-----------|
| **1. Physical** | Safeguard the physical device | Theft, lost USB drives |
| **2. License bound to USB-SN** | License signed with ECDSA P-256, tightly bound to the USB serial number | USB cloning — copies won't run, preventing license waste |
| **3. Profile encryption** | Encrypt `unattend.xml` + `post-setup.ps1` with a preshared key | Configuration data leaks when the USB falls into the wrong hands |

:::caution
**Protecting the preshared key is the MSP's responsibility.** The key lives in the configuration so you can **change profiles on your own without waiting for CoreSystem to rebuild the exe** — in exchange, if someone boots into WinPE on your USB, the key can be read. Combine all 3 layers: physical safeguard, USB-SN binding, and profile encryption.
:::
