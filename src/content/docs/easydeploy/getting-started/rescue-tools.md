---
title: 'Bộ công cụ Rescue — Các tình huống sử dụng'
---

Môi trường WinPE của EASYDEPLOY được tích hợp sẵn bộ công cụ cứu hộ chuyên dụng, cho phép vận hành ngay cả khi hệ điều hành Windows trên máy trạm gặp sự cố nghiêm trọng không thể khởi động. Quản trị viên có thể truy cập nhanh các công cụ này bằng phím tắt (Hotkeys) trên màn hình chính hoặc qua các nút bấm tương ứng trên giao diện.

## Danh mục công cụ

| Phím nóng | Công cụ | Chức năng chính |
|------|---------|-----------|
| **F1** | BitLocker | Mở khóa và truy cập các phân vùng được mã hóa bằng BitLocker trong WinPE |
| **F2** | WiFi | Thiết lập kết nối mạng không dây (WiFi) |
| **F4** | Notepad | Xem và chỉnh sửa các tệp tin văn bản, file cấu hình hoặc file nhật ký (log) |
| **F5** | Diskpart | Trình quản lý phân vùng ổ đĩa qua dòng lệnh (Diskpart) |
| **F6** | PowerShell | Môi trường dòng lệnh PowerShell để thực thi script và lệnh quản trị |
| **F7** | DISK BACKUP (MultiDrive) | Sao lưu và phục hồi dữ liệu ổ đĩa dưới dạng file image |
| **F8** | FILE EXPLORER (Explorer++) | Trình quản lý tệp tin (File Explorer) phục vụ cứu hộ dữ liệu |
| **F9** | HARDWARE INFO (HWInfo) | Kiểm tra chi tiết thông tin và chẩn đoán trạng thái phần cứng |
| **F10** | WEB BROWSER (Palemoon) | Trình duyệt web phục vụ tra cứu thông tin trong môi trường WinPE |
| **F11** | About | Hiển thị thông tin phiên bản phần mềm và trạng thái bản quyền (License) |
| **F12** | Shutdown | Tắt thiết bị an toàn |

:::note
Các ứng dụng dạng Portable (MultiDrive, Explorer++, HWInfo, Palemoon) được đóng gói sẵn vào thư mục `Softwares\` trên USB thông qua công cụ **EasyDeploy-BootBuilder**. Engine EASYDEPLOY xác định đường dẫn của các công cụ này dựa trên cấu hình tại phân hệ `toolPaths` trong tệp tin `system-config.json`, định tuyến trực tiếp vào thư mục `Softwares\` trên USB (tham khảo thêm [File cấu hình](/easydeploy/reference/configuration/)). Trong trường hợp USB bị thiếu tệp tin của công cụ, phím nóng tương ứng sẽ không thể kích hoạt. Khi đó, vui lòng sử dụng BootBuilder để xây dựng (build) lại bộ phương tiện cài đặt đầy đủ (tham khảo [BootBuilder (Whitebox)](/easydeploy/msp/bootbuilder/)).
:::

---

## Tình huống 1: Thiết bị không thể khởi động vào Windows, cần sao lưu dữ liệu khẩn cấp

**Công cụ sử dụng:** **FILE EXPLORER (F8)**

1. Khởi động thiết bị vào môi trường WinPE → nhấn phím **F8** (hoặc chọn nút **FILE EXPLORER**).
2. Truy cập vào các phân vùng lưu trữ dữ liệu (C:, D:,...).
3. Tiến hành sao chép (copy) các dữ liệu quan trọng sang thiết bị lưu trữ ngoài hoặc phân vùng dự phòng.

:::tip
Nếu phân vùng ổ đĩa không hiển thị trong Explorer, nguyên nhân có thể do phân vùng chưa được gán ký tự ổ đĩa (Drive Letter) hoặc đang bị mã hóa bởi BitLocker — vui lòng xem hướng dẫn tại Tình huống 5 & 7.
:::

---

## Tình huống 2: Sao lưu (Backup) toàn bộ ổ đĩa trước khi thay thế phần cứng hoặc định dạng (Format)

**Công cụ sử dụng:** **DISK BACKUP (F7 / MultiDrive)**

1. Kết nối ổ đĩa hoặc USB lưu trữ (đảm bảo đủ dung lượng trống) vào thiết bị, đặt tên nhãn (label) là `DISK BACKUP`.
2. Nhấn phím **F7** để khởi chạy công cụ MultiDrive.
3. Lựa chọn chế độ **Backup Image** → chọn ổ đĩa nguồn cần sao lưu → chọn ổ đĩa đích để lưu file image → tiến hành sao lưu.
4. Khi cần khôi phục, khởi động lại thiết bị vào WinPE → mở MultiDrive → lựa chọn chế độ **Restore** và trỏ tới file image đã sao lưu.

:::danger
Thao tác phục hồi (Restore) sẽ ghi đè và xóa toàn bộ dữ liệu hiện có trên ổ đĩa đích. Vui lòng kiểm tra và xác nhận chính xác ổ đĩa nguồn và ổ đĩa đích trước khi thực hiện.
:::

---

## Tình huống 3: Kiểm tra và chẩn đoán sự cố phần cứng

**Công cụ sử dụng:** **HARDWARE INFO (F9 / HWInfo)**

1. Nhấn phím **F9** để mở công cụ HWInfo.
2. Kiểm tra các thông số vận hành: Nhiệt độ CPU/GPU, trạng thái sức khỏe ổ cứng (S.M.A.R.T), thông số bộ nhớ RAM, điện áp nguồn, và phiên bản BIOS hiện tại.
3. Sử dụng các chỉ số chẩn đoán này để xác định lỗi thuộc về phần cứng hay cần đề xuất thay thế linh kiện.

---

## Tình huống 4: Cần tra cứu thông tin, tải driver hoặc tài liệu hướng dẫn trong quá trình xử lý sự cố

**Công cụ sử dụng:** **WEB BROWSER (F10 / Palemoon)**

1. Thiết lập kết nối mạng: Nhấn phím **F2** để kết nối WiFi hoặc kết nối trực tiếp qua cáp mạng LAN.
2. Nhấn phím **F10** để mở trình duyệt web.
3. Tra cứu các thông tin kỹ thuật, tải driver phần cứng hoặc tài liệu cần thiết và lưu vào USB.

:::caution
Do môi trường WinPE có thể thiếu một số chứng chỉ CA hệ thống (Certificate Authority), một số trang web có thể báo lỗi bảo mật SSL/TLS. Trong trường hợp bị chặn kết nối, bạn có thể thử truy cập qua giao thức HTTP (nếu trang web an toàn), hoặc tải tệp tin trước trên một thiết bị khác rồi sao chép vào USB cứu hộ.
:::

---

## Tình huống 5: Truy cập và mở khóa phân vùng được mã hóa bằng BitLocker

**Công cụ sử dụng:** **BitLocker (F1)**

1. Nhấn phím **F1** → Hệ thống EASYDEPLOY sẽ tự động quét và liệt kê các phân vùng đang bị khóa mã hóa.
2. Lựa chọn phân vùng cần truy cập → Nhập mật khẩu người dùng hoặc khóa khôi phục (BitLocker Recovery Key).
3. Sau khi mở khóa thành công, phân vùng sẽ hiển thị đầy đủ cấu trúc dữ liệu trong File Explorer (**F8**).

:::note
Lưu ý: Việc nhập sai mật khẩu BitLocker nhiều lần có thể kích hoạt cơ chế bảo vệ bổ sung và khóa hoàn toàn phân vùng. Hãy xác minh chính xác thông tin khóa trước khi nhập.
:::

---

## Tình huống 6: Thiết lập kết nối mạng trong môi trường WinPE

**Công cụ sử dụng:** **WiFi (F2) + PowerShell (F6)**

1. Nhấn phím **F2** → Lựa chọn mạng không dây (SSID) → Nhập mật khẩu để kết nối.
2. Kiểm tra và xác thực trạng thái kết nối mạng qua PowerShell (**F6**) bằng các lệnh tiêu chuẩn như `ipconfig` hoặc `ping 8.8.8.8`.

:::tip
Quản trị viên có thể khai báo trước thông tin SSID và mật khẩu WiFi mặc định tại các khóa `"defaultWifiSsid"` và `"defaultWifiPassword"` trong tệp tin `system-config.json` để WinPE tự động kết nối khi khởi động. Xem chi tiết tại [File cấu hình](/easydeploy/reference/configuration/).
:::

---

## Tình huống 7: Thao tác và quản lý phân vùng ổ đĩa thủ công

**Công cụ sử dụng:** **Diskpart (F5)**

1. Nhấn phím **F5** để khởi chạy Diskpart trong cửa sổ dòng lệnh.
2. Thực thi chuỗi lệnh quản trị: `list disk` để xem danh sách ổ đĩa → `select disk N` để chọn ổ đĩa đích → thực hiện các tác vụ `clean` (xóa phân vùng) hoặc `create partition` (tạo phân vùng mới) theo yêu cầu kỹ thuật.
3. Nhập lệnh `exit` để đóng công cụ sau khi hoàn tất.

:::danger
Lưu ý: Các lệnh `clean` hoặc `delete partition` sẽ xóa bỏ vĩnh viễn toàn bộ dữ liệu trên ổ đĩa được chọn. Hãy chắc chắn rằng bạn đã chọn chính xác ổ đĩa đích trước khi thực thi.
:::

---

## Tình huống 8: Phân tích tệp nhật ký (Log) và kịch bản triển khai khi xảy ra lỗi

**Công cụ sử dụng:** **Notepad (F4) + PowerShell (F6) + FILE EXPLORER (F8)**

1. Trong trường hợp quá trình triển khai thất bại, tệp nhật ký lỗi sẽ được lưu tự động tại `[USB]:\EASYDEPLOY\Log\deploy-error-*.log`.
2. Nhấn **F8** để mở Explorer, di chuyển đến thư mục `EASYDEPLOY\Log\` → Nhấn **F4** để mở tệp log bằng Notepad.
3. Tìm kiếm các từ khóa lỗi như `[STEP x/11] ... FAIL` hoặc `[FATAL]` để xác định bước phát sinh lỗi.
4. Để phân tích chi tiết hơn: Nhấn **F6** để mở PowerShell và chạy lệnh `Get-Content X:\deploy-log.txt` (hoặc `type X:\deploy-log.txt`) để xem toàn bộ nhật ký runtime ghi nhận trong quá trình cài đặt.

---

## Bảng tổng hợp Tình huống và Công cụ tương ứng

| Tình huống | Công cụ chính |
|------------|---------------|
| Cứu hộ dữ liệu trên thiết bị không thể khởi động | FILE EXPLORER (**F8**) |
| Sao lưu hoặc khôi phục phân vùng ổ đĩa | DISK BACKUP (**F7**) |
| Chẩn đoán sức khỏe phần cứng | HARDWARE INFO (**F9**) |
| Tra cứu tài liệu hoặc tải tệp tin hỗ trợ | WEB BROWSER (**F10**) + WiFi (**F2**) |
| Phân vùng bị khóa mã hóa BitLocker | BitLocker (**F1**) |
| Thiết lập kết nối mạng cho WinPE | WiFi (**F2**) + PowerShell (**F6**) |
| Quản lý và phân chia phân vùng thủ công | Diskpart (**F5**) |
| Đọc nhật ký lỗi hoặc thực thi lệnh quản trị | Notepad (**F4**) + PowerShell (**F6**) |
