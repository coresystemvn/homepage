---
title: 'BootBuilder (Whitebox) — Build Custom USB/ISO'
---

**EasyDeploy.BootBuilder** is a Windows workstation application for building custom **USB/ISO WinPE** media. The tool prepares resources in the `.cache` folder, integrates hardware drivers, and exports a bootable ISO image to be written to USB.

:::note
**Eligibility:** BootBuilder is available for **all tiers**. Both **Free** and **Advanced** can build — the only difference is the number of profiles copied into the ISO. For details, see [License Tiers](/en/easydeploy/msp/license-tiers/).
:::

:::caution
**Antivirus Warning:** The `EasyDeploy.BootBuilder.exe` binary is not yet digitally signed. Some antivirus products may flag or block it on launch. Add the file to the exclusion list on your workstation. This is common for unsigned executables. Always download from the official link provided by CoreSystem.
:::

## 1. Prerequisites

1. Download the toolkit containing `EasyDeploy.BootBuilder.exe` and the `links.md` guide (distributed by CoreSystem). Launch with administrator privileges (**Run as administrator**).
2. On first launch, the application **automatically creates** the `.cache` folder alongside the executable. It also initializes a configuration template (`user-config.json`) and 2 default profiles. You only need to add the required files to the correct subfolders inside `.cache` (see table below) — **do not delete `.cache`**.

### Resource Inventory in the `.cache` Folder

| Folder | Contents | Required |
|----------|----------|:--------:|
| `esd\` | Windows 11 installation ESD file (`*.esd` format) | ✅ |
| `apps\` | Executables `EasyDeploy.exe`, `EasyDeploy.exe.sig` and configuration file `system-config.json` | ✅ |
| `downloads\` | Hardware drivers organized by vendor: `dell\`, `hp\`, `intel\`, `intel-wifi\`, `lenovo\`, `others\` | ⭕ |
| `wallpaper\` | Image `wallpaper.jpg` or `winpe.jpg` for WinPE background customization | ⭕ |
| `usb\` | USB payload: folder `EASYDEPLOY\` (configurations, profiles), `.lic` license + `Softwares\` (Portable rescue tools) | ⭕ |

:::caution
The tool operates fully offline and **does not automatically download resources from the internet**. You must download and place them in the correct folders in advance. Missing a required file → the UI shows a **red warning**; open `links.md` for download links. Missing an optional file → yellow warning, build will still succeed.
:::

:::caution
For security, BootBuilder verifies the signatures of `EasyDeploy.exe` and `EasyDeploy.exe.sig` to confirm they are authentic files supplied by CoreSystem before allowing the ISO build.
:::

### System Software Requirements (one-time setup on the workstation)

| Component | Technical Notes |
|------------|---------|
| **Windows ADK** + **WinPE add-on** | Install the same ADK version, compatible with the Windows ESD version in use. |
| **PowerShell 7.4+** | Required for the build engine — standard edition is sufficient. |

:::note
The latest ADK is 24H2, which supports ESDs with build 26100 (24H2) and 26200 (25H2).
:::

## 2. Pre-check

Launch the tool → click **Refresh Precheck** → Ensure all items show a green check (✓) before building the ISO:

| Check Item | Required | Technical Meaning |
|----------|:--------:|---------|
| PowerShell 7.4+ | ✅ | Script build execution environment. |
| ADK + WinPE add-on | ✅ | Windows ADK development toolkit, must be compatible with the ESD file. |
| ESD (`.cache\esd`) | ✅ | Validates existence of the source OS installation file. |
| Apps (`.cache\apps`) | ✅ | Complete EasyDeploy binaries and system configuration file. BootBuilder **verifies the YubiKey signature** of `EasyDeploy.exe` to ensure the file has not been tampered with. |
| Drivers (`.cache\downloads`) | ⭕ | Required only when the target device needs specific network or storage drivers. |
| Wallpaper (`.cache\wallpaper`) | ⭕ | Background image. If missing, the default background is used. |

:::note
The `Apps` pre-check will report `Signature verified (YubiKey signed by CoreSystem)` when `EasyDeploy.exe` is intact. BootBuilder has the public key embedded to verify it — if `EasyDeploy.exe` fails signature validation, **ISO building will be blocked**. This safety gate prevents you from creating a USB from a repacked file.
:::

## 3. Building the ISO (Build ISO)

1. When all pre-check conditions pass (green checks), click **⚙️ Build ISO** to start.
2. **Select license (if applicable):** The `EasyDeploy License` dialog will prompt `Do you have an EasyDeploy license to unlock all features?`
   - Select **Continue without license** — build in **Free** mode: only the **2 default profiles** (`1.Tweaks`, `2.TweaksApp`) are copied into the ISO.
   - Select **I have a license** → choose the `*.lic` file (digitally signed, bound to USB-SN) → BootBuilder verifies it → saves to `.cache\usb\EASYDEPLOY\` → build in **Advanced** mode: **unlimited profiles** are automatically copied into the ISO.

   - **Driver Selection:** 6 toggles for driver packages (Dell, HP, Intel Ethernet, Intel Wireless, Lenovo, Others) — **default ON**. Enable only the vendors matching your target hardware. Disabling a driver package only excludes it from the ISO and will not cause a build failure.
     - **Others option:** For devices not covered by the 5 groups above. Extract the driver package (containing `*.inf` files) into `.cache\downloads\others\` (each subfolder = 1 driver package); the tool will automatically integrate it into the ISO.

:::note
The Dell, HP, Intel, Lenovo + WinRE driver packs cover most office PCs. Others is only needed for specialized models (Acer, Asus, Japan/Korea/China domestic models). **You must use WinPE 10/11 drivers**, not regular Windows drivers, to avoid conflicts.
:::


   - **CA2023:** Also generate `bootmedia_ca2023.iso` — an ISO supporting Secure Boot with the CA 2023 certificate set (the updated certificates for newer firmware/machines). **Default OFF** — enable only when Secure Boot is enabled on the target machine.
3. Click **OK — Start Build** to package → Monitor progress and logs in the Console Log window:
   - **First build:** **22–25 minutes** (system initializes structure and cache).
   - **Subsequent builds:** Approximately **12 minutes**.
4. **Output files:** `bootmedia.iso` (and `bootmedia_ca2023.iso` if the CA2023 option is enabled). Select **📁 Output Folder** to open the folder containing the ISO, or **💾 Save Log** to export the build log.

:::caution
**Writing the ISO to USB:** Use **Rufus** to write the ISO to a bootable USB. If you need to copy the `.esd` file (>4 GB) to the USB, the USB **must be formatted as NTFS** (FAT32 does not support single files >4 GB). Select NTFS in Rufus before writing.
:::

## 4. USB Directory Structure After Packaging

```
[USB]:
├── bootmgr, bootmgr.efi
├── Boot\  EFI\  en-us\  sources\     ← WinPE boot partition (EasyDeploy.exe integrated in boot.wim)
├── EASYDEPLOY\
│   ├── user-config.json               ← Deployment configuration
│   ├── license.lic                    ← Offline license (place here, embedded into ISO)
│   ├── Profiles\                      ← Custom profiles (default 1.Tweaks and 2.TweaksApp)
│   └── OS\                            ← (Optional) Offline/hybrid OS installation source
└── Softwares\                         ← Portable rescue software and tools
```

## 5. Quick Customization

| Goal | Action |
|----------|--------|
| Change WinPE wallpaper | Place an image named `wallpaper.jpg` or `winpe.jpg` in `.cache\wallpaper\` |
| Customize post-install Profile | Edit configuration or scripts in `usb\EASYDEPLOY\Profiles\` — Free: 2 profiles, Advanced: unlimited (details bundled with Advanced `.lic`) |
| Add rescue tools | Copy Portable software into `usb\Softwares\` (apps are not included in the release package — bring your own; keep the `toolPaths` folder structure or declare it in `user-config.json`; unlimited count — extras run via F6/F8/cmd) |
| Add drivers for other vendors (Others) | Extract the driver package containing `*.inf` into `.cache\downloads\others\` (each subfolder = 1 driver package). Use the vendor's WinPE 10/11 drivers. |
| Select driver packages | Use the toggle switches in the build settings UI |

## 6. Safe Operation Recommendations

- **Power:** Disable automatic sleep during the build (especially the first build, ~22–25 minutes) to avoid interruption.
- **Conflicts:** Do not run **2 build processes simultaneously** on the same `.cache` folder.
- **Power loss:** If interrupted, relaunch the tool — the system automatically cleans up temporary files and resumes normally.

## 7. Next Steps

After successfully exporting the ISO: Write the ISO to USB with Rufus → configure `user-config.json` for the customer (see [Getting Started with EASYDEPLOY](/en/easydeploy/msp/getting-started/) or [Quick Start](/en/easydeploy/getting-started/quick-start/)) → hand over the USB to the technician or customer.
