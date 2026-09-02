---
title: 'Câu hỏi thường gặp (FAQ)'
---

Những câu hỏi thường gặp khi sử dụng EASYDEPLOY, tổng hợp từ Docs và Troubleshooting. Nếu
chưa thấy vấn đề của mình, xem chi tiết từng chủ đề trong
[Troubleshooting](/easydeploy/reference/troubleshooting/).

## License

### Tại sao báo "License không hợp lệ / hết hạn / sai USB"?

License (`*.lic`) được gắn với USB-SN và có thời hạn. Kiểm tra:

- File `*.lic` đặt đúng trong `EASYDEPLOY\` trên **đúng USB** đã đăng ký.
- License chưa hết hạn, và gói dịch vụ (tier) phù hợp tính năng đang dùng.

Nếu vẫn lỗi, liên hệ CoreSystem để cấp lại hoặc re-key (khi USB hỏng/mất).
Chi tiết: [Troubleshooting](/easydeploy/reference/troubleshooting/).

### USB chất lượng thấp có ảnh hưởng đến license không?

Có thể. Bản quyền gắn với số sê-ri (SN) của USB — một số USB giá rẻ không có SN chuẩn
hoặc trùng SN giữa các ổ, khiến license không ghi nhận đúng. Nên dùng USB có thương hiệu,
firmware ổn định (xem [License Tiers](/easydeploy/msp/license-tiers/)).

## Triển khai

### Không thấy ổ đĩa khi chọn target?

Thường do thiếu driver storage/controller (VD: Intel RST/VMD, RAID). USB tiêu chuẩn phủ
tốt phần cứng phổ biến; với phần cứng đặc thù, cần bổ sung driver qua BootBuilder
(xem [BootBuilder](/easydeploy/msp/bootbuilder/)).

### Cài xong nhưng Windows chưa kích hoạt?

EASYDEPLOY chỉ điều phối quá trình cài đặt, **không can thiệp kích hoạt bản quyền**.
Việc kích hoạt theo mô hình của khách hàng (Retail, Volume/KMS, MAK...). Xác định rõ mô
hình kích hoạt khi chuẩn bị cấu hình (xem [Các chế độ triển khai](/easydeploy/getting-started/deploy-modes/)).

### Báo "Offline image hash mismatch"?

File `.esd` cục bộ đã bị đổi tên, chỉnh sửa hoặc hỏng — không khớp mã băm trong Catalog.
Dùng lại file chính xác tải từ Catalog (xem [Troubleshooting](/easydeploy/reference/troubleshooting/)).

## Gói dịch vụ

### Dữ liệu telemetry của tôi nằm ở đâu?

- **Free:** CSV trên USB — `[USB]:\EASYDEPLOY\Log\deploy-results.csv`.
- **MSP Advanced:** gửi về endpoint bạn tự host (BYOB) — chi tiết trong tài liệu kỹ thuật kèm `.lic`.

CoreSystem không nhận dữ liệu của bạn (xem [Telemetry](/easydeploy/reference/telemetry/)).

## Khác

### Không kết nối được WiFi trong WinPE?

Kiểm tra SSID/mật khẩu, hoặc card WiFi chưa được WinPE hỗ trợ — cần tích hợp driver qua
BootBuilder (xem [Troubleshooting](/easydeploy/reference/troubleshooting/)).

### Tôi nên dùng luồng nào: Vanilla, Business hay Express?

- **Vanilla (1):** cài Windows gốc, không tùy biến.
- **Business (2):** cài kèm profile doanh nghiệp.
- **Express (F3):** tự động theo cấu hình sẵn — phù hợp triển khai số lượng lớn.

Chi tiết tại [Các chế độ triển khai](/easydeploy/getting-started/deploy-modes/).