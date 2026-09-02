---
title: 'EASYDEPLOY — Hướng dẫn sử dụng'
description: 'Tài liệu triển khai Windows và công cụ cứu hộ trên môi trường WinPE cho đối tác MSP.'
---

**EASYDEPLOY** là giải pháp triển khai Windows hiện đại trên nền WinPE, phát triển bởi **CoreSystem**. Boot USB vào WinPE, `easydeploy.exe` sẽ tự chạy. Bạn chỉ cần chọn luồng triển khai, hệ thống sẽ tự hoàn tất cài đặt Windows (11 bước khép kín, hoàn toàn tự động) cũng như trang bị sẵn sàng các tiện ích cứu hộ khi cần.

## Video demo

<video src="/easydeploy/easydeploy.mp4" controls></video>

:::note
Video tua nhanh 10 lần quy trình triển khai Windows hoàn chỉnh qua USB (14'45" → 1'28").
Thời gian thực tế có thể khác biệt tùy tốc độ mạng và ổ đĩa.
:::

:::note
Tài liệu dành cho **IT Helpdesk, SysAdmin và MSP** sử dụng EASYDEPLOY trên WinPE để triển khai Windows và cứu hộ hệ thống.
:::


## Bắt đầu nhanh

Đây là điểm khởi đầu để bắt đầu sử dụng EASYDEPLOY — lựa chọn phù hợp theo nhu cầu của bạn.

| Mục | Mô tả |
|-----|-------|
| [Quick Start](/easydeploy/getting-started/quick-start/) | Boot USB WinPE — Windows tự cài hết trong ~15 phút |
| [Các chế độ triển khai](/easydeploy/getting-started/deploy-modes/) | Vanilla / Business / Express (F3) — chọn chế độ phù hợp |
| [Bộ công cụ Rescue](/easydeploy/getting-started/rescue-tools/) | Cứu hộ dữ liệu, sao lưu và chẩn đoán phần cứng |

## MSP & Bản quyền

Quản lý gói dịch vụ và tùy biến USB cho MSP.

| Mục | Mô tả |
|-----|-------|
| [License Tiers](/easydeploy/msp/license-tiers/) | **Free** (perpetual, 2 profiles) / **MSP Advanced** (annual, unlimited) |
| [Bắt đầu cho khách hàng](/easydeploy/msp/getting-started/) | Chuẩn bị USB + cấu hình `user-config.json` để triển khai thiết bị đầu tiên |
| [BootBuilder (Whitebox)](/easydeploy/msp/bootbuilder/) | Tự dựng USB/ISO tùy biến — Free (2 profiles) và Advanced (unlimited) |

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

**EasyDeploy là trái tim của giải pháp** — engine `easydeploy.exe` nằm trong `sources\boot.wim` đảm nhận phần triển khai. **BootBuilder** giúp bạn tạo USB WinPE chỉ với vài cú click chuột thay vì mất hàng tuần xử lý lỗi liên quan driver và môi trường WinPE.

![Kiến trúc EasyDeploy — 2 pha Build & Deploy](/easydeploy/architecture.svg)

```
[Pha Build — Workstation]                [Pha Deploy — WinPE]
EasyDeploy.zip + ESD + Drivers/Wallpaper → USB boot → easydeploy.exe (trong boot.wim)
        ↓ BootBuilder (.cache → ISO → Rufus)           │
                                 ┌─────────────────────┼──────────────────────┐
                                 ▼                     ▼                      ▼
                            Cài Windows           Công cụ rescue         Cloud (tùy chọn)
                            11 bước engine        F1 BitLocker · F2 WiFi  License .lic (offline, Advanced)
                            (100% tự động)        F4 Notepad · F5 Diskpart  Catalog data.json
                                                  F6 PowerShell · F7 Backup
                                                  F8 Explorer · F9 HWiNFO
                                                  F10 Browser · F11 About · F12 Shutdown
```

- **Engine `EASYDEPLOY CLI`**: tự động hóa quy trình cài Windows chuẩn doanh nghiệp — chưa đầy 5 phút cho trọn 11 bước bung cài, cộng khoảng 10 phút hậu kỳ tự động; hỗ trợ cả Hybrid và Offline.
- **Bản quyền**: với **Advanced** dùng **Offline License** — file `*.lic` (ECDSA P-256, bind USB-SN) đặt trên USB. **Bản Free thì không cần license**.
- **Nguồn OS**: ưu tiên `.esd` có sẵn trên USB (`EASYDEPLOY\OS\`); nếu không có, tải từ Catalog qua internet (có xác minh SHA-256). Tra cứu link tải ESD tại <https://esd.coresystem.vn>.
- **Profile**: cặp file `unattend.xml` và `Post-setup.ps1` trong `EASYDEPLOY\Profiles\<Tên_Profile>\`. **Free có sẵn 2 profiles** (`1.Tweaks`/`2.TweaksApp`) — bạn sửa thẳng vào đó là đủ; tạo thêm sẽ không có tác dụng (mẹo: giữ kho profile ở máy trạm, ghi đè nội dung vào 2 folder gốc khi cần). **Advanced thì không giới hạn** — xem [Profiles Overview](/easydeploy/profiles/profiles/).
- **Cứu hộ**: các công cụ Portable trong `Softwares\` trên USB — không đi kèm bộ phát hành, bạn tự chọn công cụ và bổ sung qua BootBuilder (kỳ build) hoặc copy thủ công + `user-config.json`.

### Hệ sinh thái mở rộng (dành cho MSP Advanced)

Khi cần chủ động hơn, Advanced có thêm:

- **BYOC** — tự host catalog & ESD (kể cả trong LAN).
- **BYOB** — tự host endpoint ghi nhận telemetry để hỗ trợ thống kê.
- **Bảo mật Profile & ZeroTouch** — mã hóa profile bằng preshared-key, tự động Boot USB → tự động cài đặt (dùng trong môi trường kiểm soát).
- **Reference-Backend** — gói thiết kế hạ tầng tham khảo cho BYOB (telemetry) để triển khai nhanh.

> Với **Free**, một số khóa liên quan trong `system-config.json`/`user-config.json` dù bạn chủ động thiết lập cũng **không có tác dụng khi chạy** — hệ thống sẽ dùng mặc định. Chi tiết xem [File cấu hình](/easydeploy/reference/configuration/). Phần nâng cao có tài liệu riêng kèm `.lic` Advanced.

## Bảo mật tải xuống

Bộ đôi binary `EasyDeploy + BootBuilder` được phát hành bởi CoreSystem. Mỗi bản đều có **SHA256 hash** và **chữ ký hash YubiKey (`.sig`)** — binary tự validate trước khi chạy để đảm bảo tính toàn vẹn, tránh repack. Chi tiết xem [Bắt đầu cho khách hàng](/easydeploy/msp/getting-started/).

## Liên hệ hỗ trợ

- Website: <https://www.coresystem.vn>
- Kho tra cứu link tải ESD (offline/hybrid): <https://esd.coresystem.vn>
- **Free:** Docs only — đủ cho Solo-IT, Micro-MSP.
- **MSP Advanced:** Email hỗ trợ core features (không bao gồm add-on) — liên hệ `support@coresystem.vn`; tư vấn gói Advanced: `inquiry@coresystem.vn`.

:::note
**Phạm vi hỗ trợ:** **Free** — Docs only; **MSP Advanced** — Email (core features, không hỗ trợ add-on).
:::
