---
title: 'Hướng dẫn khắc phục sự cố (Troubleshooting)'
---

Danh mục sự cố thường gặp và hướng dẫn xử lý.

## 1. Sự cố phát sinh trong quá trình triển khai (Deployment)

Triển khai Windows là bước quan trọng nhất, các lỗi ở giai đoạn này thường liên quan đến ổ đĩa, bản quyền hoặc kết nối mạng.

| Triệu chứng | Nguyên nhân / Cách xử lý |
|-------------|---------------------------|
| Không hiển thị ổ đĩa đích cần cài đặt | Hệ thống chỉ hiển thị các ổ đĩa vật lý đủ điều kiện triển khai (tự động loại bỏ ổ USB boot, ổ đĩa ảo và các thiết bị không có phân vùng). Chọn đúng ổ đĩa; kiểm tra thiết lập controller trong BIOS (AHCI/RAID) — nếu thiếu driver điều khiển, cần tích hợp driver tương ứng vào WinPE. |
| Lỗi bản quyền ngoại tuyến (License không hợp lệ / hết hạn / sai USB) | File `*.lic` sai, hết hạn, hoặc USB đang cắm không nằm trong danh sách `Usb` bind của license → **liên hệ CoreSystem cấp file `.lic` mới** (hoặc re-key khi USB hỏng/mất). |
| WinPE không có kết nối Internet | Nhấn phím **F2** để thiết lập kết nối mạng không dây, hoặc kiểm tra kết nối cáp mạng LAN; hoặc chuyển sang phương án sử dụng nguồn cài đặt OS offline (`EASYDEPLOY\OS\`). |
| Lỗi bảo mật SSL/TLS khi tải file cài đặt | Đồng hồ hệ thống trên môi trường WinPE (thời gian UTC) bị sai lệch quá nhiều so với thực tế, gây lỗi xác thực chứng chỉ TLS/SSL → Chuyển sang sử dụng nguồn cài đặt offline ESD hoặc đồng bộ lại thời gian thực trong BIOS. |
| Lỗi: `Image is not available offline ... download URL is not reachable` | Hệ thống không tìm thấy tệp tin `.esd` offline trên USB, đồng thời thiết bị không có kết nối mạng để tải từ Cloud → Truy cập <https://esd.coresystem.vn> tải tệp tin cài đặt tương ứng và sao chép vào đúng thư mục `EASYDEPLOY\OS\` trên USB (giữ nguyên tên tệp tin). |
| Lỗi: `Offline image hash mismatch` | Tệp tin `.esd` cục bộ đã bị đổi tên, chỉnh sửa hoặc bị hỏng → tiến trình xác minh mã băm SHA-256 thất bại. Sử dụng tệp tin chính xác được tải về từ hệ thống Catalog. |
| Tiến trình triển khai thất bại (Failed) tại một bước cụ thể | Phân tích nhật ký lỗi tại: `[USB]:\EASYDEPLOY\Log\deploy-error-<timestamp>.log` (tìm kiếm các từ khóa `[STEP x/11] ... FAIL` hoặc `[FATAL]`); hoặc xem tệp `X:\deploy-log.txt` trực tiếp trên RAM disk trước khi thiết bị khởi động lại. |
| Lặp chu kỳ khởi động (Reboot Loop) hoặc không thể truy cập màn hình OOBE | Kiểm tra lại cấu hình phân vùng khởi động Bootloader (`bcdboot`) và thứ tự ưu tiên thiết bị boot (Boot Order) trong BIOS/UEFI; thử triển khai ở chế độ Vanilla để loại trừ nguyên nhân do script tùy biến trong profile. |

:::note
EASYDEPLOY còn hỗ trợ xuất tệp tin chẩn đoán tại ổ đĩa ảo RAM disk `X:\` (tự xóa khi khởi động lại):

| Tệp tin chẩn đoán | Nội dung |
|------|----------|
| `X:\easydeploy-app.log` | Nhật ký hoạt động ứng dụng EasyDeploy |
| `X:\deploy-log.txt` | Nhật ký tiến trình triển khai (các bước `[STEP x/11]`) |
| `X:\deploy-launch.txt` | Thông tin chẩn đoán chi tiết khi khởi chạy triển khai |

:::


## 2. Sự cố liên quan đến Profiles và Script Post-setup

Profiles quyết định cách Windows được cấu hình sau khi cài đặt — lỗi ở đây thường do sai đường dẫn hoặc thiếu file.

| Triệu chứng | Nguyên nhân / Cách xử lý |
|-------------|---------------------------|
| Thư mục profile không hiển thị trong danh sách lựa chọn | Kiểm tra rằng thư mục profile nằm đúng đường dẫn `EASYDEPLOY\Profiles\` trên USB và chứa đầy đủ bộ đôi tệp tin (`*.xml` và `*.ps1`). Trình quét tự động chỉ nhận diện profile khi thư mục chứa **ít nhất một** trong hai tệp tin được đặt tên chính xác: `unattend.xml` hoặc `post-setup.ps1`. |
| Triển khai không kèm theo profile tùy biến | Khi thư mục Profiles trên USB trống, luồng cài đặt Business (2) và Express (F3) sẽ tự động chuyển sang cơ chế dự phòng áp dụng **Profile mặc định của hệ thống** (tương đương kịch bản `1.Tweaks` tiêu chuẩn doanh nghiệp) — xem thêm [Profiles Overview](/easydeploy/profiles/profiles/). |
| Script `Post-setup.ps1` không khởi chạy | Kiểm tra cấu hình `FirstLogonCommands` trong tệp `unattend.xml` xem đã trỏ chính xác đến đường dẫn mục tiêu `C:\CoreSystem\Post-setup.ps1` hay chưa; đồng thời kiểm tra rằng tệp tin script được đặt tên chính xác là `Post-setup.ps1`. |
| Script PowerShell thực thi bình thường nhưng không tải được dữ liệu | Thiết bị không có kết nối internet hoặc proxy cấu hình bị chặn → Các tác vụ yêu cầu tải dữ liệu từ mạng sẽ tự động bị bỏ qua (áp dụng đối với kịch bản tích hợp sẵn hàm `Wait-ForInternet`). Kiểm tra lại cấu hình cổng mạng hoặc proxy. |
| Script thực thi bị Windows chặn bảo mật (Execution Blocked) | Duy trì lệnh mở khóa script `Unblock-File ...; & 'C:\CoreSystem\Post-setup.ps1'` trong phân hệ `FirstLogonCommands` của tệp `unattend.xml`. |
| Thiết bị sau khi cài đặt vẫn lưu lại các thư mục tạm thời (Panther/CoreSystem) | Phân đoạn cấu hình tự động dọn dẹp (Cleanup) qua cơ chế RunOnce trong `post-setup.ps1` có thể đã bị kỹ thuật viên loại bỏ → Cần bổ sung lại đoạn script dọn dẹp hoặc xóa thủ công trên máy trạm. |
| Đã chỉnh sửa nội dung profile nhưng thiết bị vẫn cài đặt theo cấu hình cũ | Do EASYDEPLOY quét và đọc dữ liệu trực tiếp từ USB, kiểm tra rằng bạn đã ghi đè tệp tin cấu hình mới lên đúng phân vùng USB triển khai trước khi boot và cài đặt lại. |

## 3. Sự cố liên quan đến các công cụ cứu hộ (Rescue Tools)

| Triệu chứng | Nguyên nhân / Cách xử lý |
|-------------|---------------------------|
| Nhấn các phím nóng từ F7 đến F10 không thể mở công cụ | Các ứng dụng Portable chưa được sao chép vào đúng thư mục chỉ định trên USB. Kiểm tra lại đường dẫn tương đối được khai báo trong `system-config.json` hoặc cấu hình ghi đè trong `user-config.json`. |
| Trình duyệt Web báo lỗi chứng chỉ SSL/TLS khi truy cập mạng trong WinPE | Môi trường WinPE thiếu các chứng chỉ CA hệ thống cập nhật → Thử truy cập các website hỗ trợ giao thức HTTP thông thường (nếu an toàn), hoặc tải trước tệp tin trên máy trạm khác rồi sao chép vào USB cứu hộ. |
| Nhấn phím F1 không thể kích hoạt giao diện BitLocker | Hệ thống không phát hiện bất kỳ phân vùng ổ đĩa nào đang bị khóa mã hóa trên thiết bị. |
| Không thể kết nối mạng không dây WiFi | Thông tin tên mạng (SSID) hoặc mật khẩu bị sai lệch; hoặc card mạng của thiết bị chưa được WinPE hỗ trợ → Cần tích hợp driver card WiFi tương thích vào môi trường WinPE thông qua BootBuilder. |

## 4. Sự cố liên quan đến Xác thực bản quyền (Authentication / License)

| Triệu chứng | Nguyên nhân / Cách xử lý |
|-------------|---------------------------|
| `License is not valid.` | Khóa bản quyền ngoại tuyến (Offline License) không chính xác, bị nhập thiếu ký tự hoặc đã quá hạn sử dụng → **Liên hệ CoreSystem để yêu cầu cấp lại khóa bản quyền mới**. |
| `Please check your BIOS time settings.` | Đồng hồ thời gian thực (RTC) trong BIOS bị sai lệch quá nhiều so với thực tế → Truy cập BIOS của thiết bị và điều chỉnh lại múi giờ chính xác. |
| `Please contact CoreSystem to renew your license.` | Khóa bản quyền đã hết hiệu lực vận hành → Liên hệ bộ phận kinh doanh của CoreSystem để gia hạn. |
| Cảnh báo bản quyền chuẩn bị hết hạn (NearExpiry - dưới 14 ngày) | Doanh nghiệp nên lên kế hoạch đăng ký hoặc gia hạn bản quyền mới để tránh gián đoạn quy trình triển khai. |

## 5. Sự cố liên quan đến đồng bộ dữ liệu hoạt động (Telemetry / BYOB)

| Triệu chứng | Nguyên nhân / Cách xử lý |
|-------------|---------------------------|
| Không thấy dữ liệu trong DB endpoint của mình (BYOB) | Telemetry **chỉ có hiệu lực với gói MSP Advanced** (gate theo tier) và phải cấu hình block `telemetry` trong `system-config.json` (`enabled=true` + `endpoint` + `apiKey`). MSP Standard không gửi — dữ liệu nằm **CSV trên USB** (`[USB]:\EASYDEPLOY\Log\deploy-results.csv`). |
| Thông số `usb_brand` hoặc `usb_serial` hiển thị giá trị trống (NULL) | Phiên triển khai này được thực hiện trên môi trường máy ảo (Virtual Machine - VM), do đó không có thông tin định danh phần cứng của USB vật lý — đây là hiện tượng bình thường. |
| Khó theo dõi dữ liệu qua mã build hệ điều hành (os_build) | Ưu tiên theo dõi qua `os_version` (VD `25h2`), hoặc truy vấn SQL trên DB của bạn: `SELECT os_version, os_build ... FROM deploy_results`. |

## 6. Quy trình yêu cầu hỗ trợ kỹ thuật

Trong trường hợp không thể tự xử lý, thu thập:

1. Bản sao tệp tin nhật ký lỗi: `[USB]:\EASYDEPLOY\Log\deploy-error-*.log` (nếu có).
2. Ảnh chụp màn hình hiển thị lỗi trực quan (giao diện dòng lệnh console, thông báo lỗi bản quyền,...).
3. Cung cấp thông tin license đang sử dụng (file `*.lic`) và gói dịch vụ (tier).

Gửi yêu cầu hỗ trợ kỹ thuật tại: <https://www.coresystem.vn>