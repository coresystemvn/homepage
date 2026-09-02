---
title: 'Offline and Hybrid Mode'
---

EASYDEPLOY supports offline operation in two areas: **License Verification** and **OS Installation Source**.
Designed for isolated or internet-restricted network environments.

:::note
Look up `.esd` download links at the **ESD Catalog (<https://esd.coresystem.vn>)** — a catalog of download links from Microsoft's official distribution channel, complete with SHA-256 for verification. Files matching the Catalog — simply copy to the USB and use.
:::

:::note
The embedded catalog in EasyDeploy lists build 26200.8873 for 25H2. For 100% offline scenarios, download the exact ESD version to ensure deployment proceeds as planned.
:::

## 1. Offline License Verification

> **Place the `.lic` file received from CoreSystem into `EASYDEPLOY\` on the USB:**

```
[USB]:\EASYDEPLOY\<file_name>.lic
```

- **Contents of `*.lic`:** Issued by CoreSystem, digitally signed (cannot be created or modified manually). Contains the enterprise name, expiry date, permitted USB-SN list, and service tier.
- **USB Binding:** The license is bound to ≥1 USB-SN. If the USB is not on the list, the system reports *"License is bound to a different USB drive."* — preventing license copying.
  See [Note on USB-SN](/en/easydeploy/msp/license-tiers/#note-on-usb-sn-applies-to-advanced) for details.
- **License Tier:** The service tier (`free`/`advanced`) is recorded in the license (only Advanced has a `*.lic`; Free requires none). See [License Tiers](/en/easydeploy/msp/license-tiers/).
- **Activation:** No additional configuration is required. Place the `.lic` on the USB — the system authenticates automatically without requiring a network connection.

:::caution
Licenses are centrally issued and signed by CoreSystem — you cannot create them yourself.
Contact CoreSystem for renewal or USB replacement.
:::

### 1.1. Common License Error Messages

| Error Message | Meaning |
|-----------|---------|
| `License is not valid.` | Invalid license — missing characters or incorrect digital signature. |
| `License is bound to a different USB drive.` | The USB is not in the bound `Usb` list. |
| `Please check your BIOS time settings.` | The RTC clock in BIOS is too far behind the validity period. |
| `Please contact CoreSystem to renew your license.` | The license has expired and exceeded the grace period. |
| `NearExpiry` warning | License expiring soon (less than 14 days remaining) — warning before installation. |

## 2. Offline OS Source Management

EASYDEPLOY follows an **Offline-first** principle — it prioritizes local sources when scanning for the Windows image.
This applies to both online and offline versions. The `.esd` file is placed in `EASYDEPLOY\` on the USB and supports two structures:

```
[drive_letter]:\EASYDEPLOY\OS\<file_name>.esd               → Single file
[drive_letter]:\EASYDEPLOY\OS\<folder_name>\<file_name>.esd   → Categorized in subfolders
```

- **Identification:** The `.esd` name must exactly match `fileName` in the Catalog, with SHA-256 hash verification.
- **Success:** Valid local file → fully offline installation, no network required.
- **Fallback:** File not found or SHA-256 mismatch → engine falls back to the Cloud CDN. If both fail → the system stops and reports an error.
- **Hybrid Mode:** An empty `OS` folder is still valid — EASYDEPLOY will download the file over the internet automatically.

:::tip
Visit **<https://esd.coresystem.vn>** to look up the download link for the installation file — select the appropriate Build, Edition, and Language.
Place it in `EASYDEPLOY\OS\` on the USB.
:::

:::danger
**Do not store `EASYDEPLOY\OS\` on DVD or ISO.** The Joliet format truncates file names exceeding 64 characters when mounted in WinPE.
The file name will not match `fileName` in the Catalog — the engine will skip the local file and attempt a network connection.
:::

## 3. Summary of Fully Offline Operation (Offline Mode)

| Configuration File | Setting |
|------|----------|
| `system-config.json` | No authentication setup required. `catalog.cloudCatalog:false` → embedded catalog (100% offline, all tiers); a self-hosted `url` is BYOC (Advanced). |
| USB `EASYDEPLOY\` | Place the `*.lic` file issued by CoreSystem (no JSON flag required). |
| USB `EASYDEPLOY\OS\` | Copy a valid `.esd` file (downloaded from esd.coresystem.vn, matching `fileName` in the Catalog). |

:::tip
OS installation does not require a network. `post-setup.ps1` will still run normally if the workstation requires internet.
Automatic resource download steps are skipped when `$HasInternet = $false`.
:::
