---
title: 'Glossary'
---

A reference table of common terms in the EASYDEPLOY system. This glossary helps you read the documentation quickly and consistently. Technical terms are kept in English with enterprise-grade definitions.

| Term | Definition |
|---|---|
| **EASYDEPLOY** | Windows deployment toolkit running in the WinPE environment, developed by CoreSystem. |
| **WinPE** | Windows Preinstallation Environment used to boot before installing the operating system. When you boot from USB, WinPE is loaded and EASYDEPLOY runs automatically. |
| **USB boot media** | USB containing the WinPE environment + EASYDEPLOY + configuration, used to boot the machine and perform deployment. |
| **License / Offline License** | Usage license packaged in the **`*.lic`** file issued by CoreSystem. Verified locally on the machine without requiring internet. Applies to **MSP Advanced**; **Free** requires no license. |
| **Service Tier (Tier)** | Classification: **Free** (perpetual, 2 profiles, Cloud catalog) and **MSP Advanced** (annual, USB-SN batch, unlimited). |
| **Free** | Perpetual free tier — no license required, 2 profiles (`1.Tweaks`/`2.TweaksApp`), Cloud catalog with embedded fallback. Suitable for solo IT consultants and micro-MSPs. |
| **MSP Advanced** | Annual tier by USB-SN batch — unlimited profiles, Self-catalog, full advanced features. Falls back to Free upon expiry. |
| **USB-SN** | Physical Serial Number of the USB — the unique identifier of each USB device. |
| **Bind USB-SN** | Mechanism that **binds the license to a specific USB** (Advanced only): the license only works on bound USB drives. |
| **Clone Protection** | Anti-cloning protection: prevents copying the license/USB to another device for unauthorized use (via Bind USB-SN). |
| **Re-key** | Re-issue of a license when the USB is lost/damaged — contact CoreSystem. |
| **Portable Apps (`Softwares\`)** | Rescue applications you supply yourself — **not included in the release package**. Add them via BootBuilder (at build time) or a manual copy + `user-config.json`. The default configuration references 4 sample tools: MultiDrive, HWiNFO64, Explorer++, Pale Moon. The main window only reserves 4 quick-launch buttons (footer labels and hotkeys adjust automatically); tool count is unlimited — launch extras via F6 (PowerShell)/F8 (Explorer)/cmd. |
| **Profile** | Post-install customization set consisting of `unattend.xml` and `post-setup.ps1`. Free includes 2 default profiles; Advanced is unlimited. |
| **OS Catalog (Catalog)** | Catalog of valid Windows versions (build/edition/language) available for deployment. |
| **ESD** | Windows installation file format (`.esd`) — the source EASYDEPLOY uses to install the operating system. |
| **OSCatalog (esd.coresystem.vn)** | CoreSystem's default catalog platform — Free uses the cloud catalog (with embedded fallback); Advanced can use Self-catalog. |
| **Cloud catalog** | Catalog fetched from the internet (via `catalog.url`). When offline, the system uses the **embedded catalog**. |
| **Embedded catalog** | OS list packaged inside the application — used when the cloud catalog is unreachable. |
| **Express Deploy (F3)** | Automated deployment mode via a single **F3** key — reads pre-configured settings and runs with one confirmation. Available in both Free and Advanced. |
| **Vanilla / Business / Express / ZeroTouch** | Four deployment methods orchestrated by EasyDeploy: **Vanilla** (clean Windows), **Business** (enterprise profile integrated), **Express** (F3 — automated per config), **ZeroTouch** (Advanced — boots and runs automatically). |
| **ZeroTouch** | Fully automated mode (**MSP Advanced** only): boot the USB → Express runs without any key press. For controlled environments. |
| **BYOC** | *Bring Your Own Catalog* — MSP Advanced self-hosts the catalog & ESD (even within a LAN), controlling the installation source. |
| **BYOB** | *Bring Your Own Backend* — MSP Advanced self-hosts the telemetry endpoint. CoreSystem ships a ready-made **Reference-Backend** blueprint to connect. |
| **Reference-Backend** | Complementary infrastructure blueprint (Cloudflare Worker + D1 / Node + SQLite, with production-ready documentation) — ships with the Advanced `.lic`. Operated by the MSP; features unlock via license enforcement inside EasyDeploy. |
| **Rescue Tools** | Rescue toolkit integrated in WinPE (BitLocker, WiFi, Diskpart, Explorer, etc.) via hotkeys — F1, F2 and F4–F12 (F3 is reserved for Express Deploy). |
| **Grace period** | Grace extension period after license expiry (14 days for Advanced). |
| **OOBE** | Out-of-Box Experience — the initial Windows setup screen after installation completes. |
