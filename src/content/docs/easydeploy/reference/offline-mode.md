---
title: 'Chế độ ngoại tuyến và lai (Offline / Hybrid Mode)'
---

Để phục vụ các phân khúc khách hàng hoặc môi trường mạng cô lập **không có kết nối Internet** (hoặc hạn chế tối đa việc phụ thuộc vào máy chủ Cloud), EASYDEPLOY hỗ trợ vận hành ngoại tuyến (Offline) trên hai khía cạnh độc lập: **Xác thực bản quyền (License)** và **Nguồn cài đặt hệ điều hành (OS Image)**.

:::note
Nguồn OS ngoại tuyến/lai (các tệp tin `.esd`) có thể được tải về trực tiếp từ **<https://esd.coresystem.vn>** — do CoreSystem cung cấp chính thức, đảm bảo trùng khớp hoàn toàn với Catalog để bạn chỉ cần sao chép vào USB là có thể sử dụng ngay.
:::

## 1. Cơ chế xác thực bản quyền ngoại tuyến (Offline License Verification)

Trong môi trường mạng nội bộ, thay vì sử dụng tham số `api_key` để xác thực trực tuyến, quản trị viên sẽ khai báo khóa **`offlineLicense`** trong tệp tin `user-config.json`:

```jsonc
{
  "business_id": "",
  "installation_code": "",
  "api_key": "",
  "offlineLicense": "ED.<payload>.<signature>",
  "enableF3Express": false
}
```

- **Định dạng khóa bản quyền:** Khóa license ngoại tuyến có định dạng chuỗi ký tự chuẩn `ED.<payload>.<signature>` (độ dài khoảng 200 ký tự), được ký số bảo mật bằng thuật toán **ECDSA P-256** (tiêu chuẩn IEEE P1363, chữ ký số độ dài 64 bytes).
- **Thông tin chứa trong License:** Khóa mã hóa chứa thông tin về **định danh doanh nghiệp (company) và thời hạn sử dụng bản quyền (UTC)**; các thông tin này sẽ được giải mã và hiển thị chi tiết trên giao diện hộp thoại About.
- **Điều kiện kích hoạt:** Bắt buộc phải cấu hình thiết lập `"auth": { "enabled": false }` trong tệp tin hệ thống `system-config.json` (phiên bản offline). Khi cờ này tắt, engine sẽ **bỏ qua bước xác thực trực tuyến (bypass online auth)** và chuyển sang kiểm tra tính hợp lệ của chữ ký số ngoại tuyến.

:::danger
Các đối tác IT/MSP **không thể tự khởi tạo hoặc giả lập** khóa bản quyền ngoại tuyến này. Khi phát sinh nhu cầu triển khai ngoại tuyến, vui lòng liên hệ trực tiếp với CoreSystem để đăng ký khóa bản quyền phù hợp với nhu cầu sử dụng (định mức số lượng slots cài đặt, thời hạn hiệu lực), sau đó thiết lập chuỗi khóa nhận được vào trường `user-config.json → offlineLicense`.
:::

### 1.1. Các thông báo lỗi bản quyền thường gặp

| Thông báo lỗi hiển thị | Ý nghĩa kỹ thuật |
|-----------|---------|
| `License is not valid.` | Khóa bản quyền không hợp lệ, bị nhập thiếu ký tự hoặc chữ ký số bị sai lệch. |
| `Please check your BIOS time settings.` | Hệ thống phát hiện đồng hồ thời gian thực (RTC) trong BIOS của thiết bị quá cũ so với thời gian hiệu lực của bản quyền. |
| `Please contact CoreSystem to renew your license.` | Thời hạn bản quyền đã hết và vượt quá khoảng thời gian ân hạn cho phép. |
| Cảnh báo `NearExpiry` | Bản quyền chuẩn bị hết hạn (còn dưới 14 ngày) — hệ thống hiển thị hộp thoại cảnh báo trước khi tiến hành cài đặt. |

## 2. Quản lý nguồn cài đặt hệ điều hành ngoại tuyến (Offline OS Source)

EASYDEPLOY áp dụng nguyên tắc **ưu tiên nguồn cục bộ trước (Offline-first)** khi quét tìm file cài đặt Windows Image (áp dụng cho cả phiên bản online). Tệp tin định dạng `.esd` được đặt trong thư mục `EASYDEPLOY\OS\` trên USB và hỗ trợ 2 cấu trúc tổ chức thư mục:

```
[ký_tự_ổ]:\EASYDEPLOY\OS\<tên_tệp_tin>.esd               → Cấu trúc một tệp tin đơn lẻ
[ký_tự_ổ]:\EASYDEPLOY\OS\<tên_thư_mục>\<tên_tệp_tin>.esd   → Tổ chức phân loại theo các thư mục con (tùy chọn)
```

- **Độ chính xác định danh:** Tên tệp tin `.esd` phải **trùng khớp tuyệt đối** với thuộc tính `fileName` được khai báo trong Catalog (đảm bảo trùng khớp hoàn toàn mã băm SHA-256).
- **Xác thực thành công:** Nếu tệp tin cục bộ hợp lệ, tiến trình cài đặt sẽ diễn ra hoàn toàn ngoại tuyến và **không yêu cầu kết nối mạng**.
- **Cơ chế dự phòng:** Trong trường hợp không tìm thấy file hoặc mã băm SHA-256 bị sai lệch, engine sẽ tự động chuyển sang luồng tải trực tuyến từ CDN Cloud. Nếu cả hai phương thức đều thất bại, hệ thống sẽ **dừng tiến trình và báo lỗi kỹ thuật**.
- **Cấu hình lai (Hybrid Mode):** Thư mục `OS` để trống vẫn được coi là hợp lệ — EASYDEPLOY sẽ tự động tải file cài đặt thông qua kết nối internet.

:::tip
Để tải nguyên liệu cài đặt, vui lòng truy cập **<https://esd.coresystem.vn>** — lựa chọn đúng phiên bản Build, Edition và mã ngôn ngữ (Language) cần thiết, sau đó di chuyển tệp tin tải về vào thư mục `EASYDEPLOY\OS\` trên USB.
:::

:::danger
**Hạn chế lưu trữ thư mục `EASYDEPLOY\OS\` trên đĩa DVD vật lý hoặc file ảnh ISO:** Định dạng hệ thống file tiêu chuẩn của ISO (như chuẩn Joliet) có thể tự động cắt ngắn các tên tệp tin vượt quá 64 ký tự khi được gắn (mount) vào môi trường WinPE. Điều này dẫn đến việc tên file thực tế không khớp với định nghĩa `fileName` trong Catalog, khiến engine bỏ qua file cục bộ và cố gắng kết nối mạng để tải trực tuyến.
:::

## 3. Tổng hợp cấu hình vận hành ngoại tuyến hoàn toàn (Offline Mode)

| Tệp tin cấu hình | Thiết lập thay đổi |
|------|----------|
| `system-config.json` | Thiết lập `"auth": { "enabled": false }` (được cấu hình mặc định trong gói `EasyDeploy.zip` bản offline do CoreSystem phát hành). |
| `user-config.json` | Khai báo chuỗi khóa bản quyền ngoại tuyến tại trường `offlineLicense`. Các trường `api_key`, `business_id`, và `installation_code` để trống hoặc loại bỏ. |
| USB `EASYDEPLOY\OS\` | Sao chép sẵn tệp tin `.esd` hợp lệ (tải từ esd.coresystem.vn, đảm bảo khớp hoàn toàn tên `fileName` trong Catalog). |

:::tip
Lưu ý: Mặc dù tiến trình triển khai hệ điều hành không yêu cầu kết nối mạng, nếu máy trạm trỏ tới các tác vụ cần internet sau khi cài đặt, script cấu hình `post-setup.ps1` vẫn sẽ vận hành bình thường. Các bước tải tài nguyên trực tuyến trong script sẽ tự động được bỏ qua một cách an sau nếu phát hiện trạng thái kết nối mạng trống (`$HasInternet = $false`).
:::
