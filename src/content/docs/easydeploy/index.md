---
title: 'EASYDEPLOY — Hướng dẫn sử dụng'
description: 'Tài liệu triển khai Windows và công cụ cứu hộ trên môi trường WinPE cho đối tác MSP.'
---

**EASYDEPLOY** là giải pháp Windows Deployment hiện đại trên nền WinPE, phát triển bởi **CoreSystem**. Sau khi boot từ USB vào WinPE, hệ thống chạy tự động `easydeploy.exe`. Bạn chỉ cần chọn luồng triển khai, công cụ sẽ cài đặt Windows tự động khép kín (11 bước) và công cụ cũng tích hợp sẵn các tiện ích cứu hộ cho nhu cầu thực tiễn sử dụng.

## Video demo

<video src="/easydeploy/easydeploy.mp4" controls></video>

:::note
Video tua nhanh 10 lần quy trình triển khai Windows hoàn chỉnh qua USB (14'45" -> 1'28").
Thời gian thực tế có thể khác biệt tùy tốc độ mạng và ổ đĩa.
:::

:::note
Tài liệu dành cho **IT Helpdesk, SysAdmin và MSP** sử dụng EASYDEPLOY trên WinPE để triển khai Windows và cứu hộ hệ thống.
**Đối tượng:** Đối tác **MSP (Standard/Advanced)** tự xây dựng USB tùy biến (Whitebox) và chủ động dữ liệu triển khai — tham khảo [License Tiers](/easydeploy/msp/license-tiers/).
:::


## Bắt đầu nhanh

Đây là điểm khởi đầu để bắt đầu sử dụng EASYDEPLOY — lựa chọn phù hợp theo nhu cầu của bạn.

| Mục | Mô tả |
|-----|-------|
| [Quick Start](/easydeploy/getting-started/quick-start/) | Boot USB WinPE và cài Windows trong 5 phút |
| [Các chế độ triển khai](/easydeploy/getting-started/deploy-modes/) | Vanilla / Business / Express (F3) — chọn chế độ phù hợp |
| [Bộ công cụ Rescue](/easydeploy/getting-started/rescue-tools/) | Cứu hộ dữ liệu, sao lưu và chẩn đoán phần cứng |

## MSP & Bản quyền

Quản lý gói dịch vụ, license và tùy biến USB cho MSP.

| Mục | Mô tả |
|-----|-------|
| [License Tiers](/easydeploy/msp/license-tiers/) | Gói Trial / MSP Standard / MSP Advanced, đặc quyền Whitebox và gate telemetry |
| [Bắt đầu cho khách hàng](/easydeploy/msp/getting-started/) | Đặt license `.lic` + cấu hình `user-config.json` để triển khai thiết bị đầu tiên |
| [BootBuilder (Whitebox)](/easydeploy/msp/bootbuilder/) | Tự dựng USB/ISO tùy biến thương hiệu cho MSP Standard/Advanced |

## Chuyên sâu — Tùy biến Profiles

Tùy biến Profiles cho phép kiểm soát cách Windows được cấu hình sau cài đặt.

| Mục | Mô tả |
|-----|-------|
| [Profiles Overview](/easydeploy/profiles/profiles/) | Khái niệm Profile, vị trí lưu trữ và cơ chế inject vào Windows |
| [unattend.xml](/easydeploy/profiles/unattend-xml/) | Tự động hóa Windows Setup / OOBE (tạo tài khoản, autologon, script chạy đầu tiên) |
| [Post-setup.ps1](/easydeploy/profiles/post-setup-ps1/) | Script lần đăng nhập đầu tiên — tinh chỉnh hệ thống và cài đặt ứng dụng |
| [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/) | Thiết lập và kiểm thử Profile chuẩn cho thiết bị mới |

## Tham khảo

Tài liệu tham khảo chi tiết về cấu hình, phím tắt, chế độ offline và xử lý sự cố.

| Mục | Mô tả |
|-----|-------|
| [File cấu hình](/easydeploy/reference/configuration/) | `system-config.json`, `user-config.json` và catalog `data.json` |
| [Phím tắt](/easydeploy/reference/keyboard-shortcuts/) | Danh mục phím tắt trên màn hình chính WinPE |
| [Chế độ Offline](/easydeploy/reference/offline-mode/) | Quản lý license offline và cấu hình nguồn ESD offline/hybrid |
| [Xử lý sự cố](/easydeploy/reference/troubleshooting/) | Lỗi thường gặp và các bước khắc phục |
| [Telemetry](/easydeploy/reference/telemetry/) | Chính sách ghi nhận — cam kết không thu thập dữ liệu cá nhân hay license key |
| [Bảng thuật ngữ](/easydeploy/reference/glossary/) | Thuật ngữ thường dùng (license, catalog, BYOC/BYOB, profile...) |

## Tổng quan kiến trúc

```
Boot (BIOS/UEFI) → USB WinPE → easydeploy.exe (trong sources\boot.wim)
                                    │
        ┌───────────────────────────┼──────────────────────────────┐
        ▼                           ▼                              ▼
  Cài Windows                 Công cụ rescue                (optional) Cloud
  11 bước engine              F1 BitLocker · F2 WiFi ·        License .lic (offline,
  (100% tự động)              F4 Notepad · F5 Diskpart ·      ECDSA, bind USB-SN)
                              F6 PowerShell · F7 Backup ·     Catalog data.json
                              F8 Explorer · F9 HWInfo ·
                              F10 Browser
```

- **Engine `EASYDEPLOY CLI`**: Xử lý trung tâm, tự động hóa quy trình cài Windows chuẩn doanh nghiệp từ Cloud Microsoft. Hỗ trợ linh hoạt chế độ Hybrid và Offline.
- **Bản quyền**: **Offline License** là cơ chế duy nhất — file `*.lic` (ECDSA P-256, bind USB-SN, có license tier) do CoreSystem cấp, đặt trên USB.
- **Nguồn OS**: Hệ thống ưu tiên quét `.esd` trên USB (`EASYDEPLOY\OS\` — phục vụ Offline/Hybrid). Nếu không tìm thấy, engine tải từ Catalog qua internet (xác minh SHA-256). Danh sách ESD tại <https://esd.coresystem.vn>.
- **Profile (tùy biến sau cài đặt)**: Bộ đôi `unattend.xml` và `Post-setup.ps1` trong `EASYDEPLOY\Profiles\<Tên_Profile>\`. Nếu không cấu hình, hệ thống áp dụng **Profile mặc định** (tương đương profile `1.Tweaks`). Chi tiết xem [Profiles Overview](/easydeploy/profiles/profiles/).
- **Công cụ cứu hộ**: Phần mềm Portable trong thư mục `Softwares\` trên USB, đóng gói sẵn qua EasyDeploy-BootBuilder.

## Liên hệ hỗ trợ

- Website: <https://www.coresystem.vn>
- Kho tải file ESD (offline/hybrid): <https://esd.coresystem.vn>
- Bản quyền: Liên hệ CoreSystem để đăng ký và nhận file `*.lic` phù hợp gói dịch vụ.
- MSP Advanced (BYOB): Nhận gói `Reference-Backend` + tài liệu triển khai production-ready để tự host telemetry endpoint.

:::note
**Phạm vi hỗ trợ:** Kênh hỗ trợ trực tiếp dành cho gói **Trial / MSP Standard / MSP Advanced**.
:::
