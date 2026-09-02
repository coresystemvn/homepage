---
title: 'BootBuilder (Whitebox) — Tự dựng USB/ISO tùy biến'
---

**EasyDeploy.BootBuilder** là ứng dụng Windows dành cho máy trạm, giúp bạn xây dựng bộ đĩa **USB/ISO WinPE** tùy biến. Công cụ chuẩn bị tài nguyên trong thư mục `.cache`, tích hợp driver phần cứng, và xuất file ISO boot để ghi lên USB.

:::note
**Quyền sử dụng:** BootBuilder dùng được cho **mọi tier**. **Free** hay **Advanced** đều build được — chỉ khác số profiles được copy vào ISO . Chi tiết xem [License Tiers](/easydeploy/msp/license-tiers/).
:::

:::caution
**Cảnh báo Antivirus:** Tệp tin `EasyDeploy.BootBuilder.exe` chưa có chữ ký số. Một số phần mềm Antivirus có thể nhận diện nhầm và chặn hoặc cảnh báo khi khởi chạy. Bạn cần thêm tệp tin vào danh sách loại trừ trên máy trạm. Đây là hiện tượng phổ biến với tệp thực thi chưa ký số. Hãy tải tệp từ liên kết chính thức do CoreSystem cung cấp.
:::

## 1. Các bước chuẩn bị trước khi vận hành

1. Tải về gói công cụ gồm `EasyDeploy.BootBuilder.exe` và tệp hướng dẫn `links.md` (do CoreSystem phát hành). Khởi chạy bằng quyền quản trị (**Run as administrator**).
2. Lần chạy đầu tiên, ứng dụng **tự động tạo** thư mục `.cache` cùng thư mục với file thực thi. Đồng thời khởi tạo mẫu cấu hình (`user-config.json`) và 2 bộ profile mặc định. Bạn chỉ cần bổ sung các file yêu cầu vào đúng thư mục trong `.cache` (xem bảng dưới) — **không nên xóa `.cache`**.

### Danh mục tài nguyên trong thư mục `.cache`

| Thư mục | Nội dung | Bắt buộc |
|----------|----------|:--------:|
| `esd\` | Tệp tin ESD cài đặt Windows 11 (định dạng `*.esd`) | ✅ |
| `apps\` | Tệp tin thực thi `EasyDeploy.exe` , `EasyDeploy.exe.sig` và file cấu hình `system-config.json`  | ✅ |
| `downloads\` | Driver phần cứng theo nhà sản xuất — tổ chức theo: `dell\`, `hp\`, `intel\`, `intel-wifi\`, `lenovo\`, `others\` | ⭕ |
| `wallpaper\` | Hình ảnh `wallpaper.jpg` hoặc `winpe.jpg` để tùy biến nền WinPE | ⭕ |
| `usb\` | Payload USB: thư mục `EASYDEPLOY\` (cấu hình, profiles), license `.lic` + `Softwares\` (công cụ cứu hộ Portable) | ⭕ |

:::caution
Công cụ hoạt động hoàn toàn ngoại tuyến, **không tự động tải tài nguyên từ internet**. Bạn cần tải trước và sắp xếp vào đúng thư mục. Thiếu file bắt buộc → giao diện hiển thị **cảnh báo đỏ**; mở `links.md` để lấy liên kết tải. Thiếu file tùy chọn → cảnh báo vàng, không ảnh hưởng build.
:::

:::caution
Vì lý do an toàn, Bootbuilder sẽ kiểm tra chữ ký của EasyDeploy.exe và EasyDeploy.exe.sig để xác thực đúng tập tin được cung cấp bởi CoreSystem trước khi cho phép build file iso
:::

### Yêu cầu phần mềm hệ thống (cài đặt một lần trên máy trạm)

| Thành Phần | Ghi chú kỹ thuật |
|------------|---------|
| **Windows ADK** + **WinPE add-on** | Cài cùng phiên bản ADK, tương thích với phiên bản Windows ESD đang dùng. |
| **PowerShell 7.4+** | Bắt buộc cho engine build — chỉ cần phiên bản tiêu chuẩn. |

:::note
Phiên bản ADK mới nhất là 24H2 dùng được cho esd có mã build 26100 (24H2) và 26200 (25H2).
:::

## 2. Kiểm tra điều kiện (Pre-check)

Khởi chạy công cụ → nhấn **Refresh Precheck** → Kiểm tra rằng tất cả hạng mục hiển thị tích xanh (✓) trước khi build ISO:

| Hạng mục kiểm tra | Bắt buộc | Ý nghĩa kỹ thuật |
|----------|:--------:|---------|
| PowerShell 7.4+ | ✅ | Môi trường thực thi script build. |
| ADK + WinPE add-on | ✅ | Bộ công cụ phát triển Windows ADK, cần tương thích với tệp tin ESD. |
| ESD (`.cache\esd`) | ✅ | Xác thực sự tồn tại của tệp tin cài đặt OS nguồn. |
| Apps (`.cache\apps`) | ✅ | Đầy đủ tệp tin EasyDeploy và file cấu hình hệ thống. BootBuilder **kiểm tra chữ ký YubiKey** của `EasyDeploy.exe` để đảm bảo file không bị chỉnh sửa. |
| Drivers (`.cache\downloads`) | ⭕ | Chỉ cần khi máy trạm cần driver mạng hoặc lưu trữ đặc thù. |
| Wallpaper (`.cache\wallpaper`) | ⭕ | Hình nền. Nếu thiếu, hệ thống dùng hình nền mặc định. |

:::note
Pre-check `Apps` sẽ báo `Signature verified (YubiKey signed by CoreSystem)` khi `EasyDeploy.exe` nguyên vẹn. BootBuilder nhúng sẵn public key để tự kiểm tra — nếu `EasyDeploy.exe` không qua được bước xác thực chữ ký, **việc build ISO sẽ bị chặn**. Đây là rào chắn an toàn giúp bạn không dựng USB từ file đã bị repack.
:::

## 3. Xây dựng tệp tin ISO (Build ISO)

1. Khi tất cả điều kiện pre-check đạt (tích xanh), nhấn **⚙️ Build ISO** để bắt đầu.
2. **Chọn bản quyền (nếu có):** Hộp thoại `EasyDeploy License` sẽ hỏi `Do you have an EasyDeploy license to unlock all features?`
   - Chọn **Continue without license** — build ở chế độ **Free**: chỉ copy **2 bộ profile mặc định** (`1.Tweaks`, `2.TweaksApp`) vào ISO.
   - Chọn **I have a license** → chọn file `*.lic` (ký số, bind USB-SN) → BootBuilder verify → lưu vào `.cache\usb\EASYDEPLOY\` → build ở chế độ **Advanced**: tự động copy **không giới hạn profiles** vào ISO.

   - **Tích chọn Driver:** 6 tùy chọn bật/tắt driver (Dell, HP, Intel Ethernet, Intel Wireless, Lenovo, Others) — **mặc định ON**. Bạn chỉ cần tích chọn hãng phần cứng mục tiêu. Tắt bớt gói driver chỉ loại bỏ khỏi ISO, không gây lỗi build.
     - **Tùy chọn Others:** Cho thiết bị không thuộc 5 nhóm trên. Giải nén driver (chứa file `*.inf`) vào `.cache\downloads\others\` (mỗi thư mục con = 1 gói driver), công cụ tự tích hợp vào ISO.

:::note
Gói driver Dell, HP, Intel, Lenovo + WinRE đã đáp ứng đa số máy tính văn phòng. Others chỉ cần cho dòng máy đặc thù (Acer, Asus, máy nội địa Nhật/Hàn/Trung). **Bắt buộc dùng driver WinPE 10/11**, không dùng driver Windows thường để tránh xung đột.
:::


   - **CA2023:** Tạo thêm file `bootmedia_ca2023.iso` — bản ISO hỗ trợ Secure Boot với chứng chỉ CA 2023 (bộ chứng chỉ cập nhật cho firmware/máy mới). **Mặc định Tắt (OFF)** — chỉ bật khi máy đích đang bật Secure Boot.
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
| Tùy biến Profile sau cài đặt | Chỉnh sửa cấu hình hoặc script trong `usb\EASYDEPLOY\Profiles\` — Free 2 profiles, Advanced unlimited (chi tiết kèm `.lic` Advanced) |
| Bổ sung công cụ cứu hộ | Sao chép phần mềm Portable vào `usb\Softwares\` (app không đi kèm bộ phát hành — dùng công cụ của bạn, giữ cấu trúc thư mục như `toolPaths` hoặc khai báo `user-config.json`; số lượng không giới hạn, ngoài 4 slot gọi qua F6/F8/cmd) |
| Bổ sung driver hãng khác (Others) | Giải nén gói driver chứa `*.inf` vào `.cache\downloads\others\` (mỗi thư mục con = 1 gói driver). Khuyến nghị dùng driver WinPE 10/11 của hãng sản xuất. |
| Lựa chọn gói driver | Dùng nút bật/tắt (toggle) trên giao diện thiết lập build |


## 6. Khuyến nghị vận hành an toàn

- **Nguồn điện:** Tắt chế độ ngủ tự động trong quá trình build (đặc biệt lần đầu ~22–25 phút) để tránh gián đoạn.
- **Xung đột:** Không chạy **đồng thời 2 tiến trình build** trên cùng thư mục `.cache`.
- **Mất nguồn:** Nếu bị ngắt giữa chừng, khởi chạy lại công cụ — hệ thống tự dọn dẹp tạm và tiếp tục bình thường.

## 7. Các bước tiếp theo

Sau khi xuất ISO thành công: Ghi ISO ra USB qua Rufus → thiết lập `user-config.json` cho khách hàng (xem [Bắt đầu với EASYDEPLOY](/easydeploy/msp/getting-started/) hoặc [Quick Start](/easydeploy/getting-started/quick-start/)) → bàn giao USB cho kỹ thuật viên hoặc khách hàng.
