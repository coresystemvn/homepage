---
title: 'Các gói dịch vụ và Phân quyền (License Tiers)'
---

EASYDEPLOY có hai gói: **Free** dành cho IT/Micro-MSP và **MSP Advanced** dành cho đối tác MSP muốn làm chủ hạ tầng.

## Tổng quan

| Tier | Đối tượng | License | Profiles | Catalog | Bảo mật & Tự động |
|------|-----------|---------|----------|---------|-------------------|
| **Free** | Solo-IT, Micro-MSP, dùng cá nhân | **Không cần** — perpetual | **2** (`1.Tweaks`, `2.TweaksApp`) | **Cloud catalog** + embedded fallback (`esd.coresystem.vn`) | — |
| **MSP Advanced** | MSP có đội ngũ & hạ tầng | **Annual**, bind theo lô **USB-SN** | **Unlimited** | **Self-catalog** | Mã hóa Profile, ZeroTouch, BYOB Telemetry |

:::note
Khi Advanced hết hạn, hệ thống **tự trở về Free (2 profiles)** — trước đó 14 ngày, sẽ có cảnh báo `NearExpiry` trước mỗi lần cài đặt, và còn **ân hạn 14 ngày** sau ngày hết hạn (xem [Offline Mode](/easydeploy/reference/offline-mode/)). Các tính năng Advanced (`profileEncryption`, `zeroTouch`, `self-catalog`, `telemetry`) chỉ có tác dụng khi có license phù hợp — nếu không, cấu hình trong `user-config.json` / `system-config.json` sẽ được bỏ qua. BootBuilder khi đó vẫn build được, chỉ giới hạn còn 2 profiles.
:::

## Gói Free — Dùng ngay, không cần license

- **Đối tượng:** bạn muốn triển khai Windows nhanh, gọn, không ràng buộc — phù hợp đa số nhu cầu Solo-IT, Micro-MSP.
- **License:** không cần, không giới hạn thời gian.
- **Tạo ISO:** unlimited — tải bộ đôi binary `EasyDeploy + BootBuilder` (kèm `links.md`), tự build ISO trên workstation (yêu cầu ADK, PE Addon + PowerShell 7.4).
- **Driver:** industrial standard — đáp ứng đa số nhu cầu máy tính văn phòng.
- **Express Deploy (F3):** có đầy đủ.
- **Hỗ trợ:** Tài liệu tại trang chủ.

> Bộ đôi binary do CoreSystem phát hành, mỗi bản đều có **SHA256 hash** và **chữ ký hash (`.sig`)** — binary tự động validate trước khi chạy để đảm bảo toàn vẹn, tránh rủi ro từ các tập tin bị repack.

## Gói MSP Advanced — Dành cho vận hành quy mô

Kế thừa toàn bộ quyền lợi Free, bổ sung:

| Quyền lợi | Mô tả ngắn |
|-----------|------------|
| **Self-catalog** | Tự host catalog (`catalog.url` + `cloudCatalog`) — chủ động nguồn ESD, kể cả trong LAN |
| **Unlimited Profiles** | Tạo không giới hạn profile riêng ngoài 2 mẫu mặc định |
| **Mã hóa Profile** | Bảo vệ `unattend.xml` + `post-setup.ps1` với preshared-key (`profileEncryption`, `encrypt-profile.ps1`) |
| **Zero Touch** | Boot USB → tự chạy Express không cần F3 (`zeroTouch`) — chỉ nên áp dụng với môi trường kiểm soát |
| **BYOB Telemetry** | Gửi dữ liệu triển khai về endpoint do bạn tự vận hành (`telemetry` block) |
| **Reference-Backend** | Gói thiết kế hạ tầng bổ trợ: Cloudflare Worker + D1 / Node + SQLite (kèm tài liệu production-ready). Vận hành do MSP tự chủ — tính năng kích hoạt qua license enforce ngay trong EasyDeploy |

:::tip
Chi tiết kỹ thuật của nhóm tính năng Advanced được đóng gói trong **tài liệu kỹ thuật kèm `.lic` Advanced** — docs công cộng chỉ giữ phần lõi EasyDeploy + BootBuilder.
:::

## Bảng so sánh nhanh

| Khả năng | Free | Advanced |
|----------|:----:|:--------:|
| Catalog | Cloud + embedded | Self-catalog |
| Profiles | 2 only (1.Tweaks, 2.TweaksApp) | Unlimited |
| Profile Encryption | — | ✅ |
| Backend Telemetry (BYOB) | — | ✅ |
| ISO Creation | ✅ unlimited | ✅ unlimited |
| Driver Integration | ✅ industrial standard | ✅ industrial standard |
| License | Không cần | Annual, USB-SN bound |
| Express Deploy (F3) | ✅ | ✅ |
| ZeroTouch | — | ✅ |
| Support | Docs only | Email (core features, no add-on) |

## Gia hạn & Fallback

- Advanced là **annual subscription theo lô USB-SN**. Khi hết hạn, bạn vẫn dùng được ở **chế độ Free (2 profiles)**.
- Cần gia hạn, cấp lại (re-key) khi USB hỏng/mất, hoặc nâng Free lên Advanced — liên hệ `support@coresystem.vn`. Mọi thao tác cấp phép do CoreSystem quản lý tập trung.

## Ghi chú về USB-SN (áp dụng cho Advanced)

Với Advanced, mỗi USB là một “thẻ triển khai” bind theo SN — sao chép sang USB khác sẽ không hoạt động. Dữ liệu USB-SN chỉ nằm tại USB (CSV) hoặc endpoint BYOB do bạn tự host — CoreSystem không lưu trữ.

### 3 lớp bảo vệ USB

USB của MSP là tài sản tạo ra doanh thu — hệ thống bảo vệ theo 3 lớp:

| Lớp | Cơ chế | Ngăn chặn |
|-----|--------|-----------|
| **1. Physical** | Tự bảo quản thiết bị vật lý | Mất trộm, thất lạc USB |
| **2. License bind USB-SN** | License ký ECDSA P-256, gắn chặt serial number của USB | Clone USB — bản sao không chạy được, tránh hao hụt license |
| **3. Profile encryption** | Mã hóa `unattend.xml` + `post-setup.ps1` bằng preshared-key | Leak dữ liệu cấu hình khi USB rơi vào tay người khác |

:::caution
**Trách nhiệm bảo vệ preshared-key thuộc về MSP.** Key nằm trong cấu hình để bạn **chủ động thay đổi profile mà không phải chờ CoreSystem build lại exe** — đổi lại, nếu người khác boot được vào WinPE trên USB, key có thể bị đọc. Kết hợp cả 3 lớp trên: khóa physical, bind USB-SN, và mã hóa profile.
:::
