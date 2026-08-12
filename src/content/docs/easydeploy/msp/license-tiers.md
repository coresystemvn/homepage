---
title: 'Các gói dịch vụ và Phân quyền (License Tiers)'
---

EASYDEPLOY cung cấp 3 gói dịch vụ (License Tiers) đáp ứng các nhu cầu triển khai khác nhau. Tài liệu này giúp quản trị viên xác định chính xác gói dịch vụ đang áp dụng cùng các đặc quyền đi kèm.

| Tier | Loại Tenant (Tenant Type) | Quyền truy cập Dashboard | Cơ chế kiểm soát (Enforce) | Quyền tùy biến Whitebox |
|------|-------------|------------------|---------|----------|
| **Free** | SMB (`mbb`) | ❌ Không | Số lượng thiết bị giới hạn, thời gian hiệu lực ngắn, chính sách kiểm soát nghiêm ngặt | ❌ Không |
| **MSP Standard** | `msp` | ❌ Không | Số lượng thiết bị lớn (theo hợp đồng), thời hạn sử dụng linh hoạt | ✅ **Có** |
| **MSP Advanced** | `msp` | ✅ **Có** | MSP Standard bổ sung các tính năng nâng cao (tự quản lý bản quyền, đặt lại API Key) | ✅ **Có** |

## 1. Gói Free (Dành cho SMB/MBB)

- **Đối tượng áp dụng:** Doanh nghiệp quy mô nhỏ (SMB) tự triển khai và cấu hình thiết bị nội bộ.
- **Hạn chế:** Không được cấp quyền truy cập Web Dashboard. Chính sách kiểm soát bản quyền áp dụng nghiêmngặt (giới hạn số lượng cài đặt thấp, thời hạn hiệu lực ngắn).
- **Đặc quyền Whitebox:** Không hỗ trợ tùy biến thương hiệu — bắt buộc sử dụng USB/ISO tiêu chuẩn được phân phối bởi CoreSystem.

## 2. Gói MSP Standard

- **Đối tượng áp dụng:** Các nhà cung cấp dịch vụ quản trị (MSP) chuyên thực hiện cài đặt và triển khai thiết bị cho khách hàng.
- **Đặc quyền Whitebox:** Được phép tự xây dựng và đóng gói USB/ISO tùy biến thương hiệu riêng (tham khảo thêm [BootBuilder](/easydeploy/msp/bootbuilder/)).
- **Hạn chế:** Chưa hỗ trợ quyền truy cập Web Dashboard. Hệ thống sẽ tự động gửi báo cáo tổng hợp (digest email) hàng tuần ghi nhận tình trạng các thiết bị đã cài đặt.
- **Chính sách bản quyền:** Số lượng máy triển khai (slots) lớn dựa theo hợp đồng ký kết, thời hạn hiệu lực linh hoạt.

## 3. Gói MSP Advanced

- Thừa hưởng toàn bộ quyền lợi của gói MSP Standard, đồng thời **bổ sung thêm các tính năng cao cấp** sau:

| Tính năng | Mô tả |
|-----------|-------|
| **Giao diện Web Dashboard** | Quyền truy cập hệ thống `https://msp.coresystem.vn` để giám sát thời gian thực các phiên triển khai (deployment), quản lý thiết bị USB và các cảnh báo hệ thống. |
| **Quản lý thiết bị USB** | Quản lý danh sách USB theo mã định danh `usb_serial`, tự động gắn nhãn (badge) NEW cho thiết bị mới, cảnh báo các USB nghi ngờ bị sao chép (clone) và thực thi các lệnh phê duyệt (confirm), thu hồi (retire) hoặc khôi phục (restore). |
| **Cảnh báo sao chép USB (Clone Alert)** | Tự động phát hiện và gửi cảnh báo qua Email khi xuất hiện mã Serial Number của USB lệch so với baseline đã đăng ký. |
| **Thời gian ân hạn (Grace Window)** | Cho phép thiết bị USB mới sử dụng thử nghiệm tự do trong vòng 7 ngày trước khi hệ thống yêu cầu phê duyệt chính thức để tránh bị khóa (block). |
| **Trang quản lý cảnh báo (Alerts)** | Theo dõi, xác nhận (ack) các cảnh báo hệ thống hoặc phê duyệt trực tiếp các mã Serial Number. |
| **Báo cáo thống kê** | Biểu đồ phân tích trực quan về tỷ lệ các phiên bản hệ điều hành (OS distribution) và xu hướng triển khai theo thời gian (deployment trend). |

## Bảng so sánh quyền lợi giữa các gói dịch vụ

| Quyền hạn / Tính năng | Free | MSP Standard | MSP Advanced |
|-------|:----:|:------------:|:------------:|
| Sử dụng USB/ISO tiêu chuẩn sẵn có | ✅ | ✅ | ✅ |
| Nhận báo cáo tổng hợp qua Email (Digest Weekly) | ❌ | ✅ | ✅ |
| Xây dựng USB/ISO tùy biến thương hiệu (Whitebox) | ❌ | ✅ | ✅ |
| Tùy biến ứng dụng gốc (App Root), logo hiển thị và hình nền | — | ✅ (media options) | ✅ (media options) |
| Truy cập Dashboard & Nhận cảnh báo sao chép (Clone Alert) | ❌ | ❌ | ✅ |
| Tự chủ quản lý bản quyền (Bật/tắt hoặc Reset API Key) | ❌ | ❌ | ✅ |

:::danger
**Cơ chế thu thập dữ liệu kỹ thuật (Telemetry) luôn được kích hoạt mặc định trên tất cả các gói dịch vụ** (không hỗ trợ tắt qua giao diện). Mỗi khi thiết bị hoàn thành cài đặt, thông tin triển khai sẽ được đồng bộ lên máy chủ để làm dữ liệu đầu vào cho Dashboard và phục vụ xác thực (online-first). EASYDEPLOY cam kết hệ thống **tuyệt đối không** thu thập dữ liệu cá nhân của người dùng, nội dung profile tùy biến hoặc thông tin license. Xem thêm chi tiết tại [Dữ liệu hệ thống ghi nhận (Telemetry)](/easydeploy/reference/telemetry/).
:::

## Quy trình thay đổi gói dịch vụ hoặc gia hạn bản quyền

Để thực hiện các thay đổi liên quan đến gói dịch vụ (ví dụ: nâng cấp gói, bổ sung số lượng máy cài đặt, gia hạn thời gian sử dụng hoặc cấp lại API Key), quý khách vui lòng **liên hệ trực tiếp với CoreSystem**. Các tác vụ cấp phép nâng cao này được quản lý tập trung từ phía hệ thống CoreSystem và không hỗ trợ tự thao tác trực tiếp trên giao diện Dashboard của người dùng.
