---
title: 'Chính sách ghi nhận dữ liệu kỹ thuật (Telemetry)'
---

Tài liệu này công bố minh bạch và chi tiết các danh mục thông tin kỹ thuật mà hệ thống EASYDEPLOY ghi nhận sau mỗi phiên triển khai, đồng thời đưa ra **cam kết bảo mật chính thức về các dữ liệu tuyệt đối không thu thập**.

:::danger
**EASYDEPLOY cam kết TUYỆT ĐỐI KHÔNG thu thập và ghi nhận các thông tin sau:**

- **Dữ liệu cá nhân:** Tên người dùng, thông tin tài khoản, mật khẩu, email của người dùng cuối,...
- **Nội dung cấu hình (Profile):** Cấu trúc chi tiết của tệp tin `unattend.xml`, script `Post-setup.ps1`, hình nền (wallpaper) hoặc các tham số tinh chỉnh hệ thống (tweaks).
- **Thông tin bản quyền (License):** Nội dung chuỗi khóa `offlineLicense` hoặc các tham số nội bộ trong tệp `user-config.json` (ngoại trừ các trường định danh kỹ thuật được liệt kê bên dưới).
- **Dữ liệu trên thiết bị:** Tuyệt đối không quét hoặc sao chép bất kỳ tệp tin dữ liệu nào hiện có trên các phân vùng ổ cứng của máy trạm.

Hệ thống chỉ đồng bộ duy nhất các trường thông số kỹ thuật được liệt kê công khai dưới đây về máy chủ.
:::

## 1. Mục đích thu thập dữ liệu Telemetry

EASYDEPLOY vận hành theo mô hình ưu tiên kết nối trực tuyến (**Online-first**): tại mỗi phiên triển khai, ứng dụng khách (client) sẽ kết nối với máy chủ backend để **xác thực quyền sử dụng** (đảm bảo đúng định danh khách hàng, license hợp lệ, và còn định mức slots cài đặt), đồng thời **ghi nhận lịch sử triển khai (deployment)**. Đây là cơ sở dữ liệu đầu vào để hiển thị thông tin trên Web Dashboard, kích hoạt cảnh báo thiết bị USB bảo mật và gửi báo cáo tổng hợp hàng tuần qua Email. Cơ chế Telemetry **luôn được kích hoạt mặc định trên tất cả các gói dịch vụ** và không hỗ trợ tùy chọn tắt trên giao diện (nếu doanh nghiệp không đồng ý với chính sách thu thập dữ liệu kỹ thuật này, vui lòng ngừng sử dụng giải pháp).

## 2. Danh mục thông tin kỹ thuật được ghi nhận

Trong quá trình triển khai cài đặt thiết bị, ứng dụng khách sẽ đồng bộ lên máy chủ **2 nhóm dữ liệu sau**:

### 2.1. Nhóm thông tin xác thực bản quyền (Gửi khi bắt đầu tiến trình cài đặt)

| Trường thông tin | Định dạng ví dụ | Ý nghĩa sử dụng |
|--------|-------|---------|
| `business_id` | `CS-MSP-201` | Mã định danh duy nhất của doanh nghiệp trên hệ thống. |
| `installation_code` | `472816` | Mã số xác thực cài đặt được cấp phát. |
| `api_key` | `3f9a…` | Khóa API bảo mật dùng để xác thực quyền gọi tài nguyên từ máy chủ (**Hệ thống tuyệt đối không lưu trữ khóa này**). |

### 2.2. Nhóm thông số kỹ thuật thiết bị (Gửi trong và sau khi hoàn thành cài đặt)

| Trường thông tin | Định dạng ví dụ | Ý nghĩa sử dụng |
|--------|-------|---------|
| `machine_id` | `A1B2-…` | Mã định danh duy nhất của thiết bị (được tạo tự động bằng thuật toán) — phục vụ việc thống kê chuẩn xác, tránh đếm lặp thiết bị. |
| `model` | `Dell Latitude 5440` | Model máy của thiết bị. |
| `cpu` | `Intel Core i5-1335U` | Thông tin bộ xử lý (CPU). |
| `ram` | `16 GB` | Dung lượng bộ nhớ RAM. |
| `disk` | `512 GB SSD` | Thông số và dung lượng ổ đĩa cứng. |
| `usb_brand` | `SanDisk` | Thương hiệu của thiết bị USB boot được sử dụng. |
| `usb_serial` | `4C530001…` | Mã Serial Number vật lý của USB (phục vụ quản lý vòng đời thiết bị và kích hoạt thuật toán phát hiện sao chép). |
| `os_build` / `os_edition` / `os_language` / `os_version` | `26200.8873` / `Windows 11 Pro` / `en-us` / `25h2` | Các thông số chi tiết của hệ điều hành Windows sau khi cài đặt thành công. |
| `ip_address` | — | Địa chỉ IP công cộng của thiết bị tại thời điểm kết nối (chỉ sử dụng cho cơ chế giới hạn tần suất - Rate Limit nhằm phòng ngừa các cuộc tấn công lạm dụng hệ thống). |

:::note
Mã `machine_id` là một chuỗi ký tự ngẫu nhiên được hệ thống **tự động sinh ra và không liên kết với bất kỳ thông tin định danh cá nhân nào**. Địa chỉ `ip_address` chỉ phục vụ duy nhất cho cơ chế bảo vệ hệ thống (Rate Limit) và được ghi nhận dưới dạng nhật ký truy cập (access log) thông thường.
:::

## 3. Cơ chế lưu trữ dữ liệu

- **Hạ tầng lưu trữ:** Toàn bộ dữ liệu kỹ thuật công bố ở trên được lưu trữ an toàn trên **hạ tầng đám mây Cloudflare của CoreSystem**, được phân vùng độc lập theo định danh doanh nghiệp (`tenant`) của bạn.
- **Tính minh bạch:** Quản trị viên gói MSP Advanced có thể xem lại toàn bộ các dữ liệu này trực tiếp trên giao diện Dashboard (tại phân hệ Activations và USB Devices). Hệ thống cam kết không có bất kỳ dữ liệu ẩn nào khác ngoài danh mục đã công bố.
- **Bảo mật API:** Khóa API Key (`api_key`) **tuyệt đối không được lưu dưới dạng văn bản rõ (clear text)** trong cơ sở dữ liệu báo cáo — khóa chỉ được sử dụng làm tham số đối chiếu tức thời khi thực hiện xác thực cuộc gọi API.

## 4. Bảng đối chiếu phạm vi thu thập dữ liệu

| ✅ Có thu thập & ghi nhận | ❌ Cam kết TUYỆT ĐỐI KHÔNG thu thập |
|----------------|-------------------|
| Thông tin định danh tenant (mã khách hàng, mã cài đặt) | Tên người dùng, tài khoản, mật khẩu hoặc email của người dùng cuối |
| Cấu hình phần cứng thiết bị (Model, CPU, RAM, Disk) | Bất kỳ nội dung hoặc tệp tin nào lưu trữ trên ổ đĩa máy trạm |
| Thương hiệu và Serial Number vật lý của USB | Nội dung chi tiết của tệp tin `unattend.xml` hoặc script `Post-setup.ps1` (Profiles) |
| Thông số phiên bản OS cài đặt (Build, Edition, Language, Version) | Hình ảnh nền (Wallpaper), các Registry Tweaks hoặc cấu hình tùy biến riêng |
| Địa chỉ IP kết nối (chỉ dùng cho rate-limit) | Chuỗi khóa License Offline hoặc nội dung các cấu hình bảo mật khác trong `user-config.json` |
| Thông tin ghi nhận thời gian triển khai cài đặt | Thông tin định danh cá nhân của kỹ thuật viên hoặc người dùng thiết bị |

## 5. Giải đáp các thắc mắc thường gặp (FAQ)

**Tôi có thể vô hiệu hóa cơ chế Telemetry không?**
Giao diện người dùng không hỗ trợ tính năng tắt Telemetry. Đây là cơ chế cốt lõi để duy trì mô hình xác thực và báo cáo trực tuyến (online-first). Trong trường hợp doanh nghiệp không đồng ý chia sẻ các thông số kỹ thuật này, vui lòng ngưng sử dụng giải pháp EASYDEPLOY.

**CoreSystem có thể đọc hoặc sao chép các Profile của doanh nghiệp tôi không?**
Hoàn toàn không. Máy chủ backend chỉ tiếp nhận duy nhất các thông số kỹ thuật được mô tả ở bảng trên. **Không có bất kỳ tệp tin cấu hình nào trong Profile được gửi về server**. Toàn bộ tài nguyên Profile (bao gồm `unattend.xml` và `Post-setup.ps1`) chỉ được lưu trữ vật lý trên USB và thực thi cục bộ trên máy trạm cần cài đặt.

**Tôi có quyền truy cập và kiểm tra dữ liệu của mình không?**
Có. Quản trị viên gói MSP Advanced có thể trực tiếp giám sát dữ liệu của mình thông qua giao diện Web Dashboard (phân hệ Activations và USB Devices). Đối với các gói dịch vụ khác, vui lòng gửi yêu cầu về CoreSystem nếu có nhu cầu kết xuất (export) báo cáo dữ liệu triển khai.

**Dữ liệu triển khai của tôi có bị chia sẻ với bên thứ ba không?**
Tuyệt đối không. Toàn bộ dữ liệu kỹ thuật được lưu trữ an toàn trên hạ tầng đám mây Cloudflare do CoreSystem quản lý, và chỉ được sử dụng duy nhất cho mục đích vận hành giải pháp EASYDEPLOY (hiển thị dashboard, gửi cảnh báo bảo mật, xuất báo cáo) dành riêng cho chính doanh nghiệp của bạn.
