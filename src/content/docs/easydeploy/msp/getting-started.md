---
title: 'Hướng dẫn triển khai ban đầu (Getting Started for Customers)'
---

Hướng dẫn nhanh để bạn bắt đầu với **Free** (không cần license) hoặc **MSP Advanced** (có `.lic`).

## 1. Tải bộ đôi binary

Khi phát hành, CoreSystem đóng gói **gói phân phối tiêu chuẩn cho mọi tier** dùng chung — file `EasyDeploy-Platform.zip` qua R2:

```
[1] EasyDeploy-Platform.zip
├── EasyDeploy.BootBuilder.exe
├── EasyDeploy.BootBuilder.exe.sig   ← chữ ký YubiKey
├── Links.md
└── EasyDeploy\
    ├── EasyDeploy.exe
    ├── EasyDeploy.exe.sig           ← chữ ký YubiKey
    └── system-config.json

[2] SHA256 hash của file .zip (công bố kèm bản phát hành)
```

Mỗi binary `.exe` đều đi kèm `.sig` được ký bằng **YubiKey** của CoreSystem — binary sẽ **tự validate `.sig` trước khi chạy** để đảm bảo toàn vẹn, tránh repack. Bạn cũng có thể tự kiểm tra:

```powershell
Get-FileHash .\EasyDeploy-Platform.zip -Algorithm SHA256
# so sánh với hash công bố trên website
```

## 2. Chuẩn bị USB

- **Free:** giải nén `EasyDeploy-Platform.zip` → chạy `EasyDeploy.BootBuilder.exe` (không cần `.lic`) để tự build ISO, ghi ra USB bằng Rufus (NTFS nếu ESD >4GB) — bạn đã có USB với 2 profiles mặc định (`1.Tweaks`, `2.TweaksApp`), Cloud catalog only.
- **Advanced:** CoreSystem bàn giao thêm **file `*.lic`** (bind theo lô USB-SN) — đặt vào `[USB]:\EASYDEPLOY\` hoặc `.cache\usb\EASYDEPLOY\` khi build. Hết hạn sẽ fallback về Free (2 profiles).

## 3. Thiết lập `user-config.json`

Trên USB `EASYDEPLOY\user-config.json`:

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
Free chỉ dùng 2 profiles mặc định; Advanced mới dùng unlimited và các tính năng nâng cao (chi tiết trong tài liệu kỹ thuật kèm `.lic`).
:::

## 4. Boot và triển khai

Boot USB vào WinPE → chọn luồng (Vanilla/Business/Express F3) → theo dõi 11 bước → reboot vào OOBE. Chi tiết xem [Quick Start](/easydeploy/getting-started/quick-start/).

## 5. Danh mục hướng dẫn theo nhu cầu

| Nhu cầu | Hướng dẫn |
|---|---|
| Sử dụng USB/ISO tiêu chuẩn | [Quick Start](/easydeploy/getting-started/quick-start/) |
| Tự dựng USB/ISO thương hiệu | [BootBuilder](/easydeploy/msp/bootbuilder/) |
| Tùy biến Profiles | [Profiles Overview](/easydeploy/profiles/profiles/) |
| Gia hạn / nâng cấp / re-key | Liên hệ `support@coresystem.vn` |
