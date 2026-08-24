---
title: 'BootBuilder (Whitebox) — Tự dựng USB/ISO tùy biến'
---

**EasyDeploy.BootBuilder** là ứng dụng Windows dành cho máy trạm, giúp bạn xây dựng bộ phương tiện khởi động **USB/ISO WinPE** tùy biến. Công cụ chuẩn bị tài nguyên trong thư mục `.cache`, tích hợp driver phần cứng, và xuất file ISO boot để ghi lên USB.

:::note
**Quyền sử dụng:** Thay đổi giao diện thương hiệu (Whitebox) qua BootBuilder là **đặc quyền dành riêng cho đối tác MSP Standard và MSP Advanced**. Chi tiết xem [License Tiers](/easydeploy/msp/license-tiers/).
:::

:::caution
**Cảnh báo Antivirus:** Tệp tin `EasyDeploy.BootBuilder.exe` chưa có chữ ký số. Một số phần mềm Antivirus có thể nhận diện nhầm và chặn hoặc cảnh báo khi khởi chạy. Bạn cần thêm tệp tin vào danh sách loại trừ trên máy trạm. Đây là hiện tượng phổ biến với tệp thực thi chưa ký số. Hãy tải tệp từ liên kết chính thức do CoreSystem cung cấp.
:::

## 1. Các bước chuẩn bị trước khi vận hành

1. Tải về gói công cụ gồm `EasyDeploy.BootBuilder.exe` và tệp hướng dẫn `links.md` (do CoreSystem cấp phát). Khởi chạy bằng quyền quản trị (**Run as administrator**).
2. Lần chạy đầu tiên, ứng dụng **tự động tạo** thư mục `.cache` cùng cấp với file thực thi. Đồng thời khởi tạo mẫu cấu hình (`user-config.json`) và 2 profile mặc định. Bạn chỉ cần di chuyển file nguyên liệu vào đúng thư mục trong `.cache` (xem bảng dưới) — **tuyệt đối không xóa `.cache`**.
3. Đường dẫn `.cache` mặc định cùng cấp với `.exe`. Bạn có thể thay đổi bằng biến môi trường `EASYDEPLOY_CACHE`.

### Danh mục tài nguyên trong thư mục `.cache`

| Thư mục | Nội dung | Bắt buộc |
|----------|----------|:--------:|
| `esd\` | Tệp tin ESD cài đặt Windows 11 (định dạng `*.esd`) | ✅ |
| `apps\` | Tệp tin thực thi `EasyDeploy.exe` và file cấu hình `system-config.json` (giải nén từ `EasyDeploy.zip`) | ✅ |
| `downloads\` | Driver phần cứng theo nhà sản xuất — tổ chức theo: `dell\`, `hp\`, `intel\`, `intel-wifi\`, `lenovo\`, `others\` | ⭕ |
| `wallpaper\` | Hình ảnh `wallpaper.jpg` hoặc `winpe.jpg` để tùy biến nền WinPE | ⭕ |
| `usb\` | Payload USB: thư mục `EASYDEPLOY\` (cấu hình, profiles) + `Softwares\` (công cụ cứu hộ Portable) | ⭕ |

:::caution
Công cụ hoạt động hoàn toàn ngoại tuyến, **không tự động tải tài nguyên từ internet**. Bạn cần tải trước và sắp xếp vào đúng thư mục. Thiếu file bắt buộc → giao diện hiển thị **cảnh báo đỏ**; mở `links.md` để lấy liên kết tải. Thiếu file tùy chọn → cảnh báo vàng, không ảnh hưởng build.
:::

### Yêu cầu phần mềm hệ thống (cài đặt một lần trên máy trạm)

| Thành Phần | Ghi chú kỹ thuật |
|------------|---------|
| **Windows ADK** + **WinPE add-on** | Cài cùng phiên bản ADK, tương thích với phiên bản Windows ESD đang dùng. |
| **PowerShell 7.4+** | Bắt buộc cho engine build — chỉ cần phiên bản tiêu chuẩn. |

## 2. Kiểm tra điều kiện (Pre-check)

Khởi chạy công cụ → nhấn **Refresh Precheck** → Kiểm tra rằng tất cả hạng mục hiển thị tích xanh (✓) trước khi build ISO:

| Hạng mục kiểm tra | Bắt buộc | Ý nghĩa kỹ thuật |
|----------|:--------:|---------|
| PowerShell 7.4+ | ✅ | Môi trường thực thi script build. |
| ADK + WinPE add-on | ✅ | Bộ công cụ phát triển Windows ADK, cần tương thích với tệp tin ESD. |
| ESD (`.cache\esd`) | ✅ | Xác thực sự tồn tại của tệp tin cài đặt OS nguồn. |
| Apps (`.cache\apps`) | ✅ | Đầy đủ tệp tin EasyDeploy và file cấu hình hệ thống. |
| Drivers (`.cache\downloads`) | ⭕ | Chỉ cần khi máy trạm cần driver mạng hoặc lưu trữ đặc thù. |
| Wallpaper (`.cache\wallpaper`) | ⭕ | Hình nền. Nếu thiếu, hệ thống dùng hình nền mặc định. |

## 3. Xây dựng tệp tin ISO (Build ISO)

1. Khi tất cả điều kiện pre-check đạt (tích xanh), nhấn **⚙️ Build ISO** để bắt đầu.
2. **Xác thực bản quyền (License Verification)** — tự động bỏ qua nếu license hợp lệ đã có trong cache:
   - **Đã có license trong cache:** Nếu `.cache\usb\EASYDEPLOY\` chứa file `*.lic` hợp lệ (ký số), BootBuilder tự động bỏ qua và vào giao diện thiết lập build.
   - **Chưa có license:** Mở **file-picker** → chọn file `*.lic` từ CoreSystem → BootBuilder **verify chữ ký** → lưu vào `.cache\usb\EASYDEPLOY\` → tiếp tục.
   - **Hủy:** Chọn **Cancel** tại bước này để dừng toàn bộ tiến trình build.
3. Thiết lập thông số đóng gói trên hộp thoại Build Options:
   - **Tích chọn Driver:** 6 tùy chọn bật/tắt driver (Dell, HP, Intel Ethernet, Intel Wireless, Lenovo, Others) — **mặc định ON**. Bạn chỉ cần tích chọn hãng phần cứng mục tiêu. Tắt bớt gói driver chỉ loại bỏ khỏi ISO, không gây lỗi build.
     - **Tùy chọn Others:** Cho thiết bị không thuộc 5 nhóm trên. Giải nén driver (chứa file `*.inf`) vào `.cache\downloads\others\` (mỗi thư mục con = 1 gói driver), công cụ tự tích hợp vào ISO.

:::note
Gói driver Dell, HP, Intel, Lenovo + WinRE đã đáp ứng ~99% máy văn phòng. Others chỉ cần cho dòng máy đặc thù (Acer, Asus, máy nội địa Nhật/Hàn/Trung). **Bắt buộc dùng driver WinPE 10/11**, không dùng driver Windows thường để tránh xung đột.
:::

:::note
**USB/ISO tiêu chuẩn (shared) phủ tốt phần cứng phổ biến** — vì các hãng OEM nhỏ thường dùng
chung mẫu nền, nên bộ driver Dell/HP/Intel/Lenovo + WinRE đáp ứng đa số máy doanh nghiệp.
Với phần cứng đặc thù hoặc "ca khó" (gaming, cấu hình lạ, card mạng/storage mới), bạn nên
dùng **BootBuilder** để thêm driver vào gói `Others` thay vì nhồi quá nhiều driver vào WinPE.
:::

   - **CA2023:** Tạo thêm file ISO hỗ trợ chuẩn bảo mật Secure Boot CA2023 (`bootmedia_ca2023.iso`) — **mặc định Tắt (OFF)**.
4. Nhấn **OK — Start Build** để đóng gói → Theo dõi tiến độ và nhật ký qua cửa sổ Console Log:
   - **Build lần đầu:** **22–25 phút** (hệ thống khởi tạo cấu trúc và cache).
   - **Build lần sau:** Rút ngắn còn khoảng **12 phút**.
5. **Tệp tin đầu ra:** File `bootmedia.iso` (và `bootmedia_ca2023.iso` nếu tùy chọn CA2023 bật). Chọn **📁 Output Folder** để mở thư mục chứa ISO, hoặc **💾 Save Log** để xuất nhật ký.

:::caution
**Ghi ISO ra USB:** Dùng **Rufus** để ghi file ISO ra USB boot. Nếu cần chép file `.esd` (>4GB) vào USB, USB **bắt buộc định dạng NTFS** (FAT32 không hỗ trợ file đơn >4GB). Chọn NTFS trong Rufus trước khi ghi.
:::

## 4. Cấu trúc thư mục USB sau khi đóng gói

```
[USB]:
├── bootmgr, bootmgr.efi
├── Boot\  EFI\  en-us\  sources\     ← Phân vùng khởi động WinPE (EasyDeploy.exe tích hợp trong boot.wim)
├── EASYDEPLOY\
│   ├── user-config.json               ← Thiết lập cấu hình triển khai
│   ├── license.lic                    ← License offline (đặt vào, được nhúng vào ISO)
│   ├── Profiles\                      ← Danh mục profiles tùy biến (mặc định 1.Tweaks và 2.TweaksApp)
│   └── OS\                            ← (Tùy chọn) Nguồn cài đặt OS offline/hybrid
└── Softwares\                         ← Các phần mềm và công cụ cứu hộ Portable
```

## 5. Tùy biến nhanh

| Bạn muốn | Thao tác |
|----------|--------|
| Thay đổi hình nền WinPE | Đặt file ảnh tên `wallpaper.jpg` hoặc `winpe.jpg` trong `.cache\wallpaper\` |
| Tùy biến Profile sau cài đặt | Chỉnh sửa cấu hình hoặc script trong `usb\EASYDEPLOY\Profiles\` |
| Mã hóa Profile (chỉ MSP Advanced) | Dùng `encrypt-profile.ps1` mã hóa thư mục profile, gán `profileEncryption` trong `system-config.json` — xem [Profiles](/easydeploy/profiles/profiles/) |
| Bổ sung công cụ cứu hộ | Sao chép phần mềm Portable vào `usb\Softwares\` |
| Bổ sung driver hãng khác (Others) | Giải nén gói driver chứa `*.inf` vào `.cache\downloads\others\` (mỗi thư mục con = 1 gói driver). Khuyến nghị dùng driver WinPE 10/11 của hãng sản xuất. |
| Lựa chọn gói driver | Dùng nút bật/tắt (toggle) trên giao diện thiết lập build |

## 6. Xác thực bản quyền trong BootBuilder

BootBuilder xác thực bằng **Offline License** (file `*.lic` từ CoreSystem) trước khi đóng gói ISO. **BootBuilder chỉ dành cho gói MSP Standard/Advanced** (whitebox).

| Phương thức | Cơ chế hoạt động |
|--------|----------------|
| **Offline License (duy nhất)** | Đặt file `*.lic` từ CoreSystem (có ký số, gắn USB-SN) vào `.cache\usb\EASYDEPLOY\` → BootBuilder tự xác thực và cho build. Chưa có → file-picker chọn `.lic` → xác thực → lưu vào cache. |
| **Gate tier (whitebox)** | BootBuilder chỉ hoạt động với license **standard/advanced**. Gói **Trial** không dùng được cho whitebox (thông báo "License Tier Not Supported"). |

:::tip
- License `.lic` trong cache sẽ được **nhúng vào ISO** (`\EASYDEPLOY\`) — client deploy trên máy trạm dùng chính license đó.
- BootBuilder hoạt động **hoàn toàn ngoại tuyến** — không cần kết nối máy chủ để xác thực.
:::

## 7. Khuyến nghị vận hành an toàn

- **Nguồn điện:** Tắt chế độ ngủ tự động trong quá trình build (đặc biệt lần đầu ~22–25 phút) để tránh gián đoạn.
- **Xung đột:** Không chạy **đồng thời 2 tiến trình build** trên cùng thư mục `.cache`.
- **Mất nguồn:** Nếu bị ngắt giữa chừng, khởi chạy lại công cụ — hệ thống tự dọn dẹp tạm và tiếp tục bình thường.

## 8. Các bước tiếp theo

Sau khi xuất ISO thành công: Ghi ISO ra USB qua Rufus → thiết lập `user-config.json` cho khách hàng (xem [Bắt đầu với EASYDEPLOY](/easydeploy/msp/getting-started/) hoặc [Quick Start](/easydeploy/getting-started/quick-start/)) → bàn giao USB cho kỹ thuật viên hoặc khách hàng.

:::tip
USB tùy biến thương hiệu có quy trình vận hành (khởi động WinPE, chọn luồng cài đặt, khắc phục sự cố) hoàn toàn đồng nhất với USB tiêu chuẩn từ CoreSystem. Chi tiết xem [Quick Start](/easydeploy/getting-started/quick-start/).
:::