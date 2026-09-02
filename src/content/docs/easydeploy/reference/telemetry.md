---
title: 'Chính sách Telemetry'
---

:::caution
**CoreSystem không thu thập dữ liệu triển khai.** Mọi dữ liệu chỉ nằm tại **USB của bạn** (CSV) hoặc **endpoint do bạn tự host** (MSP Advanced BYOB).
:::

## CoreSystem cam kết không thu thập

- Dữ liệu cá nhân (tên, tài khoản, mật khẩu, email)
- Nội dung Profile (`unattend.xml`, `Post-setup.ps1`, tweaks)
- Thông tin license (`*.lic`, `user-config.json`)
- Dữ liệu trên ổ cứng máy trạm

## Dữ liệu được ghi nhận (tùy chọn)

Sau mỗi phiên deploy, hệ thống ghi 1 nhóm thông số kỹ thuật:

| Trường | Ví dụ | Ý nghĩa |
|--------|-------|---------|
| `machine_id` | `A1B2-…` | Mã thiết bị ngẫu nhiên (không gắn cá nhân) |
| `model` | `Dell Latitude 5440` | Model máy |
| `cpu` / `ram` / `disk` | `i5-1335U` / `16 GB` / `512 GB SSD` | Phần cứng |
| `usb_brand` / `usb_serial` | `SanDisk` / `4C530001…` | Thông tin USB boot |
| `os_build` / `os_edition` / `os_version` | `26200.8873` / `Pro` / `25h2` | Phiên bản OS |
| `ip_address` | — | IP công cộng (do server ghi) |

## Lưu trữ dữ liệu

| Gói | Lưu trữ |
|-----|---------|
| **Free** | CSV trên USB (`EASYDEPLOY\Log\deploy-results.csv`) — không gửi đi đâu |
| **MSP Advanced** | Gửi về **endpoint do bạn cấu hình** trong `system-config.json` (block `telemetry`) — chi tiết trong tài liệu kỹ thuật kèm `.lic` |

:::note
Để tắt telemetry (MSP Advanced): đặt `"enabled": false` trong block `telemetry`. Free luôn tắt — dữ liệu chỉ nằm CSV trên USB.
:::

## Câu hỏi thường gặp

**CoreSystem có nhận dữ liệu của tôi không?**
Không. Dữ liệu chỉ nằm tại USB hoặc endpoint của bạn.

**Có thể tắt telemetry không?**
MSP Advanced: `"enabled": false` trong `system-config.json`. Free: luôn tắt.

**CoreSystem có đọc Profile của tôi không?**
Không. Profile chỉ lưu trên USB và chạy cục bộ trên máy trạm.