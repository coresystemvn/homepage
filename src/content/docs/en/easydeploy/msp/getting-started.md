---
title: 'Initial Deployment Guide (Getting Started for Customers)'
---

Quick guide to get started with **Free** (no license required) or **MSP Advanced** (with `.lic`).

## 1. Download the Binary Duo

On release, CoreSystem packages a **standard distribution bundle shared across all tiers** — file `EasyDeploy-Platform.zip` via R2:

```
[1] EasyDeploy-Platform.zip
├── EasyDeploy.BootBuilder.exe
├── EasyDeploy.BootBuilder.exe.sig   ← YubiKey signature
├── Links.md
└── EasyDeploy\
    ├── EasyDeploy.exe
    ├── EasyDeploy.exe.sig           ← YubiKey signature
    └── system-config.json

[2] SHA256 hash of the .zip file (published with the release)
```

Each `.exe` binary comes with a `.sig` signed by CoreSystem's **YubiKey** — the binary will **self-validate the `.sig` before running** to ensure integrity and prevent repackaging. You can also verify manually:

```powershell
Get-FileHash .\EasyDeploy-Platform.zip -Algorithm SHA256
# compare with the hash published on the website
```

## 2. Prepare the USB

- **Free:** extract `EasyDeploy-Platform.zip` → run `EasyDeploy.BootBuilder.exe` (no `.lic` needed) to auto-build the ISO and write it to USB with Rufus (NTFS if ESD >4GB) — you now have a USB with 2 default profiles (`1.Tweaks`, `2.TweaksApp`), Cloud catalog only.
- **Advanced:** CoreSystem delivers an additional **`*.lic` file** (bound per USB-SN batch) — place it in `[USB]:\EASYDEPLOY\` or `.cache\usb\EASYDEPLOY\` when building. On expiry it will fall back to Free (2 profiles).

## 3. Configure `user-config.json`

On the USB at `EASYDEPLOY\user-config.json`:

```jsonc
{
  "enableF3Express": true,
  "deploy": {
    "version": "25h2",
    "edition": "Pro",
    "activation": "Retail",
    "languageCode": "en-us",
    "diskNumber": 0,
    "profile": "1.Tweaks"
  }
}
```

:::note
Free supports only the 2 default profiles; Advanced supports unlimited profiles and advanced features (details in the technical documentation accompanying the `.lic`).
:::

## 4. Boot and Deploy

Boot the USB into WinPE → choose a flow (Vanilla/Business/Express F3) → follow the 11 steps → reboot into OOBE. For details, see [Quick Start](/en/easydeploy/getting-started/quick-start/).

## 5. Guide Index by Need

| Need | Guide |
|---|---|
| Use standard USB/ISO | [Quick Start](/en/easydeploy/getting-started/quick-start/) |
| Build branded USB/ISO | [BootBuilder](/en/easydeploy/msp/bootbuilder/) |
| Customize Profiles | [Profiles Overview](/en/easydeploy/profiles/profiles/) |
| Renew / upgrade / re-key | Contact `support@coresystem.vn` |
