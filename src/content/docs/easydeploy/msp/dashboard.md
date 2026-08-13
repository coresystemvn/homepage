---
title: 'Web Dashboard — Hướng dẫn sử dụng các phân hệ'
---

Web Dashboard hoạt động tại địa chỉ **`https://msp.coresystem.vn`** (được bảo vệ bởi Cloudflare Access — vui lòng tham khảo [Overview](/easydeploy/msp/overview/) để biết thêm về quy trình đăng nhập và phân quyền). Phân hệ này dành riêng cho khách hàng sử dụng gói **MSP Advanced** — giao diện hiển thị sẽ được giới hạn nghiêm ngặt trong phạm vi **dữ liệu thuộc tenant của bạn**.

## Các phân hệ chức năng khả dụng

| Phân hệ | Tính năng chính |
|-------|----------|
| [Overview](#1-phân-hệ-overview-tổng-quan) | Thống kê tổng quan và danh sách thiết bị cài đặt gần đây |
| [Activations](#2-phân-hệ-activations-thiết-bị-đã-triển-khai) | Nhật ký chi tiết các thiết bị đã được triển khai thành công |
| [Licenses](#3-phân-hệ-licenses-quản-lý-bản-quyền) | Thông tin chi tiết về các gói bản quyền (License) |
| [USB Devices](#4-phân-hệ-usb-devices-quản-lý-thiết-bị-usb) | Quản lý thiết bị USB: phê duyệt (confirm), thu hồi (retire) hoặc khôi phục (restore) |
| [Alerts](#5-phân-hệ-alerts-quản-lý-cảnh-báo) | Quản lý các cảnh báo hệ thống: xác nhận (ack) hoặc phê duyệt thiết bị (confirm) |


## 1. Phân hệ Overview (Tổng quan)

Cung cấp các thẻ số liệu trực quan và biểu đồ thống kê **thuộc phạm vi tenant của bạn**:

| Thẻ thông tin (Card) | Ý nghĩa |
|------|---------|
| Deployments | Tổng số lượng thiết bị đã triển khai thành công. |
| Recent Activations | Bảng hiển thị danh sách 20 thiết bị được triển khai gần đây nhất. |

Tích hợp các biểu đồ trực quan (**Charts**): Tỷ lệ phân bố các phiên bản hệ điều hành (OS distribution) và xu hướng triển khai theo thời gian (deployment trend) — dữ liệu được tổng hợp tự động từ thông tin hệ điều hành (`os_*`) của thiết bị.

## 2. Phân hệ Activations (Thiết bị đã triển khai)

Hiển thị bảng nhật ký chi tiết của từng thiết bị đã cài đặt, bao gồm các trường thông tin: STT (#), Business ID, Machine ID, Model, CPU, RAM, Disk (Ổ đĩa), USB Brand (Thương hiệu USB), USB Serial (Số Serial USB) và Date (Thời gian thực hiện).

- **Cơ chế phân trang (Pagination):** Hỗ trợ hiển thị 50 bản ghi/trang, đi kèm các nút chuyển trang Previous/Next và thông tin hiển thị tổng số bản ghi.
- **Phạm vi dữ liệu:** Chỉ hiển thị danh sách thiết bị thuộc tenant của bạn.
- **Đồng bộ thông tin OS:** Các dữ liệu kỹ thuật của hệ điều hành (`os_*` gồm OS build/edition/language/version) được đồng bộ từ client về máy chủ — làm cơ sở dữ liệu đầu vào cho các biểu đồ phân tích tại trang Overview.

## 3. Phân hệ Licenses (Quản lý bản quyền)

Bảng thông tin chi tiết: ID, Business Code, Business Name, Max (Số lượng slot tối đa), Used (Số lượng slot đã sử dụng), Expires (Ngày hết hạn), Status (Trạng thái hoạt động: Active/Inactive).

- **Tính năng giám sát:** Giúp quản trị viên theo dõi định mức sử dụng bản quyền (`Used`/`Max`) và thời gian hiệu lực còn lại (`Expires`).
- **Yêu cầu điều chỉnh:** Để cập nhật thông số license (bổ sung slot hoặc gia hạn bản quyền), vui lòng **liên hệ với CoreSystem**.

## 4. Phân hệ USB Devices (Quản lý thiết bị USB)

Quản lý và giám sát danh sách thiết bị USB boot dựa theo mã Serial Number (**`usb_serial`**), hỗ trợ các thông tin:

- Thương hiệu USB (USB brand), tổng số thiết bị đã triển khai (distinct machines), thời gian hoạt động cuối cùng, nhãn **NEW** (dành cho USB mới chưa phê duyệt), và các cảnh báo nổi bật (highlight) khi phát hiện dấu hiệu nghi ngờ sao chép (clone).
- **Các thao tác quản trị:**
  - **Confirm:** Phê duyệt thiết bị và đưa vào danh sách trắng vĩnh viễn (Allowlist).
  - **Retire:** Thu hồi quyền và đánh dấu thiết bị đã hỏng/ngừng sử dụng.
  - **Restore:** Khôi phục trạng thái USB về dạng mới (`new`) và kích hoạt lại thời gian ân hạn (grace window).

Tham khảo chi tiết quy trình quản lý vòng đời USB tại [USB Management](/easydeploy/msp/usb-management/).

## 5. Phân hệ Alerts (Quản lý cảnh báo)

Hiển thị danh sách các cảnh báo bảo mật phát sinh: `usb_burst` (cảnh báo clone burst) và `usb_retired_reused` (sử dụng lại USB đã bị thu hồi).

| Loại cảnh báo | Mức độ nghiêm trọng (Severity) | Ý nghĩa kỹ thuật |
|------|----------|---------|
| `usb_burst` (≥3 serial mới/24h) | Warning | Phát hiện dấu hiệu sao chép USB hàng loạt |
| `usb_burst` (≥8 serial mới/24h) | **Critical** | Phát hiện sao chép trái phép diện rộng — hiển thị băng rôn đỏ cảnh báo (Red Banner) |
| `usb_retired_reused` | Warning | Phát hiện thiết bị USB đã bị thu hồi (Retire) nhưng cố tình sử dụng lại |

**Các thao tác xử lý cảnh báo:**
- **Ack (Acknowledge):** Xác nhận và đóng cảnh báo.
- **Confirm Serial:** Phê duyệt thiết bị và đưa vào danh sách trắng (Allowlist) nếu xác định đây là USB hợp lệ của đơn vị.

Chi tiết quy trình xử lý vui lòng tham khảo [USB Management](/easydeploy/msp/usb-management/).

:::note
Giao diện không thiết kế nút Xóa (Delete) cho USB — hai thao tác **Retire** (Thu hồi) và **Confirm** (Phê duyệt) đã đáp ứng hoàn chỉnh tất cả các kịch bản vận hành (bao gồm cả trường hợp thiết bị hư hỏng hoặc nghi ngờ bị clone).
:::

## Cơ chế thông báo qua Email

| Loại thông báo | Tần suất gửi | Người nhận |
|------|----------|---------|
| Weekly Digest (Báo cáo tuần) | Thứ Hai, lúc 08:00 (giờ Việt Nam) | Địa chỉ email đăng ký trên hệ thống |
| USB Clone Burst Alert | Tức thời theo sự kiện (khi phát hiện số lượng Serial Number lạ vượt ngưỡng quy định) | Địa chỉ email đăng ký trên hệ thống |

:::note
Ngoài báo cáo tuần (digest) và cảnh báo clone (burst alert), một số thông báo sự kiện cài đặt riêng lẻ hiện đang được tạm tắt trên hệ thống máy chủ của CoreSystem để tối ưu hóa — hệ thống sẽ thông báo chi tiết khi các tính năng này được kích hoạt lại.
:::
