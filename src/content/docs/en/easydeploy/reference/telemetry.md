---
title: 'Telemetry Policy'
---

:::caution
**CoreSystem does not collect deployment data.** All data remains only on **your USB** (CSV) or at an **endpoint you self-host** (MSP Advanced BYOB).
:::

## CoreSystem Commitment — No Collection

- Personal data (name, account, password, email)
- Profile contents (`unattend.xml`, `Post-setup.ps1`, tweaks)
- License information (`*.lic`, `user-config.json`)
- Data on the workstation's hard drive

## Data Recorded (Optional)

After each deployment session, the system records one set of technical parameters:

| Field | Example | Meaning |
|--------|-------|---------|
| `machine_id` | `A1B2-…` | Random device identifier (not linked to an individual) |
| `model` | `Dell Latitude 5440` | Device model |
| `cpu` / `ram` / `disk` | `i5-1335U` / `16 GB` / `512 GB SSD` | Hardware |
| `usb_brand` / `usb_serial` | `SanDisk` / `4C530001…` | Boot USB information |
| `os_build` / `os_edition` / `os_version` | `26200.8873` / `Pro` / `25h2` | OS version |
| `ip_address` | — | Public IP (recorded by the server) |

## Data Storage

| Tier | Storage |
|-----|---------|
| **Free** | CSV on the USB (`EASYDEPLOY\Log\deploy-results.csv`) — not sent anywhere |
| **MSP Advanced** | Sent to the **endpoint you configure** in `system-config.json` (the `telemetry` block) — see the technical documentation bundled with the `.lic` |

:::note
To disable telemetry (MSP Advanced): set `"enabled": false` in the `telemetry` block. Free is always disabled — data remains only in the CSV on the USB.
:::

## Frequently Asked Questions

**Does CoreSystem receive my data?**
No. Data remains only on your USB or at your endpoint.

**Can telemetry be disabled?**
MSP Advanced: `"enabled": false` in `system-config.json`. Free: always disabled.

**Does CoreSystem read my Profiles?**
No. Profiles are stored only on the USB and executed locally on the workstation.
