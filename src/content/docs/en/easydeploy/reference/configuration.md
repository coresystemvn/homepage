---
title: 'Detailed Configuration Reference'
description: 'Reference for system-config.json, user-config.json, and the OS catalog data.json in EASYDEPLOY.'
---

EASYDEPLOY reads configuration from **two JSON files**.

## 1. system-config.json — System Configuration

This file is located alongside `easydeploy.exe` in the release package, and is **baked into `boot.wim` by BootBuilder when building the USB**.

Its role is to define the system's core functions: display labels, rescue tool paths, the OS Catalog (BYOC), telemetry (BYOB), and the preshared-key for profile decryption. This file **cannot be edited at runtime** (it lives inside `boot.wim`) — to change it, edit before building and let BootBuilder package the new version.

Advanced keys (Self-catalog/BYOB/Encryption/ZeroTouch) are only for **MSP Advanced** — on **Free**, these are ignored at runtime. The catalog works fully on every tier (see the table below).

```jsonc
{
  "_comment": "EASYDEPLOY configuration — edit this file to custom labels, and tool paths without recompiling.",
  "labels": {
    "flow1Title": "SETUP WINDOWS [DEFAULT]",
    "flow1Desc": "Clean install Windows operating system",
    "flow2Title": "SETUP WINDOWS [BUSINESS]",
    "flow2Desc": "Deploy Windows OS with business profile",
    "aboutInfo": "EASYDEPLOY | Business Windows Deployment …",
    "toolMultiDriveLabel": "DISK BACKUP",
    "toolExplorerLabel": "FILE EXPLORER",
    "toolHwInfoLabel": "HARDWARE INFO",
    "toolBrowserLabel": "WEB BROWSER"
  },
  "toolPaths": {
    "multiDrive": "MultiDrive\\MultiDrive.exe",
    "explorer": "Explorer++\\Explorer++.exe",
    "hwInfo": "HWInfo\\HWINFO64.exe",
    "browser": "Palemoon\\Palemoon.exe"
  },
  "behavior": {
    "defaultWifiSsid": "",
    "defaultWifiPassword": "",
    "deployLogCSV": true
  },
  "catalog": {
    "url": "https://esd.coresystem.vn/data.json",
    "timeoutSeconds": 30,
    "downloadMethod": "auto",
    "cloudCatalog": true,
    "filterCatalog": true
  },
  "telemetry": {
    "enabled": false,
    "endpoint": "",
    "apiKey": "",
    "reportDeployment": true
  },
  "profileEncryption": {
    "enabled": false,
    "passphrase": ""
  }
}
```

| Key Structure | Purpose | On Free |
|------|---------|----------|
| `labels` | Labels for the 2 main installation flows, rescue function buttons, and the About dialog. | ✅ Effective (edit before build — see note below) |
| `toolPaths` | Relative paths to rescue tools — resolved automatically under `Softwares\` on the USB. Serves as the **fallback value**: used only when `user-config.json` does not declare `portableApps`. | ✅ Effective (edit before build) |
| `behavior` | Default WiFi (`defaultWifiSsid`/`defaultWifiPassword`) + `deployLogCSV`. | ✅ Effective (edit before build) |
| `catalog` | OS Catalog source (`url`/`timeoutSeconds`/`downloadMethod`/`cloudCatalog`/`filterCatalog`). **Always-fallback design**: `url` points to the catalog operated by CoreSystem — if it goes down (rare), the engine switches to the **embedded catalog**. `cloudCatalog:true` = prioritize cloud; `filterCatalog:true` = OS Configurator only shows `Home|Pro|Enterprise` (turn the filter off to list every Windows 11 edition). **Free works fine with the defaults** — only a self-hosted `url` is BYOC (Advanced). | ✅ Effective (except self-hosted `url` — BYOC/Advanced) |
| `telemetry` | BYOB telemetry (`enabled`/`endpoint`/`apiKey`). | ⚠️ Ignored — only CSV log on USB |
| `profileEncryption` | Profile encryption (`enabled`/`passphrase`). | ⚠️ Ignored |

:::note
On **Free**, the advanced keys (`telemetry`, `profileEncryption`, and a self-hosted `url` — Self-catalog/BYOC) are **ignored at runtime**: the system uses CoreSystem's cloud catalog with embedded fallback and logs CSV on the USB. Details about Self-catalog/BYOB/Encryption/ZeroTouch are in the **technical documentation bundled with the MSP Advanced `.lic`**.
:::

:::note
**What does "edit before build" mean?** Because `system-config.json` is baked into `boot.wim` at build time, the effective keys (`labels`/`toolPaths`/`behavior`) must be edited **before running BootBuilder** — BootBuilder packages the new version into the USB. Editing the file inside `boot.wim` after the build has no effect.
:::

### 1.1. License Verification — Offline License (sole method)

> Simply place the `*.lic` file (issued by CoreSystem) into `EASYDEPLOY\` on the USB — the client automatically verifies the ECDSA signature + USB-SN binding + license tier locally.

:::note
`system-config.json` is baked into `boot.wim` by BootBuilder at build time — the version shown here belongs to the CoreSystem release.
Focus on customizing `user-config.json` on the USB.
Rescue tools are located via `[drive_letter]:\Softwares\<toolPaths>`.
:::

## 2. user-config.json — Customer Deployment Configuration

File location: `[USB]:\EASYDEPLOY\user-config.json`.

It contains default installation parameters and deployment customizations.

**Each customer/MSP partner uses their own `.lic` license file on their USB.**

```jsonc
{
  "enableF3Express": true,         // enable Express mode (F3)
  "zeroTouch": false,              // Advanced only — ignored on Free
  "deploy": {
    "version": "25h2",
    "edition": "Pro",
    "activation": "Retail",
    "languageCode": "en-us",
    "diskNumber": 0,
    "profile": "1.Tweaks"
  },
  "portableApps": { … },           // overrides toolPaths
  "toolMultiDriveLabel": "DISK BACKUP",   // overrides tool label
  "toolExplorerLabel": "FILE EXPLORER",
  "toolHwInfoLabel": "HARDWARE INFO",
  "toolBrowserLabel": "WEB BROWSER"
}
```

| Key Structure | Purpose | On Free |
|-------|---------|----------|
| `enableF3Express` | Enable/disable Express mode (F3). | ✅ Effective |
| `zeroTouch` | Boot USB → auto-run Express (`zeroTouch:true`). **MSP Advanced** only. | ⚠️ Ignored |
| `deploy.version` | OS version in OSCatalog (e.g., `25h2`). Resolves to the latest build automatically if multiple builds share the same version. | ✅ Effective |
| `deploy.activation` | Home → `Retail`; Enterprise → `Volume`; Pro → choose `Retail` or `Volume`. Incorrect selection → incorrect installation. | ✅ |
| `portableApps` / `tool*Label` | Override rescue tool paths or button labels. When not declared, the system **falls back to the values in `system-config.json`**. | ✅ |
| `deploy.profile` | Profile name for Express (`1.Tweaks`/`2.TweaksApp`). **Free is hard-coded to 2 profiles** — creating `3.Acme` will be ignored. To use a custom profile on Free: overwrite the contents of one of the two original folders (keeping the exact names `1.Tweaks`/`2.TweaksApp`) — other folder names are ignored. | ⚠️ Only 1.Tweaks/2.TweaksApp are effective |

:::caution
**Fallback design — `portableApps`/`toolPaths`:** the system is designed to always have a fallback value in every situation — a missing `user-config.json` (or missing keys) falls back to `system-config.json`. In practice, however, **without `user-config.json`, Express Deploy and MSP-owned portable app licenses are nearly useless** — always check this file before handing a USB to a customer.
:::

:::note
**Portable apps are not included in the release package.** The 4 tools in the default configuration (MultiDrive, HWiNFO64, Explorer++, Pale Moon) are reference design choices only — the `.zip` from the Download page **does not contain** these applications. MSPs/IT bring their own tools and add them to the USB in one of two ways:

1. **At ISO build time — via BootBuilder:** copy the software into `usb\Softwares\` before building.
2. **Manual copy after building:** drop the tools into `Softwares\` on the USB and declare `portableApps` in `user-config.json` — if you keep the same folder structure as the default `toolPaths`, no declaration is needed.

The main window only reserves **4 quick-launch buttons** (EasyDeploy is a deployment tool first — rescue is a supporting role); labels and footer hotkeys adjust automatically to your configuration. There's no limit on tool count — anything beyond the 4 slots runs via F6 (PowerShell)/F8 (Explorer)/cmd.
:::

:::note
License verification is **Offline License only**.
Place `*.lic` in `[USB]:\EASYDEPLOY\`. See details at [Offline Mode](/en/easydeploy/reference/offline-mode/).
:::

## 3. Catalog data.json — Valid Operating System List

The Catalog is a list of valid Windows Images (downloaded from Microsoft's official distribution channel).

CoreSystem hosts it at `https://esd.coresystem.vn/data.json`.
Declared via `catalog.url` in `system-config.json`.

When WinPE boots, the system automatically downloads the list and caches it at `X:\EasyDeploy\catalog.json`.

:::note
**Catalog source depends on the `cloudCatalog` flag:** the client only fetches from the cloud when `catalog.cloudCatalog = true`.
When `false`, no network call is made — the **embedded catalog in the exe** (`data.json`) is used.
Useful when an MSP wants to pin the OS list.
:::

> MSP Advanced can **self-host `data.json`** (details in the technical docs bundled with the `.lic`). Free uses CoreSystem's cloud catalog — the embedded catalog is always the fallback.

> General flow: download → cache → fallback to embedded when offline.

Each catalog entry:

```jsonc
{
  "build": "26200.8873",          // build number
  "version": "25h2",              // version (e.g., 25h2, 24h2)
  "fileName": "26200.8873…en-us.esd",   // file name — must match offline file on USB
  "languageCode": "en-us",
  "architecture": "x64",           // primary platform x86_64
  "activation": "Retail",         // or Volume
  "size": 5895987847,
  "sizeGB": 5.5,
  "hash": "3fc7cbe5…",            // SHA-256 for download/offline verification
  "hashType": "SHA-256",
  "url": "http://dl.delivery.mp.microsoft.com/…esd",
  "editions": ["Pro", "Home", …]  // editions contained in this image
}
```

### 3.1. OS Source Scanning and Resolution (Step 6)

1. **Offline-first:** Engine scans `EASYDEPLOY\OS\` on all partitions.
   Finds a file matching `fileName`, verifies the SHA-256 hash. Valid → use local file (no network required).
2. **Online download:** No offline file found or hash mismatch.
   Engine downloads from `url` via curl/BITS and verifies the hash after download completes.
3. **Abort:** No network and no valid offline file.
   Engine **stops** and displays an error message.

:::tip
For fully offline deployment, download the `.esd` and copy it to `EASYDEPLOY\OS\` on the USB.
**Do not rename the file** — both the name and SHA-256 hash must match the Catalog.
Download source: <https://esd.coresystem.vn>.
:::

:::caution
**Do not use a DVD or ISO file containing `EASYDEPLOY\OS\`:**
ISO (ISO 9660) may truncate overly long file names.
The installer file will not match `fileName` and will be skipped.
:::

## 4. Summary of File Locations and Roles

| File | Path | Role |
|------|--------|----------|
| `easydeploy.exe` | Embedded in `sources\boot.wim` | Main executable (provided by CoreSystem). |
| `system-config.json` | Inside boot.wim (alongside `easydeploy.exe`) | System configuration — BootBuilder bakes it into `boot.wim` at build time (labels, toolPaths fallback, catalog, telemetry, preshared-key). |
| `user-config.json` | `[USB]:\EASYDEPLOY\` | Deployment and license verification configuration (per customer). |
| `data.json` | Cloud `esd.coresystem.vn` & cache `X:\EasyDeploy\catalog.json` | Catalog of valid Windows Images. |
| `EASYDEPLOY\Profiles\*` | USB | Post-installation configuration profiles (initialized by BootBuilder). |
| `EASYDEPLOY\OS\*` | USB (optional) | OS source for Offline/Hybrid installation (download from esd.coresystem.vn). |
| `Softwares\*` | USB | Portable rescue software and tools (packaged by BootBuilder). |

:::note
The USB structure (boot, `EASYDEPLOY\`, `Softwares\`) is packaged by BootBuilder.
You only customize **`user-config.json`** and **`EASYDEPLOY\Profiles\`**.
System files (`easydeploy.exe`, `system-config.json`, `boot.wim`) are managed by CoreSystem.
:::
