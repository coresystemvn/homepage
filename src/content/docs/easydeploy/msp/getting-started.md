---
title: 'Hướng dẫn triển khai ban đầu (Getting Started for Customers)'
---

Tài liệu này hướng dẫn chi tiết quy trình chuẩn bị từ thời điểm CoreSystem bàn giao thông tin bản quyền cho đến khi hoàn thành phiên triển khai đầu tiên bằng USB boot. Hướng dẫn áp dụng cho **quản trị viên của khách hàng** (bao gồm đối tác MSP gói Standard/Advanced hoặc doanh nghiệp SMB sử dụng dịch vụ).

## 1. Tiếp nhận thông tin bản quyền từ CoreSystem

Sau khi dịch vụ được kích hoạt thành công, CoreSystem sẽ bàn giao cho doanh nghiệp bộ **3 thông số xác thực** dưới đây:

| Thông số cấu hình | Định dạng ví dụ | Ý nghĩa sử dụng |
|-----------|-------|---------|
| `business_id` | `CS-MSP-201` | Mã định danh duy nhất của doanh nghiệp trên hệ thống |
| `installation_code` | `472816` | Mã số thiết lập cài đặt (gồm 6 chữ số) |
| `api_key` | `3f9a… (64 ký tự hex)` | Khóa bảo mật xác thực liên kết trực tiếp với tài khoản doanh nghiệp |

Vui lòng bảo mật và lưu trữ cẩn thận các thông số trên — đây là thông tin bắt buộc để hệ thống xác thực bản quyền và ghi nhận lịch sử triển khai cho mỗi thiết bị được cài đặt. Tham khảo thêm [License Tiers](/easydeploy/msp/license-tiers/) để nắm rõ các tính năng được hỗ trợ trong gói dịch vụ đang áp dụng.

## 2. Thiết lập cấu hình `user-config.json`

Truy cập vào thiết bị USB hoặc file ISO → Di chuyển đến thư mục `EASYDEPLOY\` → Mở và chỉnh sửa tệp tin cấu hình **`user-config.json`**:

```jsonc
{
  "business_id": "CS-MSP-201",        // ← Thay bằng Business ID được cấp
  "installation_code": "472816",      // ← Thay bằng Installation Code được cấp
  "api_key": "REPLACE-WITH-API-KEY-FROM-CORESYSTEM", // ← Thay bằng API Key được cấp
  "offlineLicense": "",               // Bỏ trống (dành cho chế độ xác thực trực tuyến)
  "enableF3Express": true,
  "deploy": {
    "operatingSystem": "Windows 11 25H2",
    "edition": "Pro",
    "activation": "Retail",
    "languageCode": "en-us",
    "diskNumber": 0,
    "profile": "1.Tweaks"
  }
}
```

:::danger
- **Cấu hình phương thức xác thực:** Chỉ điền giá trị cho **một trong hai** khóa: `api_key` (đối với chế độ xác thực trực tuyến - Online) **hoặc** `offlineLicense` (đối với chế độ xác thực ngoại tuyến - Offline). Không cấu hình đồng thời cả hai tham số. Phương thức xác thực áp dụng được quyết định bởi tham số `auth.enabled` cấu hình sẵn trong tệp tin hệ thống `system-config.json` của CoreSystem (tham khảo thêm [File cấu hình](/easydeploy/reference/configuration/)).
- **Độ chính xác thông tin:** Các trường `business_id`, `installation_code`, và `api_key` phải trùng khớp tuyệt đối với thông tin được CoreSystem cung cấp. Bất kỳ sai sót ký tự nào đều dẫn đến lỗi xác thực bản quyền và ngắt tiến trình cài đặt.
:::

## 3. Tiến hành triển khai thiết bị đầu tiên

Sau khi hoàn tất cấu hình tệp tin JSON, thiết bị USB boot đã sẵn sàng để hoạt động. Kết nối USB vào thiết bị → Khởi động boot vào WinPE → Lựa chọn luồng triển khai phù hợp. Để nắm rõ quy trình chi tiết (các bước boot WinPE, thao tác luồng cài đặt, giám sát tiến trình 11 bước và danh sách kiểm tra sau cài đặt), vui lòng tham khảo tài liệu [Quick Start](/easydeploy/getting-started/quick-start/).

## 4. Giám sát hệ thống sau triển khai

- **Đồng bộ Telemetry:** Sau mỗi phiên triển khai hoàn thành, hệ thống sẽ tự động đồng bộ các thông số kỹ thuật cơ bản của thiết bị, USB boot sử dụng và phiên bản hệ điều hành về máy chủ. **EASYDEPLOY cam kết chỉ thu thập dữ liệu kỹ thuật hệ thống, tuyệt đối không thu thập thông tin cá nhân của người dùng, cấu hình profile hay khóa bản quyền.** Chi tiết danh mục dữ liệu thu thập xem tại [Dữ liệu hệ thống ghi nhận (Telemetry)](/easydeploy/reference/telemetry/).
- **Đối với gói MSP Advanced:** Quản trị viên có thể truy cập Web Dashboard tại địa chỉ `https://msp.coresystem.vn` để theo dõi danh sách máy trạm đã cài, quản lý thiết bị USB và tiếp nhận các cảnh báo vận hành — tham khảo thêm [MSP Overview](/easydeploy/msp/overview/) và [USB Management](/easydeploy/msp/usb-management/).
- **Đối với gói MSP Standard (chưa hỗ trợ Dashboard):** CoreSystem sẽ tự động gửi báo cáo tổng hợp (digest email) hàng tuần ghi nhận danh sách các thiết bị đã được triển khai.

## 5. Danh mục hướng dẫn theo nhu cầu sử dụng

| Nhu cầu sử dụng | Hướng dẫn thực hiện |
|---|---|
| Sử dụng USB/ISO tiêu chuẩn sẵn có | Tham khảo tài liệu [Quick Start](/easydeploy/getting-started/quick-start/) |
| Là đối tác MSP, muốn tự xây dựng và đóng gói USB tùy biến thương hiệu | Xem hướng dẫn [BootBuilder](/easydeploy/msp/bootbuilder/) |
| Tùy biến thiết lập Windows sau khi cài đặt (Profiles) | Xem chi tiết tại [Profiles Overview](/easydeploy/profiles/profiles/) |
| Gia hạn thời gian sử dụng, bổ sung slots cài đặt hoặc nâng cấp gói dịch vụ | Liên hệ trực tiếp với bộ phận hỗ trợ của CoreSystem |

:::note
Mọi yêu cầu thay đổi thông số dịch vụ (bổ sung slots máy cài, gia hạn thời gian bản quyền, khôi phục API Key bị mất), vui lòng **liên hệ trực tiếp với CoreSystem**.
:::
