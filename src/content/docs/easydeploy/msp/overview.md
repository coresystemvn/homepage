---
title: 'MSP — Tổng quan dịch vụ'
---

Tài liệu này cung cấp thông tin tổng quan dành cho khách hàng sử dụng dịch vụ EASYDEPLOY: giúp xác định gói bản quyền đang sử dụng, phạm vi quyền hạn và — đối với gói **MSP Advanced** — cách thức vận hành Web Dashboard (`https://msp.coresystem.vn`) để theo dõi các thiết bị đã triển khai, quản lý USB boot và xử lý các cảnh báo hệ thống.

:::note
Web Dashboard là **tính năng dành riêng cho gói MSP Advanced**. Đối với các gói bản quyền khác, vui lòng tham khảo [License Tiers](/easydeploy/msp/license-tiers/) để biết chi tiết phân quyền.
:::

## Các tính năng chính của Dashboard

Dashboard cung cấp cho quản trị viên các công cụ quản lý sau:

| Khả năng | Mô tả |
|----------|-------|
| Theo dõi tiến trình Deployment | Hiển thị chi tiết danh sách thiết bị đã cài đặt: model máy, CPU, dung lượng RAM, cấu trúc ổ đĩa, USB boot sử dụng, cùng phiên bản OS build/edition/language/version. |
| Quản lý thiết bị USB | Giám sát danh sách USB theo mã Serial Number, phê duyệt (confirm/allowlist), thu hồi quyền (retire) hoặc khôi phục quyền truy cập (restore). |
| Xử lý cảnh báo bảo mật | Phát hiện và xử lý các cảnh báo về USB lạ (cảnh báo clone burst), USB đã bị thu hồi (retired) nhưng cố tình sử dụng lại — hỗ trợ các thao tác xác nhận (ack) hoặc phê duyệt (confirm). |

## Quy trình đăng nhập

1. Truy cập vào địa chỉ **`https://msp.coresystem.vn`**.
2. Hệ thống xác thực Cloudflare Access sẽ hiển thị giao diện đăng nhập → Nhập địa chỉ **email** đăng ký → Nhận mã xác minh (OTP) gửi qua email.
3. Nhập mã OTP chính xác để đăng nhập thành công → Giao diện Dashboard sẽ hiển thị theo phân quyền tài khoản của bạn.

:::tip
Để đăng xuất khỏi hệ thống: Truy cập địa chỉ `https://coresystemvn.cloudflareaccess.com/cdn-cgi/access/logout`. Phiên làm việc (Session) sẽ tự động hết hạn (timeout) sau 30 phút không hoạt động.
:::

## Vai trò tài khoản và Phạm vi dữ liệu

:::danger
**Web Dashboard chỉ khả dụng với gói dịch vụ MSP Advanced.** Về mặt kỹ thuật, mọi gói dịch vụ (tier) đều tự động gửi dữ liệu triển khai về hệ thống máy chủ (telemetry) — tuy nhiên, quyền hạn truy cập giao diện Dashboard được phân định cụ thể theo gói dịch vụ:

| Gói | Đồng bộ dữ liệu Telemetry | Quyền truy cập Dashboard |
|-----|:-------------------------:|:-------------------------:|
| **MSP Advanced** | ✅ Có | ✅ **Có** |
| MSP Standard | ✅ Có | ❌ Không |
| Free (SMB/MBB) | ✅ Có | ❌ Không |
:::

Như vậy, các gói Free (SMB/MBB) và MSP Standard mặc dù có dữ liệu telemetry đồng bộ về hệ thống nhưng sẽ không có quyền truy cập và sử dụng giao diện Dashboard. Với tài khoản thuộc gói MSP Advanced, bạn sẽ đăng nhập bằng email đã đăng ký với CoreSystem và **chỉ có quyền xem/quản lý dữ liệu thuộc phạm vi tenant của mình**:

| Vai trò | Bạn thấy |
|---------|----------|
| **MSP** | Quyền xem và quản lý các phân hệ Overview, Activations, Licenses, USB, Alerts — giới hạn trong dữ liệu thuộc tenant của mình. |
| **MBB** | Quyền xem và quản lý tương đương (Overview, Activations, Licenses, USB, Alerts) — giới hạn trong dữ liệu thuộc tenant của mình. |

:::note
Cả hai vai trò tài khoản trên đều chỉ được phép tiếp cận **dữ liệu thuộc tenant của riêng mình** — hoàn toàn không thể xem thông tin của các khách hàng hoặc tenant khác. Các tác vụ quản trị hệ thống cấp cao (như quản lý danh sách khách hàng, cấp phát API Key, cấu hình thông số license) thuộc thẩm quyền của **CoreSystem Administrator** và sẽ không hiển thị trên giao diện của bạn.
:::

:::danger
**Cơ chế thu thập dữ liệu kỹ thuật (Telemetry) được thiết lập kích hoạt mặc định trên tất cả các gói dịch vụ (không hỗ trợ tắt qua giao diện).** Mỗi khi hoàn thành cài đặt một thiết bị, thông số triển khai sẽ được đồng bộ lên máy chủ — đây là nguồn dữ liệu đầu vào cho Dashboard và phục vụ cho mô hình xác thực trực tuyến (online-first). **EASYDEPLOY cam kết không thu thập bất kỳ thông tin cá nhân của người dùng, nội dung profile tùy biến hoặc các thông tin nhạy cảm khác.** Chi tiết các thông số được thu thập vui lòng tham khảo [Dữ liệu hệ thống ghi nhận (Telemetry)](/easydeploy/reference/telemetry/).
:::

## Tài liệu hướng dẫn liên quan

| Trang | Nội dung chi tiết |
|-------|----------|
| [Bắt đầu với EASYDEPLOY](/easydeploy/msp/getting-started/) | Các bước chuẩn bị: Nhận thông tin cấu hình → Thiết lập `user-config.json` → Triển khai thiết bị đầu tiên |
| [License Tiers](/easydeploy/msp/license-tiers/) | Chi tiết phân biệt tính năng các gói Free, MSP Standard và MSP Advanced |
| [Dashboard](/easydeploy/msp/dashboard/) | Hướng dẫn chi tiết giao diện và tính năng của từng trang trên Dashboard |
| [USB Management](/easydeploy/msp/usb-management/) | Quy trình quản lý vòng đời thiết bị USB: Thiết lập grace window, confirm, retire và xử lý burst alert |
| [BootBuilder (Whitebox)](/easydeploy/msp/bootbuilder/) | Hướng dẫn sử dụng công cụ BootBuilder để tự xây dựng ISO/USB tùy biến thương hiệu |
