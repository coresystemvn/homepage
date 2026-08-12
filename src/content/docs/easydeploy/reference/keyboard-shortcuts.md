---
title: 'Danh mục phím tắt trên WinPE (Keyboard Shortcuts)'
---

Hầu hết các thao tác điều hướng và vận hành trên giao diện chính của EASYDEPLOY đều được gán phím tắt (Hotkeys). Kỹ thuật viên có thể sử dụng các **nút bấm** trên giao diện đồ họa hoặc nhấn **phím nóng** tương ứng trên bàn phím để kích hoạt nhanh tính năng.

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
| **F9** | HARDWARE INFO | Khởi chạy công cụ chẩn đoán phần cứng HWiNFO |
| **F10** | WEB BROWSER | Khởi chạy trình duyệt web cứu hộ PaleMoon |

## 3. Các chức năng hệ thống khác

| Phím tắt | Chức năng thực thi |
|------|-----------|
| **F11** | Mở hộp thoại About — Hiển thị thông tin phiên bản ứng dụng và trạng thái bản quyền (License) |
| **F12** | Tắt thiết bị an toàn |

:::note
Các phần mềm cứu hộ được gán cho các phím tắt từ **F7 đến F10** là các ứng dụng dạng Portable được đóng gói sẵn trong thư mục `Softwares\` trên USB thông qua công cụ **EasyDeploy-BootBuilder**. Engine định tuyến đường dẫn của các công cụ này dựa trên cấu hình tại khóa `toolPaths` trong tệp tin `system-config.json`, ánh xạ vào thư mục `Softwares\`. Trong trường hợp thiết bị USB bị thiếu tệp tin chương trình của công cụ, phím tắt tương ứng sẽ không thể kích hoạt — kỹ thuật viên cần sao chép bổ sung file ứng dụng vào đúng thư mục chỉ định. Xem thêm chi tiết tại [File cấu hình](/easydeploy/reference/configuration/).

Phím tắt **F1** (BitLocker) và **F2** (WiFi) là các tính năng được tích hợp sâu trong nhân hệ thống nên **luôn sẵn sàng hoạt động**. Phím **F2** được thiết lập thời gian chờ (cooldown) qua thông số `wifiCooldownSeconds` nhằm hạn chế các thao tác nhấn nhầm, đồng thời hệ thống sẽ hiển thị cảnh báo nếu phát hiện thiết bị đang có kết nối mạng LAN có dây ổn định.
:::
