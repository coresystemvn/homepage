---
title: 'Tài liệu cấu hình chi tiết'
---

EASYDEPLOY đọc và phân tích tham số từ **hai tệp tin JSON**.

## 1. Tệp tin system-config.json — Cấu hình hệ thống

Tệp tin nằm cùng thư mục với `easydeploy.exe`.
Đóng gói sẵn trong `EasyDeploy.zip` do CoreSystem phát hành.

Tệp chứa thiết lập về nhãn nút bấm, đường dẫn công cụ cứu hộ.
Cũng bao gồm hành vi hệ thống, telemetry và OS Catalog.

```jsonc
{
  "_comment": "EASYDEPLOY configuration — edit this file to custom labels, and tool paths without recompiling.",
  "labels": {
    "flow1Title": "SETUP WINDOWS [DEFAULT]",
    "flow1Desc": "Clean install Windows operating system",
    "flow2Title": "SETUP WINDOWS [BUSINESS]",
    "flow2Desc": "Deploy Windows OS with business profile",
    "aboutInfo": "EASYDEPLOY | Business Windows Deployment …",
    "toolMultiDriveLabel": "DISK BACKUP",
    "toolExplorerLabel": "FILE EXPLORER",
    "toolHwInfoLabel": "HARDWARE INFO",
    "toolBrowserLabel": "WEB BROWSER"
  },
  "toolPaths": {
    "multiDrive": "MultiDrive\\MultiDrive.exe",
    "explorer": "Explorer++\\Explorer++.exe",
    "hwInfo": "HWInfo\\HWINFO64.exe",
    "browser": "Palemoon\\Palemoon.exe"
  },
  "behavior": {
    "defaultWifiSsid": "",
    "defaultWifiPassword": ""
  },
  "catalog": {
    "url": "https://esd.coresystem.vn/data.json",
    "timeoutSeconds": 30,
    "downloadMethod": "auto",
    "cloudCatalog": true
  },
  "profileEncryption": {
    "enabled": false,
    "passphrase": ""
  }
}
```

| Cấu trúc khóa | Ý nghĩa sử dụng |
|------|---------|
| `labels` | Nhãn cho 2 luồng cài đặt chính, nút chức năng cứu hộ và hộp thoại About. |
| `toolPaths` | Đường dẫn tương đối trỏ tới các công cụ cứu hộ — tự động vào `Softwares\` trên USB. |
| `behavior` | WiFi mặc định (`defaultWifiSsid`/`defaultWifiPassword`). Cooldown phím F2: 3 giây (mặc định, không cấu hình). |
| `catalog` | Nguồn OS Catalog (`url`, `timeoutSeconds`, `downloadMethod`) + cờ `cloudCatalog`. Cache: `X:\EasyDeploy\catalog.json` (mặc định). |
| `profileEncryption` | Mã hóa profile (`enabled` + `passphrase`). Chỉ **MSP Advanced**, `enabled: true` khi đã mã hóa profile bằng `encrypt-profile.ps1`. Mặc định `false`. |

:::note
**BYOC (tự host catalog):** Bạn có thể trỏ `catalog.url` về catalog tự host.
Xem gói OSCatalog cho MSP. Tự host hạ tầng nằm ngoài phạm vi hỗ trợ của EASYDEPLOY.
:::

### 1.1. Xác thực bản quyền — Offline License (duy nhất)

> EASYDEPLOY dùng **Offline License** — không có khối `auth` trong `system-config.json`. Chỉ cần đặt file `*.lic` (do CoreSystem cấp) vào `EASYDEPLOY\` trên USB — client tự xác thực chữ ký ECDSA + bind USB-SN + license tier ngay tại máy.

:::note
File này thường giống nhau trên mọi USB và do CoreSystem quản lý (trong `boot.wim`).
Bạn chỉ tập trung tùy biến `user-config.json` trên USB.
Công cụ rescue định vị qua `[ký_tự_ổ]:\Softwares\<toolPaths>`.
:::

## 2. Tệp tin user-config.json — Cấu hình triển khai khách hàng

Tệp tin nằm tại `[USB]:\EASYDEPLOY\user-config.json`.

Tệp chứa tham số cài đặt mặc định và tùy biến triển khai.

**Mỗi khách hàng/đối tác MSP dùng license `.lic` riêng trên USB của họ.**

```jsonc
{
  "enableF3Express": true,         // bật chế độ Express (F3)
  "zeroTouch": false,              // Boot USB → auto F3Express → OOBE (chỉ MSP Advanced, MSP tự chịu trách nhiệm)
  "deploy": {
    "version": "25h2",
    "edition": "Pro",
    "activation": "Retail",
    "languageCode": "en-us",
    "diskNumber": 0,
    "profile": "1.Tweaks"
  },
  "portableApps": { … },           // ghi đè toolPaths
  "toolMultiDriveLabel": "DISK BACKUP",   // ghi đè nhãn tool
  "toolExplorerLabel": "FILE EXPLORER",
  "toolHwInfoLabel": "HARDWARE INFO",
  "toolBrowserLabel": "WEB BROWSER"
}
```

:::note
License ngoại tuyến **không nằm trong JSON**.
Chỉ cần đặt `*.lic` (do CoreSystem cấp) vào `[USB]:\EASYDEPLOY\`.
:::

| Cấu trúc khóa | Ý nghĩa sử dụng |
|-------|---------|
| `enableF3Express` | Bật/tắt chế độ Express (F3). |
| `zeroTouch` | Boot USB → tự chạy Express không cần nhấn F3. Chỉ **MSP Advanced** (`Tier=advanced`), MSP tự chịu trách nhiệm. Chỉ dùng trong môi trường có kiểm soát, không khuyến khích bật đại trà. Mặc định `false`. |
| `deploy.version` | Phiên bản OS trong OSCatalog (VD `25h2`). Tự resolve build mới nhất nếu nhiều build cùng version. |
| `deploy.activation` | Home → `Retail`; Enterprise → `Volume`; Pro → chọn `Retail` hoặc `Volume`. Chọn sai → cài đặt sai. |
| `portableApps` / `tool*Label` | Ghi đè đường dẫn công cụ cứu hộ hoặc nhãn nút bấm. |

:::note
Xác thực bản quyền là **Offline License duy nhất**.
Đặt `*.lic` vào `[USB]:\EASYDEPLOY\`. Xem chi tiết tại [Chế độ Offline](/easydeploy/reference/offline-mode/).
:::

## 3. Catalog data.json — Danh sách hệ điều hành hợp lệ

Catalog là danh sách các Windows Image hợp lệ (do Microsoft phân phối chính thức).

CoreSystem lưu trữ tại `https://esd.coresystem.vn/data.json`.
Khai báo qua `catalog.url` trong `system-config.json`.

Khi khởi động WinPE, hệ thống tự tải danh sách về và lưu cache tại `X:\EasyDeploy\catalog.json`.

:::note
**Nguồn Catalog theo cờ `cloudCatalog`:** client chỉ tải từ cloud khi `catalog.cloudCatalog = true`.
Khi `false`, không gọi mạng — dùng catalog **nhúng trong exe** (`data.json`).
Hữu ích khi MSP muốn cố định danh sách OS.
:::

> MSP Standard/Advanced có thể **tự host `data.json`** trên server của mình.
> Bật `cloudCatalog: true`, đổi `catalog.url` trỏ tới — hệ thống vẫn hoạt động nguyên vẹn.
> Quy trình: tải → cache → fallback nhúng khi mất mạng. Chỉ cần `data.json` đúng cấu trúc bên dưới.

Mỗi phần tử trong catalog:

```jsonc
{
  "build": "26200.8873",          // build number
  "version": "25h2",              // version (vd 25h2, 24h2)
  "fileName": "26200.8873…en-us.esd",   // tên file — khớp với file offline trên USB
  "languageCode": "en-us",
  "architecture": "x64",           // nền tảng chủ đạo x86_64
  "activation": "Retail",         // hoặc Volume
  "size": 5895987847,
  "sizeGB": 5.5,
  "hash": "3fc7cbe5…",            // SHA-256 để xác minh tải/offline
  "hashType": "SHA-256",
  "url": "http://dl.delivery.mp.microsoft.com/…esd",
  "editions": ["Pro", "Home", …]  // edition có trong image này
}
```

### 3.1. Quy trình quét và xác định nguồn cài đặt hệ điều hành (Step 6)

1. **Ưu tiên offline trước (Offline-first):** Engine quét `EASYDEPLOY\OS\` trên mọi phân vùng.
   Tìm file trùng khớp `fileName`, xác minh SHA-256 hash. Hợp lệ → dùng file cục bộ (không cần mạng).
2. **Tải trực tuyến (Online):** Không tìm thấy file offline hoặc hash không khớp.
   Engine tải từ `url` qua curl/BITS, xác minh hash sau tải xong.
3. **Ngắt tiến trình:** Không có mạng và không có file offline hợp lệ.
   Engine **dừng** và hiển thị thông báo lỗi.

:::tip
Để triển khai ngoại tuyến hoàn toàn, tải `.esd` và sao chép vào `EASYDEPLOY\OS\` trên USB.
**Không đổi tên file** — cả tên và SHA-256 hash phải khớp Catalog.
Nguồn tải: <https://esd.coresystem.vn>.
:::

:::caution
**Không sử dụng DVD hoặc file ISO chứa `EASYDEPLOY\OS\`:**
ISO (ISO 9660) có thể rút gọn tên file quá dài.
File cài đặt không khớp `fileName` và bị bỏ qua.
:::

## 4. Bảng tổng hợp vị trí lưu trữ và vai trò của các tệp tin

| Tệp tin | Đường dẫn | Vai trò |
|------|--------|----------|
| `easydeploy.exe` | Tích hợp trong `sources\boot.wim` | Chương trình thực thi chính (CoreSystem cung cấp). |
| `system-config.json` | Trong boot.wim (cùng cấp `easydeploy.exe`) | Cấu hình chung (thuộc bản quyền CoreSystem). |
| `user-config.json` | `[USB]:\EASYDEPLOY\` | Cấu hình triển khai và xác thực bản quyền (tùy khách hàng). |
| `data.json` | Cloud `esd.coresystem.vn` & cache `X:\EasyDeploy\catalog.json` | Danh mục Windows Image hợp lệ. |
| `EASYDEPLOY\Profiles\*` | USB | Profile cấu hình sau cài đặt (BootBuilder khởi tạo). |
| `EASYDEPLOY\OS\*` | USB (tùy chọn) | Nguồn OS cho cài đặt Offline/Hybrid (tải tại esd.coresystem.vn). |
| `Softwares\*` | USB | Phần mềm và công cụ cứu hộ Portable (BootBuilder đóng gói). |

:::note
Cấu trúc USB (boot, `EASYDEPLOY\`, `Softwares\`) được BootBuilder đóng gói.
Bạn chỉ tùy biến **`user-config.json`** và **`EASYDEPLOY\Profiles\`**.
File hệ thống (`easydeploy.exe`, `system-config.json`, `boot.wim`) do CoreSystem quản lý.
:::