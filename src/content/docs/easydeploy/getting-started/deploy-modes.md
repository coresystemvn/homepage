---
title: 'Các chế độ triển khai'
---

EASYDEPLOY cung cấp 3 chế độ cài đặt Windows. Việc lựa chọn đúng chế độ sẽ quyết định hệ thống được cài đặt theo bản gốc tiêu chuẩn (Vanilla) hay bản tích hợp cấu hình doanh nghiệp (Business/Express).

## Bảng so sánh nhanh các chế độ

| | **Vanilla** (phím 1) | **Business** (phím 2) | **Express** (phím F3) |
|---|---|---|---|
| Tên hiển thị trên giao diện | SETUP WINDOWS [DEFAULT] | SETUP WINDOWS [BUSINESS] | — (phím F3) |
| Áp dụng Profile (unattend + post-setup) | ❌ Không | ✅ Có | ✅ Có (lấy từ `deploy.profile`) |
| Nguồn thiết lập thông số OS | Người dùng chọn qua OSConfigurator | Người dùng chọn qua OSConfigurator | `user-config.json → deploy` |
| Yêu cầu xác nhận | 1 hộp thoại cảnh báo (Warning) | 1 hộp thoại cảnh báo (Warning) | 1 hộp thoại cảnh báo duy nhất |
| Đối tượng sử dụng phù hợp | Cài đặt Windows nguyên bản | Tích hợp quy chuẩn doanh nghiệp | Triển khai thiết bị số lượng lớn |

## Chế độ Vanilla — Cài đặt hệ điều hành nguyên bản

- **Trường hợp áp dụng:** Khi cần cài đặt một bản Windows sạch hoàn toàn (nguyên bản từ Microsoft), không kèm theo bất kỳ tùy biến nào, hoặc khi các profile doanh nghiệp hiện có không phù hợp.
- **Cách thực hiện:** Nhấn phím **1** hoặc chọn nút **SETUP WINDOWS [DEFAULT]** trên màn hình → Lựa chọn phiên bản OS/edition và ổ đĩa mục tiêu → Nhấn **Deploy**.
- **Đặc điểm vận hành:** Hệ thống sẽ không tích hợp thêm bất kỳ tệp tin cấu hình nào vào Windows Image. Thiết bị sẽ khởi động trực tiếp vào màn hình thiết lập OOBE chuẩn của Microsoft.

## Chế độ Business — Cài đặt tích hợp quy chuẩn doanh nghiệp

- **Trường hợp áp dụng:** Triển khai thiết bị tuân thủ theo các chính sách và tiêu chuẩn nội bộ của doanh nghiệp (ví dụ: tự động tạo tài khoản mặc định, cấu hình autologon, áp dụng các tinh chỉnh tweaks hệ thống, thay đổi hình nền, cài đặt sẵn ứng dụng,...).
- **Cách thực hiện:** Nhấn phím **2** hoặc chọn nút **SETUP WINDOWS [BUSINESS]** → Chọn phiên bản OS → Chọn **Profile** phù hợp (danh sách được tự động quét từ USB) → Chọn ổ đĩa mục tiêu → Nhấn **Deploy**.
- **Đặc điểm vận hành:** Sau khi hoàn thành giải nén hệ điều hành, engine sẽ tự động sao chép tệp tin `unattend.xml` vào thư mục `C:\Windows\Panther\unattend.xml` và tệp tin `Post-setup.ps1` vào thư mục `C:\CoreSystem\Post-setup.ps1` trên phân vùng đích. Khi thiết bị khởi động, Windows Setup sẽ đọc file trả lời tự động ở giai đoạn cấu hình và tự động thực thi script PowerShell trong lần đăng nhập đầu tiên. Xem chi tiết tại [Profiles Overview](/easydeploy/profiles/profiles/).

:::note
**Danh sách profile có sẵn:** Công cụ EasyDeploy-BootBuilder đóng gói sẵn hai profile tiêu chuẩn trong thư mục `EASYDEPLOY\Profiles\` (xem thêm [BootBuilder — Cấu trúc USB](/easydeploy/msp/bootbuilder/#cấu-trúc-usb-sau-khi-build)):

- **`1.Tweaks`** — tweaks hệ thống cơ bản (wallpaper, dọn dẹp, cấu hình high performance…).
- **`2.TweaksApp`** — kế thừa tweaks + cài thêm ứng dụng (qua WinGet…).

Đây là các cấu hình đã được tối ưu hóa cho môi trường thực tế (production-ready) và có thể sử dụng ngay lập tức, đồng thời đóng vai trò làm mẫu để doanh nghiệp tùy biến theo nhu cầu riêng (xem [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/)).

Nếu không phát hiện bất kỳ profile nào trong USB (cho cả hai luồng Business và Express), hệ thống sẽ tự động chuyển sang chế độ dự phòng (fallback) áp dụng **Profile mặc định** (tương đương profile `1.Tweaks`). Bản cài đặt đầu ra vẫn đạt tiêu chuẩn vận hành mà không bắt buộc quản trị viên phải chuẩn bị sẵn profile.
:::

## Chế độ Express — Quy trình triển khai tự động qua một phím bấm (F3)

- **Trường hợp áp dụng:** Triển khai cài đặt thiết bị với số lượng lớn; kỹ thuật viên IT chỉ cần khởi động thiết bị vào WinPE và nhấn phím **F3** để toàn bộ quy trình tự động diễn ra.
- **Điều kiện kích hoạt:** Giá trị cấu hình `"enableF3Express": true` phải được thiết lập trong tệp tin `user-config.json`. Nếu thông số này bị tắt (false), phím F3 sẽ không có hiệu lực.
- **Cách thực hiện:** Nhấn phím **F3** → Hệ thống tự động đọc cấu hình tại phân hệ `deploy` trong tệp tin `user-config.json` (bao gồm thông tin về OS, edition, activation, language, ổ đĩa, và profile chỉ định) → Xuất hiện duy nhất một hộp thoại cảnh báo → Tự động thực thi toàn bộ quy trình.
- **Xử lý thiếu thông tin cấu hình:** Nếu phân hệ `deploy` bị trống hoặc thiếu các thông số cần thiết, EASYDEPLOY sẽ tự động hiển thị giao diện cấu hình nhanh (OSConfigurator) để kỹ thuật viên lựa chọn thủ công trước khi cài.
- **Đặc điểm vận hành:** Đây là quy trình nhanh nhất và tối giản hóa thao tác của kỹ thuật viên. Tuy nhiên, phương thức này yêu cầu tệp tin `user-config.json` trên USB phải được thiết lập đầy đủ thông số trước đó. Nếu không tìm thấy profile được khai báo trong khóa `deploy.profile`, hệ thống sẽ tự động áp dụng **profile mặc định** (tương đương `1.Tweaks`) tương tự như luồng Business.

:::note
Cả 3 chế độ cài đặt đều sử dụng chung một engine triển khai gồm 11 bước tiêu chuẩn. Sự khác biệt duy nhất nằm ở nguồn cung cấp thông số cấu hình đầu vào và quyết định có tích hợp (inject) profile tùy biến vào hệ điều hành hay không.
:::

## Quy trình triển khai 11 bước của Engine

Tiến trình triển khai sẽ tự động thực hiện qua 11 bước tuần tự dưới đây:

| # | Bước | Chi tiết tác vụ |
|---|------|----------|
| 1 | Khởi tạo | Kiểm tra tính hợp lệ của tệp tin cấu hình và thông tin xác thực bản quyền. |
| 2 | Quét và lựa chọn ổ đĩa | Lọc danh sách các ổ đĩa phù hợp có thể cài đặt (loại trừ USB boot, ổ đĩa ảo và các thiết bị không có phân vùng lưu trữ). |
| 3 | Cấu hình phân vùng USB boot | Tạm thời thu hồi ký tự ổ đĩa (Drive Letter) của USB boot để tránh việc phân chia phân vùng nhầm lẫn, sau đó khôi phục lại trạng thái ban đầu. |
| 4 | Khởi tạo và phân chia phân vùng | Định dạng ổ đĩa chuẩn GPT và tạo các phân vùng hệ thống: EFI, MSR, Windows và Recovery. |
| 5 | Xác định nguồn hệ điều hành (OS Source) | Ưu tiên quét tệp tin `.esd` offline trên USB (`EASYDEPLOY\OS\`) → Kiểm tra mã hash SHA-256 → Nếu không có file cục bộ, tự động tải về từ CDN. |
| 6 | Lựa chọn phiên bản phân phối (Edition) | Áp dụng chính xác chỉ mục (index) của phiên bản hệ điều hành trong Windows Image. |
| 7 | Giải nén Windows Image | Sử dụng lệnh `Expand-WindowsImage` để xả nén file cài đặt lên phân vùng `C:\`. |
| 8 | Khởi tạo Bootloader | Sử dụng công cụ `bcdboot` để thiết lập các tệp tin khởi động trên ổ đĩa đích. |
| 9 | Tích hợp Driver (Inject) | Quét các driver phần cứng đang hoạt động trên môi trường WinPE (AHCI, RAID, NVMe, WiFi,...) và tích hợp trực tiếp vào hệ điều hành mới cài đặt. |
| 10 | Dọn dẹp tài nguyên tạm | Xóa bỏ các tệp tin và thư mục tạm thời phát sinh trong quá trình cài đặt. |
| 11 | Tích hợp Profile tùy biến | Tích hợp tệp cấu hình profile (đối với Business/Express) và chuẩn bị thiết bị để tự động khởi động lại vào màn hình OOBE. |

:::tip
Nếu xảy ra lỗi trong quá trình triển khai, engine sẽ tự động xuất và lưu tệp tin nhật ký lỗi tại đường dẫn `[USB]:\EASYDEPLOY\Log\deploy-error-<timestamp>.log` để phục vụ việc phân tích và khắc phục. Nhật ký vận hành thời gian thực (real-time log) được lưu tạm thời tại `X:\deploy-log.txt` (lưu trên RAM disk và sẽ tự động xóa sạch khi thiết bị khởi động lại).
:::
