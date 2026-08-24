---
title: 'Hướng dẫn triển khai ban đầu (Getting Started for Customers)'
---

Hướng dẫn chuẩn bị từ khi CoreSystem bàn giao bản quyền đến khi hoàn thành phiên triển khai đầu tiên. Áp dụng cho **quản trị viên khách hàng** (MSP Standard/Advanced).

## 1. Tiếp nhận bản quyền từ CoreSystem

CoreSystem bàn giao cho doanh nghiệp **1 file bản quyền `*.lic`**:

| Sản phẩm | Ý nghĩa |
|----------|---------|
| `*.lic` | License offline (ECDSA P-256, bind USB-SN, kèm tier) — đặt vào `EASYDEPLOY\` trên USB |
| `*.zip` | Bộ phần mềm tương ứng với gói bản quyền đã mua |

- File `.lic` **gắn với USB-SN** của bạn — hãy dùng đúng USB đó để boot; nếu USB bị copy
  sang thiết bị khác, license sẽ không hoạt động (đây là cơ chế bảo vệ tài sản và doanh
  thu của bạn — xem [Nguyên tắc ghi nhận USB-SN](/easydeploy/msp/license-tiers/#nguyên-tắc-ghi-nhận-usb-sn--bảo-vệ-tài-sản-của-msp)).
- Hãy bảo mật file này: ai có file và đúng USB mới có thể triển khai được.

## 2. Thiết lập cấu hình `user-config.json`

Truy cập USB/ISO → thư mục `EASYDEPLOY\` → chỉnh sửa **`user-config.json`**:

```jsonc
{
  "enableF3Express": true,         // bật Express (F3)
  "zeroTouch": false,              // Boot USB → auto F3Express → OOBE (chỉ MSP Advanced, MSP tự chịu trách nhiệm)
  "deploy": {
    "version": "25h2",
    "edition": "Pro",
    "activation": "Retail",        // Home→Retail, Enterprise→Volume, Pro→Retail|Volume
    "languageCode": "en-us",
    "diskNumber": 0,
    "profile": "1.Tweaks"
  }
}
```

:::caution
- License không nằm trong JSON — chỉ cần đặt file `*.lic` vào `[USB]:\EASYDEPLOY\`.
- `deploy.activation` phải đúng theo edition: Home → Retail; Enterprise → Volume; Pro → Retail hoặc Volume. Chọn sai sẽ trỏ tới file không đúng.
- Bản quyền hiện tại chỉ dùng offline license — không cần khai báo mã định danh nào khác.
:::

## 3. Triển khai thiết bị đầu tiên

Sau khi đặt license + cấu hình JSON, USB sẵn sàng hoạt động. Boot vào WinPE → chọn luồng
triển khai phù hợp. Chi tiết quy trình (boot WinPE, luồng cài đặt, giám sát 11 bước) xem
[Quick Start](/easydeploy/getting-started/quick-start/).

## 4. Giám sát hệ thống sau triển khai

- **Telemetry** (sau mỗi phiên deploy hoàn tất):
  - **MSP Advanced:** gửi thông số kỹ thuật (hardware, OS, USB, IP public) về **endpoint
    do bạn cấu hình** (`system-config.json` block `telemetry`) — BYOB.
  - **MSP Standard:** **không gửi máy chủ** — dữ liệu nằm **CSV trên USB**
    (`[USB]:\EASYDEPLOY\Log\deploy-results.csv`), bạn tự import/xử lý.
  - Chi tiết xem [Dữ liệu hệ thống ghi nhận (Telemetry)](/easydeploy/reference/telemetry/).
- **OSCatalog:** mặc định dùng nền tảng `https://esd.coresystem.vn` của CoreSystem. Gói
  **MSP Standard/Advanced** có thể tự chủ nguồn catalog (bật `cloudCatalog` + trỏ
  `catalog.url` về host của bạn) — kèm **gói thiết kế kỹ thuật** do CoreSystem bổ sung
  (xem [License Tiers](/easydeploy/msp/license-tiers/)).

## 5. Danh mục hướng dẫn theo nhu cầu

| Nhu cầu | Hướng dẫn |
|---|---|
| Sử dụng USB/ISO tiêu chuẩn | [Quick Start](/easydeploy/getting-started/quick-start/) |
| MSP muốn tự dựng USB/ISO thương hiệu | [BootBuilder](/easydeploy/msp/bootbuilder/) |
| Tùy biến Windows sau cài (Profiles) | [Profiles Overview](/easydeploy/profiles/profiles/) |
| Gia hạn / nâng cấp gói / re-key | Liên hệ CoreSystem |