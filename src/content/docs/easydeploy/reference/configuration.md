---
title: 'Tài liệu cấu hình chi tiết'
---

EASYDEPLOY thực hiện đọc và phân tích các tham số thiết lập từ **hai tệp tin JSON** tiêu chuẩn.

## 1. Tệp tin system-config.json — Cấu hình hệ thống

Tệp tin này nằm cùng thư mục với `easydeploy.exe` (được đóng gói sẵn bên trong `EasyDeploy.zip` do CoreSystem phát hành). Tệp tin chứa các thiết lập về nhãn hiển thị nút bấm, cờ xác thực **auth**, đường dẫn các công cụ cứu hộ, hành vi hệ thống và cấu hình OS Catalog. Nội dung cấu hình tiêu chuẩn:

```jsonc
{
  "_comment": "EASYDEPLOY configuration — edit this file to custom labels, and tool paths without recompiling.",
  "labels": {
    "flow1Title": "SETUP WINDOWS [DEFAULT]",
    "flow1Desc": "Deploy Windows OS Default from cloud",
    "flow2Title": "SETUP WINDOWS [BUSINESS]",
    "flow2Desc": "Deploy Windows OS with business profile",
    "aboutInfo": "EASYDEPLOY | Business Windows Deployment …",
    "toolMultiDriveLabel": "DISK BACKUP",
    "toolExplorerLabel": "FILE EXPLORER",
    "toolHwInfoLabel": "HARDWARE INFO",
    "toolBrowserLabel": "WEB BROWSER"
  },
  "auth": {
    "enabled": true            // true = cloud auth, false = offline license
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
    "wifiCooldownSeconds": 3
  },
  "catalog": {
    "url": "https://esd.coresystem.vn/data.json",
    "timeoutSeconds": 30,
    "downloadMethod": "auto",
    "cacheDir": "X:\\EasyDeploy",
    "cacheFileName": "catalog.json"
  }
}
```

| Cấu trúc khóa | Ý nghĩa sử dụng |
|------|---------|
| `labels` | Nhãn hiển thị cho 2 luồng cài đặt chính, các nút chức năng cứu hộ và thông tin hộp thoại About. |
| `auth.enabled` | Cờ xác định chế độ xác thực bản quyền — quyết định hệ thống vận hành theo chế độ xác thực Cloud (Cloud Auth) hay sử dụng License Offline. |
| `toolPaths` | Đường dẫn tương đối trỏ tới các công cụ cứu hộ — được định tuyến tự động vào thư mục `Softwares\` trên USB. |
| `behavior` | Cấu hình WiFi mặc định và thời gian chờ (cooldown) sau khi nhấn phím F2. |
| `catalog` | Thông tin cấu hình nguồn OS Catalog `data.json`, phương thức tải và đường dẫn lưu trữ bộ nhớ đệm (cache) tại `X:\EasyDeploy\catalog.json`. |

### 1.1. Tham số auth.enabled — Cấu hình chế độ xác thực

| Giá trị | Chế độ xác thực áp dụng | Yêu cầu khai báo trong `user-config.json` |
|---------|--------|-----------------------------------|
| `true` | **Cloud Authentication** (Xác thực trực tuyến) | Yêu cầu cung cấp đủ 3 tham số: `business_id`, `installation_code` và `api_key`. |
| `false` | **Offline License** (Xác thực ngoại tuyến) | Yêu cầu cung cấp khóa `offlineLicense` (do CoreSystem cấp phát). |

:::note
Ngoài tham số `enabled`, phân hệ `auth` trong `system-config.json` còn chứa các tham số cấu hình kết nối máy chủ (`endpoint`, `businessCode`, `installationCode`, `apiKey`, `offlineLicense`) do CoreSystem thiết lập sẵn khi phát hành — đội ngũ IT/MSP không cần can thiệp hoặc chỉnh sửa các giá trị này. Phân hệ `branding` (chứa `appName`/`version` hiển thị trong hộp thoại About) cũng thuộc phạm vi quản lý của CoreSystem.
:::

:::danger
Giá trị cờ `auth.enabled` do **CoreSystem** cấu hình mặc định khi đóng gói bộ sản phẩm `EasyDeploy.zip` — đối tác IT/MSP **không nên thay đổi** chế độ này. Tùy thuộc vào giá trị của cờ, tệp tin cấu hình người dùng `user-config.json` bắt buộc phải được khai báo các tham số tương ứng như bảng trên (xem chi tiết tại [Chế độ Offline](/easydeploy/reference/offline-mode/)).
:::

:::note
Tệp tin này thường có nội dung đồng nhất trên mọi thiết bị USB và do CoreSystem trực tiếp quản lý (được lưu trữ cùng cấp với `easydeploy.exe` bên trong file ảnh `boot.wim`). Đội ngũ IT/MSP thông thường không cần sửa đổi tệp tin này mà chỉ cần tập trung tùy biến tệp tin `user-config.json` trên USB. Các công cụ cứu hộ cứu nạn sẽ được hệ thống định vị theo đường dẫn `[ký_tự_ổ]:\Softwares\<toolPaths>` tương ứng, được đóng gói sẵn bởi công cụ EasyDeploy-BootBuilder.
:::

## 2. Tệp tin user-config.json — Cấu hình triển khai khách hàng

Tệp tin này nằm tại thư mục `EASYDEPLOY\` trực tiếp trên USB (`[USB]:\EASYDEPLOY\user-config.json`). Tệp tin chứa các thông số xác thực bản quyền và các thông số cài đặt mặc định — **mỗi khách hàng hoặc doanh nghiệp sở hữu một thông tin bản quyền (license) riêng biệt**.

```jsonc
{
  "business_id": "CS-MSP-201",     // mã khách hàng (CoreSystem cấp)
  "installation_code": "777406",   // mã cài đặt
  "api_key": "REPLACE-WITH-API-KEY-FROM-CORESYSTEM", // API key online
  "offlineLicense": "",            // license offline (ECDSA P-256)
  "enableF3Express": true,         // bật chế độ Express (F3)
  "deploy": {
    "operatingSystem": "Windows 11 25H2",
    "edition": "Pro",
    "activation": "Retail",
    "languageCode": "en-us",
    "diskNumber": 0,
    "profile": "1.Tweaks"
  },
  "portableApps": { … },           // (không bắt buộc) ghi đè toolPaths
  "toolMultiDriveLabel": "DISK BACKUP",   // (không bắt buộc) ghi đè nhãn tool
  "toolExplorerLabel": "FILE EXPLORER",
  "toolHwInfoLabel": "HARDWARE INFO",
  "toolBrowserLabel": "WEB BROWSER"
}
```

| Cấu trúc khóa | Ý nghĩa sử dụng |
|-------|---------|
| `business_id` / `installation_code` / `api_key` | Thông tin xác thực qua máy chủ Cloud (bắt buộc khai báo khi `auth.enabled = true`). |
| `offlineLicense` | Khóa xác thực ngoại tuyến Offline License (bắt buộc khai báo khi `auth.enabled = false`). |
| `enableF3Express` | Kích hoạt hoặc vô hiệu hóa chế độ cài đặt nhanh Express (F3). |
| `deploy` | Thiết lập các thông số cài đặt mặc định cho chế độ Express: phiên bản OS, edition, activation, language, chỉ mục ổ đĩa, và profile áp dụng. |
| `portableApps` / `tool*Label` | (Không bắt buộc) Cấu hình ghi đè đường dẫn các công cụ cứu hộ hoặc nhãn hiển thị nút bấm. |

:::danger
Yêu cầu khai báo các tham số bản quyền phụ thuộc hoàn toàn vào giá trị cờ `auth.enabled` được thiết lập trong tệp tin hệ thống `system-config.json`:

- `auth.enabled = true` → **Cloud Authentication**: bắt buộc cung cấp đủ 3 tham số `business_id` + `installation_code` + `api_key`.
- `auth.enabled = false` → **Offline License**: bắt buộc cấu hình tham số `offlineLicense` (khóa bản quyền ngoại tuyến do CoreSystem cấp phát).

Xem chi tiết tại [Chế độ Offline](/easydeploy/reference/offline-mode/).
:::

## 3. Catalog data.json — Danh sách hệ điều hành hợp lệ

Catalog đóng vai trò là danh sách các Windows Image hợp lệ (được phân phối chính thức từ Microsoft), do CoreSystem lưu trữ trực tuyến tại địa chỉ `https://esd.coresystem.vn/data.json` (được khai báo tại khóa `catalog.url` trong `system-config.json`). Khi khởi động vào môi trường WinPE, hệ thống sẽ tự động tải danh sách này về và lưu vào bộ nhớ đệm tại `X:\EasyDeploy\catalog.json`.

Mỗi phần tử cấu hình trong catalog:

```jsonc
{
  "build": "26200.8873",          // build number
  "version": "25h2",              // version (vd 25h2, 24h2)
  "fileName": "26200.8873…en-us.esd",   // tên file — khớp với file offline trên USB
  "languageCode": "en-us",
  "architecture": "ARM64",        // hoặc x64
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

1. **Ưu tiên offline trước (Offline-first):** Engine thực hiện quét thư mục `EASYDEPLOY\OS\` trên mọi phân vùng ổ đĩa tìm kiếm tệp tin trùng khớp với thông số `fileName` → Tiến hành xác minh tính toàn vẹn qua mã băm `hash` SHA-256 → Nếu hợp lệ, hệ thống sử dụng nguồn file cục bộ này (hoàn toàn không yêu cầu kết nối mạng).
2. **Tải trực tuyến (Online):** Nếu không tìm thấy file offline hoặc mã băm không khớp → Engine tự động thực hiện tải tệp tin từ địa chỉ `url` thông qua công cụ curl hoặc dịch vụ BITS → Tiến hành kiểm tra và xác minh mã băm sau khi tải hoàn tất.
3. **Ngắt tiến trình:** Trong trường hợp thiết bị không có kết nối mạng đồng thời không có sẵn file offline hợp lệ → Engine sẽ tự động **dừng tiến trình** và hiển thị thông báo lỗi rõ ràng cho kỹ thuật viên.

:::tip
Mẹo cấu hình: Để triển khai hoàn toàn ngoại tuyến, quản trị viên chỉ cần tải tệp tin `.esd` tương ứng và sao chép vào thư mục `EASYDEPLOY\OS\` trên USB (hệ thống hỗ trợ quét dưới cấu trúc `OS\<file>.esd` hoặc thư mục con `OS\<tên_thư_mục>\<file>.esd` — chế độ Hybrid). **Lưu ý tuyệt đối không thay đổi tên tệp tin** — cả tên tệp và mã băm SHA-256 bắt buộc phải trùng khớp hoàn toàn với thông số khai báo trong Catalog. Nguồn tải tệp tin ESD chính thức: <https://esd.coresystem.vn>.
:::

:::caution
**Không nên sử dụng phương tiện DVD hoặc file ISO để chứa thư mục `EASYDEPLOY\OS\`:** Định dạng hệ thống file của chuẩn ISO (ISO 9660) có thể tự động rút gọn các tên tệp tin quá dài → dẫn đến việc file cài đặt không trùng khớp với tên khai báo trong `fileName` và bị engine bỏ qua.
:::

## 4. Bảng tổng hợp vị trí lưu trữ và vai trò của các tệp tin

| Tệp tin | Đường dẫn lưu trữ | Vai trò / Mục đích sử dụng |
|------|--------|----------|
| `easydeploy.exe` | Tích hợp bên trong file ảnh WinPE `sources\boot.wim` | Chương trình thực thi chính của giải pháp — do CoreSystem cung cấp. |
| `system-config.json` | Cùng cấp với `easydeploy.exe` (trong boot.wim) | Cấu hình chung của ứng dụng (thuộc bản quyền hệ thống của CoreSystem). |
| `user-config.json` | Đường dẫn `[USB]:\EASYDEPLOY\` | Cấu hình các thông số triển khai và xác thực bản quyền (cho từng khách hàng cụ thể). |
| `data.json` | Lưu trữ trên Cloud (`esd.coresystem.vn`) & đồng bộ về cache tạm tại `X:\EasyDeploy\catalog.json` | Bảng quản lý danh mục (Catalog) các Windows Image hợp lệ. |
| `EASYDEPLOY\Profiles\*` | Lưu trữ trên USB | Các bộ profile cấu hình hệ thống sau cài đặt (mặc định được khởi tạo bởi BootBuilder). |
| `EASYDEPLOY\OS\*` | Lưu trữ trên USB (Thành phần tùy chọn) | Nguồn hệ điều hành phục vụ chế độ cài đặt Offline hoặc Hybrid (tải tại esd.coresystem.vn). |
| `Softwares\*` | Lưu trữ trên USB | Danh mục các phần mềm và công cụ cứu hộ Portable (được đóng gói bởi BootBuilder). |

:::note
Cấu trúc thư mục USB tiêu chuẩn (bao gồm các phân vùng khởi động boot, thư mục cấu hình `EASYDEPLOY\` và các công cụ `Softwares\`) được thiết lập và đóng gói bởi công cụ **EasyDeploy-BootBuilder**. Đội ngũ quản trị IT/MSP chỉ cần thực hiện tùy biến trực tiếp trên tệp tin **`user-config.json`** và thư mục **`EASYDEPLOY\Profiles\`** trên USB; các tệp tin hệ thống cốt lõi khác (`easydeploy.exe`, `system-config.json`, `boot.wim`) sẽ do CoreSystem chịu trách nhiệm quản lý.
:::
