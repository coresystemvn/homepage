---
title: 'Các chế độ triển khai'
---

EASYDEPLOY điều phối 4 phương pháp cài đặt: **Vanilla**, **Business**, **Express** (F3) và **ZeroTouch** (Advanced — tự động hoàn toàn khi boot USB, xem [License Tiers](/easydeploy/msp/license-tiers/)). Ba phương pháp đầu được chọn trực tiếp trên giao diện.

## So sánh nhanh

| | **Vanilla** (phím 1) | **Business** (phím 2) | **Express** (phím F3) |
|---|---|---|---|
| Tên trên giao diện | SETUP WINDOWS [DEFAULT] | SETUP WINDOWS [BUSINESS] | — (phím F3) |
| Profile tùy biến | — | Có | Có (từ `deploy.profile`) |
| Nguồn thông số | Bạn chọn qua OSConfigurator | Bạn chọn qua OSConfigurator | Tự đọc từ `user-config.json` |
| Phù hợp khi | Cài Windows gốc | Triển khai theo quy chuẩn DN | Triển khai số lượng lớn |

## Vanilla — Windows gốc

Nhấn **1** hoặc chọn **SETUP WINDOWS [DEFAULT]** → chọn OS/edition + ổ đĩa → **START OS DEPLOYMENT**.

Hệ thống cài Windows nguyên bản, không tích hợp profile nào. Thiết bị khởi động vào màn hình OOBE chuẩn của Microsoft.

## Business — Có profile doanh nghiệp

Nhấn **2** hoặc chọn **SETUP WINDOWS [BUSINESS]** → chọn OS → chọn **Profile** → chọn ổ đĩa → **START OS DEPLOYMENT**.

Sau khi giải nén Windows, engine tự sao chép `unattend.xml` và `Post-setup.ps1` vào phân vùng đích. Windows đọc file trả lời tự động khi khởi động và chạy script lần đăng nhập đầu tiên. Chi tiết tại [Profiles Overview](/easydeploy/profiles/profiles/).

**Profile có sẵn:** BootBuilder đóng gói sẵn 2 profile trong `EASYDEPLOY\Profiles\`:
- **`1.Tweaks`** — tinh chỉnh hệ thống cơ bản (wallpaper, dọn dẹp, high performance…)
- **`2.TweaksApp`** — kế thừa tweaks + cài thêm ứng dụng qua WinGet

Nếu USB trống profile, hệ thống tự dùng profile mặc định (tương đương `1.Tweaks`).

## Express — Tự động qua F3

Nhấn **F3** → hiện 1 dialog xác nhận → tự chạy toàn bộ quy trình.

Hệ thống tự đọc cấu hình từ `user-config.json`. Nếu thiếu thông số, OSConfigurator hiển thị để bạn chọn thủ công.

:::note
Express yêu cầu `"enableF3Express": true` trong `user-config.json`.
:::

## Yêu cầu hệ thống

**Máy đích (nơi cài Windows):** WinPE triển khai Windows 11 — máy đích cần đáp ứng tối thiểu theo [yêu cầu hệ thống của Microsoft cho Windows 11](https://www.microsoft.com/windows/windows-11-specifications).

**Máy trạm (chạy BootBuilder):** engine thực thi qua **PowerShell 7.4+** — các thành phần đi kèm đã đầy đủ; RAM/CPU càng mạnh, build càng nhanh.

## Bản Windows được hỗ trợ

Engine triển khai chạy được với **bất kỳ ngôn ngữ nào** của Windows — đã kiểm chứng thực tế trên Anh/Nhật/Hàn/Trung. Catalog tại esd.coresystem.vn hiện liệt kê **9 ngôn ngữ phổ biến** và sẽ mở rộng theo nhu cầu:

| Tiêu chí | Giá trị |
|---|---|
| **Version** | Windows 11 `23H2` → `24H2` → `25H2` (26H2 có thể bổ sung trong tương lai gần) |
| **Edition** | `Home` / `Pro` / `Enterprise` (các edition khác mặc định ẩn, bật trong system-config.json =>  "filterCatalog": false) |
| **Language** | `en-us` / `ja-jp` / `ko-kr` / `zh-cn` / `zh-tw` / `de-de` / `fr-fr` / `pt-br` / `es-es` / … (mở rộng theo nhu cầu) |
| **Activation** | `Retail` / `Volume` |

:::note
**Bản quyền Windows (activation) nằm ngoài phạm vi EASYDEPLOY.** Công cụ chỉ điều phối
quá trình cài đặt (chọn phiên bản, edition, ngôn ngữ, ổ đĩa, profile) — việc kích hoạt bản
quyền được thực hiện theo mô hình của từng khách hàng (Retail, Volume/KMS, MAK...). Bạn nên
xác định rõ mô hình kích hoạt của khách khi chuẩn bị cấu hình.
:::

## Engine triển khai 11 bước

Cả 3 chế độ dùng chung engine gồm 11 bước tự động — chưa đầy 5 phút cho phần bung cài, cộng khoảng 10 phút hậu kỳ sau cài đặt: tổng ~15 phút một máy, hoàn toàn tự động với ZeroTouch (thời gian thực tế tùy tốc độ mạng và ổ đĩa):

| # | Bước | Tóm tắt |
|---|------|---------|
| 1 | Khởi tạo | Kiểm tra cấu hình và bản quyền |
| 2 | Quét ổ đĩa | Lọc ổ đĩa đích hợp lệ |
| 3 | USB boot | Thu hồi/khôi phục ký tự ổ USB |
| 4 | Phân vùng | Tạo EFI, MSR, Windows, Recovery (GPT) |
| 5 | Nguồn OS | Ưu tiên `.esd` offline → fallback tải từ CDN |
| 6 | Edition | Chọn index phiên bản trong Windows Image |
| 7 | Giải nén | `Expand-WindowsImage` lên `C:\` |
| 8 | Bootloader | `bcdboot` tạo file khởi động |
| 9 | Driver | Inject driver từ WinPE vào hệ thống mới |
| 10 | Dọn dẹp | Xóa file tạm |
| 11 | Profile | Inject profile (Business/Express) → reboot vào OOBE |

:::tip
Nếu có lỗi, xem log tại `[USB]:\EASYDEPLOY\Log\deploy-error-<timestamp>.log`.
:::
