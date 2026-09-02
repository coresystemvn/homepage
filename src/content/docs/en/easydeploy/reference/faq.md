---
title: 'Frequently Asked Questions (FAQ)'
---

Frequently asked questions when using EASYDEPLOY, compiled from the Docs and Troubleshooting. If you do not find your issue here, see the detailed topics in
[Troubleshooting](/en/easydeploy/reference/troubleshooting/).

## License

### Why do I see "Invalid / expired / wrong USB license"?

The license (`*.lic`) is bound to the USB-SN and has an expiry date. Verify:

- The `*.lic` file is placed correctly in `EASYDEPLOY\` on the **correct registered USB**.
- The license has not expired and the service tier matches the features in use.

If the error persists, contact CoreSystem for a re-issue or re-key (when the USB is damaged/lost).
Details: [Troubleshooting](/en/easydeploy/reference/troubleshooting/).

### Does low-quality USB affect licensing?

Possibly. The license is bound to the USB's serial number (SN) — some low-cost USB drives lack a standard SN
or share duplicate SNs across units, causing the license to be recognized incorrectly. Use branded USB drives with
stable firmware (see [License Tiers](/en/easydeploy/msp/license-tiers/)).

## Deployment

### No disk visible when selecting the target?

Typically caused by a missing storage/controller driver (e.g., Intel RST/VMD, RAID). The standard USB covers
common hardware well; for specialized hardware, add the driver via BootBuilder
(see [BootBuilder](/en/easydeploy/msp/bootbuilder/)).

### Windows is not activated after installation?

EASYDEPLOY only orchestrates the installation process and **does not handle Windows activation**.
Activation follows the customer's model (Retail, Volume/KMS, MAK, etc.). Clarify the activation model when preparing the configuration (see [Deployment Modes](/en/easydeploy/getting-started/deploy-modes/)).

### "Offline image hash mismatch" error?

The local `.esd` file has been renamed, modified, or corrupted — it does not match the hash in the Catalog.
Re-use the exact file downloaded from the Catalog (see [Troubleshooting](/en/easydeploy/reference/troubleshooting/)).

## Service Tier

### Where is my telemetry data?

- **Free:** CSV on the USB — `[USB]:\EASYDEPLOY\Log\deploy-results.csv`.
- **MSP Advanced:** Sent to your self-hosted endpoint (BYOB) — see the technical documentation bundled with the `.lic`.

CoreSystem does not receive your data (see [Telemetry](/en/easydeploy/reference/telemetry/)).

## Other

### Cannot connect to WiFi in WinPE?

Check the SSID/password, or the WiFi card may not be supported by WinPE — you need to integrate the driver via
BootBuilder (see [Troubleshooting](/en/easydeploy/reference/troubleshooting/)).

### Which flow should I use: Vanilla, Business, or Express?

- **Vanilla (1):** Install clean Windows with no customization.
- **Business (2):** Install with an enterprise profile.
- **Express (F3):** Automated via pre-configured settings — suitable for large-scale deployment.

Details at [Deployment Modes](/en/easydeploy/getting-started/deploy-modes/).
