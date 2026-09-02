---
title: 'Danh mục phím tắt trên WinPE (Keyboard Shortcuts)'
---

Các thao tác trên giao diện EASYDEPLOY đều có phím tắt. Bạn có thể dùng **nút bấm** trên giao diện hoặc nhấn **phím nóng** tương ứng.

## 1. Các luồng triển khai hệ điều hành

| Phím tắt | Chức năng thực thi |
|------|-----------|
| **1** / NumPad1 | Khởi chạy luồng Vanilla (SETUP WINDOWS [DEFAULT]) — Triển khai bản Windows sạch mặc định (không áp dụng profile) |
| **2** / NumPad2 | Khởi chạy luồng Business (SETUP WINDOWS [BUSINESS]) — Triển khai bản Windows tích hợp cấu hình doanh nghiệp (kèm profile) |
| **F3** | Khởi chạy luồng cài đặt nhanh Express (F3) — Chỉ khả dụng khi cấu hình `"enableF3Express": true` trong `user-config.json` |

## 2. Các công cụ cứu hộ hệ thống (Rescue Tools)

| Phím tắt | Nút bấm giao diện | Công cụ / Chức năng khởi chạy |
|------|-----|---------|
| **F1** | — | Khởi chạy công cụ BitLocker — Mở khóa và truy cập các phân vùng bị mã hóa trong WinPE |
| **F2** | — | Khởi chạy cấu hình WiFi — Thiết lập kết nối mạng không dây trong WinPE |
| **F4** | — | Mở trình soạn thảo văn bản Notepad |
| **F5** | — | Mở công cụ phân chia ổ đĩa Diskpart (CLI) |
| **F6** | — | Mở môi trường dòng lệnh PowerShell (CLI) |
| **F7** | DISK BACKUP | Khởi chạy công cụ sao lưu và phục hồi phân vùng MultiDrive |
| **F8** | FILE EXPLORER | Khởi chạy trình quản lý tệp tin cứu dữ liệu Explorer++ |
| **F9** | HARDWARE INFO | Khởi chạy công cụ chẩn đoán phần cứng HWiNFO64 |
| **F10** | WEB BROWSER | Khởi chạy trình duyệt web cứu hộ Pale Moon |

## 3. Các chức năng hệ thống khác

| Phím tắt | Chức năng thực thi |
|------|-----------|
| **F11** | Mở hộp thoại About — Hiển thị thông tin phiên bản ứng dụng và trạng thái bản quyền (License) |
| **F12** | Tắt thiết bị an toàn |

:::note
Các công cụ từ **F7–F10** là ứng dụng Portable trong `Softwares\` trên USB (không đi kèm bộ phát hành — bổ sung qua BootBuilder hoặc copy thủ công + `user-config.json`). Định tuyến qua `toolPaths` trong `system-config.json`. Nếu thiếu file, phím tương ứng không hoạt động. 4 nút chỉ là quick-launch — footer tự điều chỉnh nhãn/phím theo cấu hình; số tool không giới hạn, gọi thêm qua F6 (PowerShell)/F8 (Explorer)/cmd. Chi tiết tại [File cấu hình](/easydeploy/reference/configuration/).

**F1** (BitLocker) và **F2** (WiFi) tích hợp sẵn trong nhân nên **luôn hoạt động**. F2 có cooldown **3 giây** và cảnh báo nếu đang có LAN có dây.
:::