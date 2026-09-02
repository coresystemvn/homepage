---
title: 'Tài liệu cấu hình chi tiết'
---

EASYDEPLOY đọc cấu hình từ **hai file JSON**.

## 1. Tệp tin system-config.json — Cấu hình hệ thống

File nằm cùng thư mục với `easydeploy.exe` trong bộ phát hành, và được **BootBuilder đóng gói vào `boot.wim` khi build USB**.

Vai trò của file là quy định các chức năng chủ đạo của hệ thống: nhãn hiển thị, đường dẫn công cụ cứu hộ, OS Catalog (BYOC), telemetry (BYOB) và preshared-key giải mã profile. File này **không sửa được khi chạy** (nằm trong `boot.wim`) — muốn thay đổi, bạn chỉnh trước khi build rồi để BootBuilder đóng gói lại.

Các khóa nâng cao (Self-catalog/BYOB/Mã hóa/ZeroTouch) chỉ dành cho **MSP Advanced** — với **Free**, các khóa này bị bỏ qua khi chạy. Catalog hoạt động đầy đủ ở mọi gói (xem bảng dưới).

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
    "defaultWifiPassword": "",
    "deployLogCSV": true
  },
  "catalog": {
    "url": "https://esd.coresystem.vn/data.json",
    "timeoutSeconds": 30,
    "downloadMethod": "auto",
    "cloudCatalog": true,
    "filterCatalog": true
  },
  "telemetry": {
    "enabled": false,
    "endpoint": "",
    "apiKey": "",
    "reportDeployment": true
  },
  "profileEncryption": {
    "enabled": false,
    "passphrase": ""
  }
}
```

| Cấu trúc khóa | Ý nghĩa sử dụng | Với Free |
|------|---------|----------|
| `labels` | Nhãn cho 2 luồng cài đặt chính, nút chức năng cứu hộ và hộp thoại About. | ✅ Có tác dụng (chỉnh trước khi build — xem ghi chú bên dưới) |
| `toolPaths` | Đường dẫn tương đối trỏ tới các công cụ cứu hộ — tự động vào `Softwares\` trên USB. Là **giá trị fallback**: chỉ dùng khi `user-config.json` không khai báo `portableApps`. | ✅ Có tác dụng (chỉnh trước khi build) |
| `behavior` | WiFi mặc định (`defaultWifiSsid`/`defaultWifiPassword`) + `deployLogCSV`. | ✅ Có tác dụng (chỉnh trước khi build) |
| `catalog` | Nguồn OS Catalog (`url`/`timeoutSeconds`/`downloadMethod`/`cloudCatalog`/`filterCatalog`). Thiết kế **luôn fallback**: `url` trỏ tới catalog do CoreSystem vận hành — nếu gặp sự cố (hiếm), tự chuyển sang **catalog nhúng**. `cloudCatalog:true` = ưu tiên cloud; `filterCatalog:true` = OS Configurator chỉ hiện `Home|Pro|Enterprise` (tắt lọc → hiển thị toàn bộ edition Windows 11). **Free dùng mặc định là đủ** — chỉ `url` tự host là BYOC (Advanced). | ✅ Có tác dụng (trừ `url` tự host — BYOC/Advanced) |
| `telemetry` | BYOB telemetry (`enabled`/`endpoint`/`apiKey`). | ⚠️ Bị bỏ qua — chỉ ghi CSV trên USB |
| `profileEncryption` | Mã hóa profile (`enabled`/`passphrase`). | ⚠️ Bị bỏ qua |

:::note
Với **Free**, các khóa nâng cao (`telemetry`, `profileEncryption`, `url` tự host — Self-catalog/BYOC) sẽ **bỏ qua khi chạy**: hệ thống dùng cloud catalog của CoreSystem kèm fallback embedded và ghi CSV trên USB. Chi tiết về Self-catalog/BYOB/Mã hóa/ZeroTouch có trong **tài liệu kỹ thuật kèm `.lic` MSP Advanced**.
:::

:::note
**"Chỉnh trước khi build" nghĩa là gì?** Vì `system-config.json` được bake vào `boot.wim` lúc build, các khóa có tác dụng (`labels`/`toolPaths`/`behavior`) phải được chỉnh **trước khi chạy BootBuilder** — BootBuilder sẽ đóng gói phiên bản mới vào USB. Sửa file trong `boot.wim` sau khi build sẽ không có tác dụng.
:::

### 1.1. Xác thực bản quyền — Offline License (duy nhất)

> Chỉ cần đặt file `*.lic` (do CoreSystem cấp) vào `EASYDEPLOY\` trên USB — client tự xác thực chữ ký ECDSA + bind USB-SN + license tier ngay tại máy.

:::note
`system-config.json` được BootBuilder đóng gói vào `boot.wim` khi build — bản hiển thị ở đây thuộc bản phát hành CoreSystem.
Bạn tập trung tùy biến `user-config.json` trên USB.
Công cụ rescue định vị qua `[ký_tự_ổ]:\Softwares\<toolPaths>`.
:::

## 2. Tệp tin user-config.json — Cấu hình triển khai khách hàng

Tệp tin nằm tại `[USB]:\EASYDEPLOY\user-config.json`.

Tệp chứa tham số cài đặt mặc định và tùy biến triển khai.

**Mỗi khách hàng/đối tác MSP dùng license `.lic` riêng trên USB của họ.**

```jsonc
{
  "enableF3Express": true,         // bật chế độ Express (F3)
  "zeroTouch": false,              // chỉ Advanced — Free sẽ bị bỏ qua
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

| Cấu trúc khóa | Ý nghĩa sử dụng | Với Free |
|-------|---------|----------|
| `enableF3Express` | Bật/tắt chế độ Express (F3). | ✅ Có tác dụng |
| `zeroTouch` | Boot USB → tự chạy Express (`zeroTouch:true`). Chỉ **MSP Advanced**. | ⚠️ Bị bỏ qua |
| `deploy.version` | Phiên bản OS trong OSCatalog (VD `25h2`). Tự resolve build mới nhất nếu nhiều build cùng version. | ✅ Có tác dụng |
| `deploy.activation` | Home → `Retail`; Enterprise → `Volume`; Pro → chọn `Retail` hoặc `Volume`. Chọn sai → cài đặt sai. | ✅ |
| `portableApps` / `tool*Label` | Ghi đè đường dẫn công cụ cứu hộ hoặc nhãn nút bấm. Khi không khai báo, hệ thống **fallback về giá trị trong `system-config.json`**. | ✅ |
| `deploy.profile` | Tên profile sẽ dùng cho Express (`1.Tweaks`/`2.TweaksApp`). **Free là hard code 2 profiles** — tạo thêm `3.Acme` sẽ bị bỏ qua. Muốn dùng profile riêng trên Free: ghi đè nội dung vào một trong hai folder gốc (giữ đúng tên `1.Tweaks`/`2.TweaksApp`) — folder khác tên sẽ bị bỏ qua. | ⚠️ Chỉ 1.Tweaks/2.TweaksApp có tác dụng |

:::caution
**Fallback design — `portableApps`/`toolPaths`:** hệ thống được thiết kế luôn có giá trị dự phòng ở mọi tình huống — thiếu `user-config.json` (hoặc thiếu khóa) sẽ fallback về `system-config.json`. Tuy nhiên trên thực tế, **không có `user-config.json` thì các tính năng Express Deploy và MSP-owned portable apps licenses gần như vô dụng** — luôn kiểm tra file này khi bàn giao USB cho khách hàng.
:::

:::note
**Ứng dụng Portable không đi kèm bộ phát hành.** 4 công cụ trong cấu hình mặc định (MultiDrive, HWiNFO64, Explorer++, Pale Moon) chỉ là thiết kế mẫu — file `.zip` tải từ trang Download **không chứa** các ứng dụng này. MSP/IT chủ động tải bổ sung hoặc chọn công cụ mình muốn, rồi thêm vào USB theo 1 trong 2 cách:

1. **Kỳ build ISO — qua BootBuilder:** sao chép phần mềm vào `usb\Softwares\` trước khi build.
2. **Copy thủ công sau khi build:** chép công cụ vào `Softwares\` trên USB và khai báo `portableApps` trong `user-config.json` — nếu giữ đúng cấu trúc thư mục như `toolPaths` mặc định thì không cần khai báo thêm.

Main window chỉ dành **4 nút quick-launch** (vì EasyDeploy là công cụ deploy — rescue chỉ bổ trợ); nhãn và phím tắt ở footer tự điều chỉnh theo cấu hình. Số lượng tool không giới hạn — các công cụ ngoài 4 slot gọi bình thường qua F6 (PowerShell)/F8 (Explorer)/cmd.
:::

:::note
Xác thực bản quyền là **Offline License duy nhất**.
Đặt `*.lic` vào `[USB]:\EASYDEPLOY\`. Xem chi tiết tại [Chế độ Offline](/easydeploy/reference/offline-mode/).
:::

## 3. Catalog data.json — Danh sách hệ điều hành hợp lệ

Catalog là danh sách các Windows Image hợp lệ (tải từ kênh phân phối chính thức của Microsoft).

CoreSystem lưu trữ tại `https://esd.coresystem.vn/data.json`.
Khai báo qua `catalog.url` trong `system-config.json`.

Khi khởi động WinPE, hệ thống tự tải danh sách về và lưu cache tại `X:\EasyDeploy\catalog.json`.

:::note
**Nguồn Catalog theo cờ `cloudCatalog`:** client chỉ tải từ cloud khi `catalog.cloudCatalog = true`.
Khi `false`, không gọi mạng — dùng catalog **nhúng trong exe** (`data.json`).
Hữu ích khi MSP muốn cố định danh sách OS.
:::

> MSP Advanced có thể **tự host `data.json`** (chi tiết trong tài liệu kỹ thuật kèm `.lic`). Free dùng cloud catalog của CoreSystem — catalog nhúng luôn là fallback.

> Quy trình chung: tải → cache → fallback nhúng khi mất mạng.

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
| `system-config.json` | Trong boot.wim (cùng cấp `easydeploy.exe`) | Cấu hình hệ thống — BootBuilder bake vào `boot.wim` khi build (labels, toolPaths fallback, catalog, telemetry, preshared-key). |
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