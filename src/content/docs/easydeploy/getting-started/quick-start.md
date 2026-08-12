---
title: 'Quick Start — Triển khai Windows nhanh trong 5 phút'
---

:::note
**Thời gian đọc:** 3 phút. Mục tiêu: Sử dụng USB/ISO **sẵn có** để boot và cài đặt Windows thành công ngay trong lần đầu tiên.
:::

:::danger
**Xác định vai trò người dùng:**

- **Đã có sẵn USB/ISO** (do CoreSystem phát hành hoặc đối tác MSP tự dựng qua BootBuilder) → Di chuyển trực tiếp đến [Bước 1: Cấu trúc USB tiêu chuẩn](#1-cấu-trúc-usb-chuẩn) để tiến hành cài đặt.
- **Là MSP muốn tự xây dựng USB/ISO tùy biến** (Whitebox) → Vui lòng tham khảo tài liệu [BootBuilder (Whitebox)](/easydeploy/msp/bootbuilder/) trước khi thực hiện quy trình cài đặt.
- **Không cần tự biên dịch (build)** `easydeploy.exe` hoặc môi trường WinPE: File thực thi tiêu chuẩn do CoreSystem phát hành đã được tích hợp sẵn cấu hình trong `system-config.json` (bao gồm tham số `auth.enabled` quyết định chế độ xác thực qua Cloud hay sử dụng License Offline — xem thêm [File cấu hình](/easydeploy/reference/configuration/)).
:::

:::caution
**Về Shared ISO (ISO dùng chung do CoreSystem cung cấp) — Khả năng tích hợp driver là nỗ lực tối đa (best-effort):**

- CoreSystem hỗ trợ tích hợp tối đa các driver phần cứng phổ biến cho các dòng máy doanh nghiệp của **Dell, HP, Intel, Lenovo**.
- Trong trường hợp môi trường WinPE **không nhận diện được driver** (thiết bị mạng hoặc ổ đĩa cứng), người dùng cần **chuyển sang phương án dự phòng** (ví dụ: tự dựng USB riêng qua [BootBuilder (Whitebox)](/easydeploy/msp/bootbuilder/) đối với gói MSP để tích hợp driver chuyên biệt, hoặc sử dụng nguồn cài đặt khác phù hợp).
- CoreSystem **không hỗ trợ** xử lý sự cố thiếu driver đối với các bản Shared ISO.
:::

## 1. Cấu trúc USB tiêu chuẩn

USB/ISO triển khai tiêu chuẩn có cấu trúc thư mục như sau (khuyến nghị định dạng **NTFS** để có thể lưu trữ tệp tin ESD dung lượng lớn hơn 4GB):

```
[USB]:
├── bootmgr, bootmgr.efi
├── Boot\                        ← bộ boot WinPE (BCD, fonts, boot.sdi, memtest…)
├── EFI\
├── en-us\
├── sources\
│   └── boot.wim                 ← WinPE — easydeploy.exe nằm BÊN TRONG file này
├── EASYDEPLOY\
│   ├── user-config.json         ← cấu hình triển khai + auth (bạn chỉnh file này)
│   ├── Profiles\                ← bộ profile (1.Tweaks, 2.TweaksApp — có sẵn)
│   │   ├── 1.Tweaks\
│   │   │   ├── unattend.xml
│   │   │   └── post-setup-tweaks.ps1
│   │   └── 2.TweaksApp\
│   │       ├── unattend.xml
│   │       └── post-setup-combo.ps1
│   └── OS\                      ← (tùy chọn) nguồn OS offline/hybrid
│       └── <tên file .esd>       ← tải tại https://esd.coresystem.vn
└── Softwares\                   ← công cụ rescue (có sẵn)
    ├── Multidrive\              ← MultiDrive.exe (backup/restore disk)
    ├── Explorer++\              ← Explorer++.exe
    ├── HWInfo\                  ← HWiNFO64.exe + HWiNFO64.INI
    └── Palemoon\                ← Palemoon.exe
```

:::note
Tên các thư mục và công cụ trong `Softwares\` phải khớp chính xác với các khóa cấu hình `portableApps` trong `user-config.json` (do Windows không phân biệt chữ hoa/chữ thường nên định dạng chữ không ảnh hưởng đến hoạt động).
:::

:::note
Tệp tin thực thi `easydeploy.exe` **không nằm trực tiếp ở thư mục gốc** của USB mà được tích hợp sẵn bên trong `sources\boot.wim`. Quản trị viên chỉ cần quản lý và tùy biến các thư mục ngoài: `EASYDEPLOY\` (chứa cấu hình, profile, OS) và `Softwares\` (chứa các công cụ cứu hộ).
:::

:::tip
Để thực hiện triển khai theo chế độ **Offline/Hybrid** (không phụ thuộc kết nối internet), vui lòng tải tệp tin `.esd` từ <https://esd.coresystem.vn> và sao chép vào thư mục `EASYDEPLOY\OS\`. Tên tệp tin phải trùng khớp hoàn toàn với thông tin trong Catalog (xem thêm [Chế độ Offline](/easydeploy/reference/offline-mode/)).
:::

## 2. Thiết lập cấu hình `user-config.json`

Tệp tin `EASYDEPLOY\user-config.json` lưu trữ các thông số triển khai mặc định và thông tin xác thực bản quyền:

```jsonc
{
  "business_id": "CS-MSP-201",        // mã khách hàng do CoreSystem cấp
  "installation_code": "777406",      // mã cài đặt
  "api_key": "REPLACE-WITH-API-KEY-FROM-CORESYSTEM", // API key (bản online)
  "offlineLicense": "",               // license offline (bản offline)
  "enableF3Express": true,            // bật chế độ Express bằng phím F3
  "deploy": {
    "operatingSystem": "Windows 11 25H2",
    "edition": "Pro",
    "activation": "Retail",
    "languageCode": "en-us",
    "diskNumber": 0,
    "profile": "1.Tweaks"             // tên profile mặc định cho Express
  }
}
```

:::danger
Chỉ thiết lập **một trong hai** tham số: `api_key` (triển khai trực tuyến) hoặc `offlineLicense` (triển khai ngoại tuyến). Không cấu hình đồng thời cả hai tham số. Trong trường hợp cần vận hành hoàn toàn ngoại tuyến, vui lòng tham khảo [Chế độ Offline](/easydeploy/reference/offline-mode/).
:::

## 3. Khởi động (Boot) vào môi trường WinPE

1. Kết nối USB vào máy tính cần cài đặt.
2. Khởi động máy, nhấn phím tắt truy cập Boot Menu (thường là **F12, F9, hoặc Esc** tùy theo dòng máy) và chọn khởi động từ USB.
3. Sau khi môi trường WinPE được tải xong, giao diện chính của **EASYDEPLOY** sẽ tự động hiển thị.

:::caution
Trước khi tiến hành cài đặt, vui lòng kiểm tra trạng thái kết nối **mạng** (nếu cần xác thực trực tuyến hoặc tải trực tiếp OS từ Catalog). Nếu thiết bị chưa có kết nối mạng internet, nhấn phím **F2** để thiết lập kết nối WiFi, hoặc sử dụng nguồn cài đặt OS offline (`EASYDEPLOY\OS\*.esd` có sẵn trên USB).
:::

## 4. Tiến trình cài đặt Windows

Giao diện chính cung cấp các luồng triển khai sau:

| Phím | Luồng | Khi nào dùng |
|------|-------|--------------|
| **1** (hoặc nút **SETUP WINDOWS [DEFAULT]**) | **Vanilla** — Bản cài sạch mặc định (không kèm profile) | Máy cần cài đặt Windows nguyên bản từ Microsoft, không tùy biến |
| **2** (hoặc nút **SETUP WINDOWS [BUSINESS]**) | **Business** — Cài đặt tích hợp cấu hình doanh nghiệp (kèm profile) | Triển khai theo quy chuẩn thiết lập riêng của doanh nghiệp |
| **F3** | **Express** — Quy trình triển khai tự động hóa tối đa | Phù hợp khi triển khai số lượng lớn, tự động hóa qua một phím nhấn |

Ví dụ: Nhấn phím **2** → lựa chọn OS, edition, phân vùng ổ đĩa, và profile mong muốn → chọn **Deploy**. Theo dõi quy trình triển khai tự động 11 bước trên màn hình. Sau khi hoàn thành, thiết bị sẽ tự động **khởi động lại vào màn hình OOBE** (bước thiết lập tài khoản ban đầu của Windows).

:::tip
Đối với luồng **Business (2)** và **Express (F3)**, nếu hệ thống **không tìm thấy bất kỳ profile nào** trên USB, nó sẽ tự động áp dụng **profile mặc định của hệ thống** (chuẩn production, tương đương profile `1.Tweaks`). Do đó, bản cài đặt vẫn được tối ưu hóa theo tiêu chuẩn vận hành doanh nghiệp mà không bắt buộc phải có profile đi kèm.
:::

:::tip
Tham khảo thông tin chi tiết về từng chế độ triển khai tại [Các chế độ triển khai](/easydeploy/getting-started/deploy-modes/).
:::

## 5. Danh mục kiểm tra sau cài đặt (Checklist)

- [ ] Thiết bị khởi động lại vào màn hình OOBE hoặc màn hình Desktop, tài khoản người dùng được tự động thiết lập theo cấu hình của profile.
- [ ] Script `Post-setup.ps1` hoàn thành tiến trình cài đặt (nếu có), thiết bị tự động khởi động lại lần cuối (tùy thuộc vào thiết lập của profile).
- [ ] Xác nhận phiên bản Windows (Version) và phiên bản phân phối (Edition) trùng khớp với lựa chọn ban đầu.
- [ ] (Chế độ Online) Dữ liệu triển khai (deployment telemetry) đã được đồng bộ lên hệ thống CoreSystem (bao gồm thông tin OS build, edition, language và version).

## Khắc phục sự cố nhanh

| Triệu chứng | Xử lý |
|-------------|-------|
| Không hiển thị ổ đĩa mục tiêu | Hệ thống chỉ hiển thị các ổ đĩa vật lý có thể triển khai (loại trừ các thiết bị USB và ổ đĩa ảo). Vui lòng kiểm tra lại kết nối phần cứng. |
| Lỗi xác thực bản quyền (Authentication) | Kiểm tra lại tính chính xác của các tham số `business_id`, `installation_code` và `api_key` trong tệp tin `user-config.json`. |
| WinPE không có kết nối internet | Nhấn phím **F2** để thiết lập kết nối mạng không dây, hoặc đảm bảo đã lưu trữ sẵn tệp tin `.esd` trong thư mục `EASYDEPLOY\OS\` trên USB. |
| Quy trình triển khai bị gián đoạn hoặc thất bại (Failed) | Tệp tin ghi nhận lỗi (log) sẽ được tự động lưu trữ tại đường dẫn `[USB]:\EASYDEPLOY\Log\deploy-error-*.log`. |

## Hướng dẫn bổ sung dành cho MSP

- Tự xây dựng ISO/USB tùy biến thương hiệu riêng (Whitebox): Tham khảo tài liệu [BootBuilder](/easydeploy/msp/bootbuilder/).
- Thiết lập thông tin khách hàng vào cấu hình: Xem hướng dẫn [Bắt đầu với EASYDEPLOY](/easydeploy/msp/getting-started/).
- Quản lý bản quyền thiết bị, thiết bị USB và cấu hình cảnh báo: Xem tài liệu [MSP Overview](/easydeploy/msp/overview/).
