---
title: 'Quick Start — Windows tự cài hết trong ~15 phút'
---

Mục tiêu: Boot USB → chọn luồng cài đặt → hoàn thành, hoàn toàn tự động. Không cần cài đặt thêm phần mềm nào.

> **Nhịp thời gian tham khảo:** chưa đầy 5 phút cho engine tự chạy trọn 11 bước bung cài, cộng khoảng 10 phút hậu kỳ tự động sau cài đặt (OOBE + post-setup) — tổng ~15 phút một máy với ZeroTouch; Express chỉ thêm 2 thao tác bấm phím (F3 + confirm). Thời gian thực tế tùy tốc độ mạng và ổ đĩa.

## 1. Chuẩn bị

1. Kết nối USB vào máy tính cần cài đặt.
2. Khởi động máy, nhấn phím truy cập Boot Menu (**F12, F9, hoặc Esc** tùy dòng máy) → chọn boot từ USB.
3. Sau khi WinPE tải xong, giao diện **EASYDEPLOY** tự động hiển thị.

:::caution
Kiểm tra kết nối mạng trước khi cài. Nếu chưa có internet, nhấn **F2** kết nối WiFi. Hoặc đảm bảo đã có file `.esd` trong `EASYDEPLOY\OS\` trên USB.
:::

## 2. Chọn luồng cài đặt

Trên giao diện chính, chọn 1 trong 3 luồng:

| Phím | Luồng | Mô tả |
|------|-------|-------|
| **1** | Vanilla | Windows gốc, không tùy biến |
| **2** | Business | Windows + profile doanh nghiệp (khuyến nghị) |
| **F3** | Express | Tự động hoàn toàn theo `user-config.json` |

**Luồng Business (2):** Chọn OS → chọn Profile → chọn ổ đĩa → **START OS DEPLOYMENT**.

**Luồng Express (F3):** Hệ thống tự đọc cấu hình từ `user-config.json` → hiện 1 dialog xác nhận → tự chạy.

:::tip
Nếu USB không có profile nào, hệ thống tự động dùng profile mặc định (`1.Tweaks`).
:::

## 3. Theo dõi và hoàn thành

- Theo dõi tiến trình `[STEP x/11]` trên màn hình. Thiết bị tự khởi động lại khi hoàn tất.
- Sau reboot, Windows vào màn hình OOBE hoặc Desktop theo cấu hình profile.

## Khắc phục nhanh

| Triệu chứng | Xử lý |
|-------------|-------|
| Không thấy ổ đĩa đích | Kiểm tra BIOS (AHCI/RAID), đảm bảo có driver tương ứng |
| Lỗi bản quyền | Kiểm tra file `*.lic` trong `EASYDEPLOY\`, đúng USB-SN |
| Không có internet | Nhấn **F2** kết nối WiFi, hoặc dùng file `.esd` offline |
| Deploy thất bại | Xem log tại `[USB]:\EASYDEPLOY\Log\deploy-error-*.log` |

## Liên kết hữu ích

- [Các chế độ triển khai](/easydeploy/getting-started/deploy-modes/) — Chi tiết từng luồng
- [BootBuilder](/easydeploy/msp/bootbuilder/) — Tự dựng USB tùy biến (MSP)
- [License Tiers](/easydeploy/msp/license-tiers/) — Thông tin gói dịch vụ
