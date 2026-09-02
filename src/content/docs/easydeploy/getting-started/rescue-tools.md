---
title: 'Bộ công cụ Rescue'
---

Môi trường WinPE tích hợp sẵn các công cụ cứu hộ. Truy cập bằng phím tắt trên giao diện chính.

## Danh mục phím tắt

| Phím | Công cụ | Chức năng |
|------|---------|-----------|
| **F1** | BitLocker | Mở khóa phân vùng mã hóa |
| **F2** | WiFi | Kết nối mạng không dây |
| **F4** | Notepad | Xem/sửa file văn bản, log |
| **F5** | Diskpart | Quản lý phân vùng (CLI) |
| **F6** | PowerShell | Terminal quản trị |
| **F7** | DISK BACKUP | Sao lưu/khôi phục ổ đĩa (MultiDrive) |
| **F8** | FILE EXPLORER | Quản lý tệp tin (Explorer++) |
| **F9** | HARDWARE INFO | Chẩn đoán phần cứng (HWiNFO64) |
| **F10** | WEB BROWSER | Duyệt web (Pale Moon) |
| **F11** | About | Phiên bản + trạng thái license |
| **F12** | Shutdown | Tắt máy |

:::note
Các ứng dụng Portable nằm trong `Softwares\` trên USB — **không đi kèm bộ phát hành**: bổ sung qua BootBuilder khi build, hoặc copy thủ công + khai báo `user-config.json` (xem [File cấu hình](/easydeploy/reference/configuration/)). Nếu thiếu file, phím tương ứng sẽ không hoạt động.
:::

:::note
**Vì sao chỉ có 4 nút?** EasyDeploy được thiết kế là công cụ **deploy** — rescue chỉ là công cụ bổ trợ. Main window dành 4 nút quick-launch cho Portable Apps; nhãn và phím tắt ở footer **tự điều chỉnh theo công cụ bạn gắn** (qua `toolPaths`/`portableApps`).

Trên thực tế, bạn có thể copy **không giới hạn** tool vào USB — các công cụ ngoài 4 slot vẫn gọi bình thường qua **F6 (PowerShell)**, **F8 (Explorer)** hoặc cmd ngay trong WinPE.
:::

## Các tình huống thường gặp

### Cứu hộ dữ liệu khi Windows không khởi động được

Nhấn **F8** (FILE EXPLORER) → truy cập phân vùng dữ liệu → sao chép file ra USB ngoài.

Nếu phân vùng không hiển thị, có thể bị ẩn ký tự ổ hoặc mã hóa BitLocker → dùng **F1** mở khóa trước.

### Sao lưu/khôi phục toàn bộ ổ đĩa

Nhấn **F7** (MultiDrive) → chọn **Backup Image** → chọn nguồn → chọn đích → sao lưu.

Khôi phục: mở MultiDrive → **Restore** → trỏ tới file image.

:::danger
Restore sẽ xóa toàn bộ dữ liệu trên ổ đĩa đích. Kiểm tra kỹ trước khi thực hiện.
:::

### Mở khóa phân vùng BitLocker

Nhấn **F1** → chọn phân vùng bị khóa → nhập 48-digit Recovery Key → **UNLOCK DRIVE**.

:::note
Nhập sai nhiều lần có thể khóa vĩnh viễn phân vùng. Xác minh key trước khi nhập.
:::

### Kết nối WiFi trong WinPE

Nhấn **F2** → **SCAN NETWORKS** → chọn SSID → nhập mật khẩu → **CONNECT**.

Kiểm tra kết nối: **F6** (PowerShell) → chạy `ipconfig` hoặc `ping 8.8.8.8`.

:::tip
Có thể đặt WiFi mặc định trong `system-config.json` để WinPE tự kết nối khi khởi động.
:::

### Xem log khi deploy thất bại

Log lỗi tại `[USB]:\EASYDEPLOY\Log\deploy-error-*.log`. Dùng **F8** mở thư mục → **F4** xem nội dung. Tìm `[STEP x/11] ... FAIL` hoặc `[FATAL]`.

Log runtime (trước khi reboot): **F6** (PowerShell) → `Get-Content X:\deploy-log.txt`.

### Quản lý phân vùng thủ công

Nhấn **F5** (Diskpart) → `list disk` → `select disk N` → `clean` hoặc `create partition`.

:::danger
Lệnh `clean` xóa vĩnh viễn toàn bộ dữ liệu trên ổ đĩa được chọn.
:::

## Tổng hợp nhanh

| Tình huống | Công cụ |
|------------|---------|
| Cứu dữ liệu | FILE EXPLORER (**F8**) |
| Sao lưu/khôi phục ổ đĩa | DISK BACKUP (**F7**) |
| Chẩn đoán phần cứng | HARDWARE INFO (**F9**) |
| Tra cứu thông tin | WEB BROWSER (**F10**) + WiFi (**F2**) |
| Mở khóa BitLocker | BitLocker (**F1**) |
| Kết nối mạng | WiFi (**F2**) + PowerShell (**F6**) |
| Quản lý phân vùng | Diskpart (**F5**) |
| Đọc log lỗi | Notepad (**F4**) + Explorer (**F8**) |