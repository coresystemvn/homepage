---
title: 'Chế độ ngoại tuyến và lai (Offline / Hybrid Mode)'
---

EASYDEPLOY hỗ trợ vận hành ngoại tuyến trên hai khía cạnh: **Xác thực bản quyền** và **Nguồn cài đặt OS**.
Dành cho môi trường mạng cô lập hoặc hạn chế kết nối Internet.

:::note
Tra cứu link tải `.esd` tại **ESD Catalog (<https://esd.coresystem.vn>)** — danh mục tra cứu link tải từ kênh phân phối chính thức của Microsoft, kèm SHA-256 để xác minh. Tệp khớp Catalog — sao chép vào USB là dùng ngay.
:::

:::note
Catalog nhúng của EasyDeploy có bản build cho 25H2 là 26200.8873. Trường hợp 100% offline, vui lòng tải đúng phiên bản esd để đảm bảo quá trình cài đặt diễn ra đúng hoạch định.
:::

## 1. Cơ chế xác thực bản quyền ngoại tuyến (Offline License Verification)

> **Bạn nhận file `.lic` từ CoreSystem, đặt vào `EASYDEPLOY\` trên USB:**

```
[USB]:\EASYDEPLOY\<tên_file>.lic
```

- **Nội dung file `*.lic`:** do CoreSystem cấp, ký số (không thể tự tạo/sửa). Gắn kèm tên doanh nghiệp, thời hạn, USB-SN được phép và gói dịch vụ.
- **Bind USB:** License gắn ≥1 USB-SN. Nếu USB không trong danh sách, hệ thống báo *"License is bound to a different USB drive."* — ngăn sao chép license.
  Chi tiết tại [Ghi chú về USB-SN](/easydeploy/msp/license-tiers/#ghi-chú-về-usb-sn-áp-dụng-cho-advanced).
- **License Tier:** Gói dịch vụ (`free`/`advanced`) ghi trong license (chỉ Advanced có `*.lic`; Free không cần). Xem [License Tiers](/easydeploy/msp/license-tiers/).
- **Kích hoạt:** Không cần cấu hình thêm. Đặt `.lic` lên USB — hệ thống tự xác thực, không cần mạng.

:::caution
Khóa bản quyền do CoreSystem cấp và ký số tập trung — bạn không thể tự tạo.
Khi cần gia hạn hoặc đổi USB, liên hệ CoreSystem.
:::

### 1.1. Các thông báo lỗi bản quyền thường gặp

| Thông báo lỗi | Ý nghĩa |
|-----------|---------|
| `License is not valid.` | Bản quyền không hợp lệ — thiếu ký tự hoặc chữ ký số sai. |
| `License is bound to a different USB drive.` | USB không nằm trong danh sách `Usb` đã bind. |
| `Please check your BIOS time settings.` | Đồng hồ RTC trong BIOS quá cũ so với thời hạn. |
| `Please contact CoreSystem to renew your license.` | Bản quyền hết hạn và đã vượt quá khoảng ân hạn. |
| Cảnh báo `NearExpiry` | Bản quyền sắp hết (còn dưới 14 ngày) — cảnh báo trước khi cài đặt. |

## 2. Quản lý nguồn cài đặt hệ điều hành ngoại tuyến (Offline OS Source)

EASYDEPLOY áp dụng nguyên tắc **Offline-first** — ưu tiên nguồn cục bộ khi quét file Windows Image.
Áp dụng cả phiên bản online. Tệp `.esd` đặt trong `EASYDEPLOY\` trên USB, hỗ trợ 2 cấu trúc:

```
[ký_tự_ổ]:\EASYDEPLOY\OS\<tên_tệp_tin>.esd               → Một tệp đơn lẻ
[ký_tự_ổ]:\EASYDEPLOY\OS\<tên_thư_mục>\<tên_tệp_tin>.esd   → Phân loại theo thư mục con
```

- **Định danh:** Tên `.esd` phải trùng khớp `fileName` trong Catalog, kèm mã băm SHA-256.
- **Thành công:** Tệp cục bộ hợp lệ → cài đặt ngoại tuyến hoàn toàn, không cần mạng.
- **Dự phòng:** Không tìm file hoặc SHA-256 sai → engine chuyển CDN Cloud. Cả hai thất bại → hệ thống dừng và báo lỗi.
- **Hybrid Mode:** Thư mục `OS` để trống vẫn hợp lệ — EASYDEPLOY tải file qua Internet tự động.

:::tip
Truy cập **<https://esd.coresystem.vn>** để tra cứu link tải tệp cài đặt — chọn Build, Edition và Language phù hợp.
Đặt vào `EASYDEPLOY\OS\` trên USB.
:::

:::danger
**Không lưu `EASYDEPLOY\OS\` trên DVD hoặc ISO.** Định dạng Joliet cắt ngắn tên tệp vượt 64 ký tự khi mount trong WinPE.
Tên file sẽ không khớp `fileName` trong Catalog — engine bỏ qua file cục bộ và cố kết nối mạng.
:::

## 3. Tổng hợp cấu hình vận hành ngoại tuyến hoàn toàn (Offline Mode)

| Tệp tin cấu hình | Thiết lập |
|------|----------|
| `system-config.json` | Không cần thiết lập xác thực. `catalog.cloudCatalog:false` → dùng catalog nhúng (100% offline, mọi gói); `url` tự host là BYOC (Advanced). |
| USB `EASYDEPLOY\` | Đặt file `*.lic` do CoreSystem cấp (không cần khai báo flag trong JSON). |
| USB `EASYDEPLOY\OS\` | Sao chép tệp `.esd` hợp lệ (tải từ esd.coresystem.vn, khớp `fileName` trong Catalog). |

:::tip
Cài OS không cần mạng. `post-setup.ps1` vẫn chạy bình thường nếu máy trạm cần internet.
Các bước tải tài nguyên tự động bỏ qua khi `$HasInternet = $false`.
:::