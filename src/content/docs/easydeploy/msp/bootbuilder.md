---
title: 'BootBuilder (Whitebox) — Tự dựng USB/ISO tùy biến'
---

**EasyDeploy.BootBuilder** là ứng dụng chạy trên hệ điều hành Windows dành cho máy trạm (Desktop), giúp quản trị viên tự xây dựng (build) bộ phương tiện khởi động **USB/ISO WinPE** tùy biến: chuẩn bị các tài nguyên cần thiết trong thư mục `.cache`, lựa chọn tích hợp driver phần cứng chuyên biệt, và xuất ra tệp tin ISO boot tiêu chuẩn để ghi lên USB.

:::note
**Quyền sử dụng:** Thay đổi giao diện thương hiệu (Whitebox) thông qua BootBuilder là **đặc quyền dành riêng cho các đối tác thuộc gói MSP Standard và MSP Advanced**. Người dùng gói Free (SMB/MBB) sẽ sử dụng trực tiếp các bản USB/ISO tiêu chuẩn được phân phối bởi CoreSystem. Chi tiết tham khảo [License Tiers](/easydeploy/msp/license-tiers/).
:::

:::caution
**Cảnh báo an toàn thông tin (Antivirus):** Do tệp tin `EasyDeploy.BootBuilder.exe` **chưa được tích hợp chữ ký số (non-code-signed binary)** từ nhà phát hành, một số phần mềm quét virus (Antivirus) có thể nhận diện nhầm và **ngăn chặn hoặc cảnh báo** khi khởi chạy. Trong trường hợp này, vui lòng thiết lập **thêm tệp tin vào danh sách loại trừ (Whitelist/Exclusion)** trên phần mềm Antivirus của máy trạm. Đây là hiện tượng cảnh báo phổ biến đối với các tệp tin thực thi chưa ký số và không ảnh hưởng đến an toàn hệ thống (đảm bảo tệp tin được tải về từ liên kết chính thức do CoreSystem cung cấp).
:::

## 1. Các bước chuẩn bị trước khi vận hành

1. Tải về gói công cụ bao gồm `EasyDeploy.BootBuilder.exe` và tệp tin hướng dẫn tải nguyên liệu `links.md` (do CoreSystem cấp phát). Khởi chạy tệp tin thực thi bằng quyền quản trị tối cao (**Run as administrator**).
2. Trong lần khởi chạy đầu tiên, ứng dụng sẽ **tự động tạo lập** thư mục lưu trữ tạm thời `.cache` nằm cùng cấp thư mục với file thực thi, đồng thời khởi tạo mẫu cấu hình tiêu chuẩn (`user-config.json`) và 2 profile mặc định. Quản trị viên chỉ cần di chuyển các tệp tin nguyên liệu cần thiết vào các thư mục tương ứng trong `.cache` (tham khảo chi tiết ở bảng dưới) — **tuyệt đối không tự ý xóa thư mục `.cache`**.
3. Đường dẫn lưu trữ `.cache` mặc định sẽ nằm cùng cấp với tệp tin `.exe`; quản trị viên có thể thay đổi đường dẫn này bằng cách cấu hình biến môi trường hệ thống `EASYDEPLOY_CACHE`.

### Danh mục tài nguyên trong thư mục `.cache`

| Thư mục | Nội dung | Bắt buộc |
|----------|----------|:--------:|
| `esd\` | Tệp tin ESD cài đặt Windows 11 (định dạng `*.esd`) | ✅ |
| `apps\` | Tệp tin thực thi `EasyDeploy.exe` và file cấu hình `system-config.json` (giải nén từ gói `EasyDeploy.zip`) | ✅ |
| `downloads\` | Các driver phần cứng theo nhà sản xuất (Vendor) — tổ chức theo các thư mục: `dell\`, `hp\`, `intel\`, `intel-wifi\`, `lenovo\`, `others\` | ⭕ |
| `wallpaper\` | Tệp tin hình ảnh `wallpaper.jpg` hoặc `winpe.jpg` để tùy biến hình nền môi trường WinPE | ⭕ |
| `usb\` | Dữ liệu payload của USB: Bao gồm thư mục `EASYDEPLOY\` (chứa cấu hình, profiles) + `Softwares\` (chứa các công cụ cứu hộ Portable) | ⭕ |

:::danger
Công cụ hoạt động hoàn toàn ngoại tuyến và **không tự động tải tài nguyên từ internet**. Quản trị viên cần chủ động tải trước các tệp tin và sắp xếp vào đúng các thư mục chỉ định. Nếu thiếu các tệp tin bắt buộc, giao diện phần mềm sẽ hiển thị **cảnh báo đỏ**; bạn có thể mở file `links.md` để lấy liên kết tải tài nguyên. Các tệp tin tùy chọn nếu bị thiếu sẽ chỉ hiển thị cảnh báo vàng và không ảnh hưởng đến tiến trình build ISO.
:::

### Yêu cầu phần mềm hệ thống (Cài đặt một lần trên máy trạm thực hiện build)

| Thành phần | Ghi chú kỹ thuật |
|------------|---------|
| **Windows ADK** + **WinPE add-on** | Cài đặt cùng một phiên bản ADK và đảm bảo tương thích với phiên bản Windows ESD sử dụng để triển khai. |
| **PowerShell 7.4+** (MSI) | Thành phần bắt buộc để chạy engine build — chỉ cần cài đặt phiên bản tiêu chuẩn. |

## 2. Tiến trình kiểm tra điều kiện (Pre-check)

Khởi chạy công cụ → nhấn nút **Refresh Precheck** → Đảm bảo tất cả các hạng mục kiểm tra hiển thị tích xanh (✓) trước khi tiến hành xây dựng ISO:

| Hạng mục kiểm tra | Yêu cầu bắt buộc | Ý nghĩa kỹ thuật |
|----------|:--------:|---------|
| PowerShell 7.4+ | ✅ | Môi trường thực thi script build. |
| ADK + WinPE add-on | ✅ | Bộ công cụ phát triển Windows ADK, cần đảm bảo tương thích với tệp tin ESD. |
| ESD (`.cache\esd`) | ✅ | Xác thực sự tồn tại của tệp tin cài đặt OS nguồn. |
| Apps (`.cache\apps`) | ✅ | Đảm bảo đầy đủ tệp tin ứng dụng EasyDeploy và file cấu hình hệ thống. |
| Drivers (`.cache\downloads`) | ⭕ | Chỉ yêu cầu khi máy trạm triển khai cần các driver mạng (NIC) hoặc lưu trữ đặc thù. |
| Wallpaper (`.cache\wallpaper`) | ⭕ | Cấu hình hình nền. Nếu thiếu, hệ thống sử dụng hình nền mặc định. |

## 3. Quy trình xây dựng tệp tin ISO (Build ISO)

1. Khi tất cả các điều kiện pre-check đều đạt yêu cầu (tích xanh), nhấn nút **⚙️ Build ISO** để bắt đầu.
2. **Xác thực bản quyền (License Verification)** (bước này sẽ tự động bỏ qua nếu thông tin bản quyền hợp lệ đã được cấu hình trước đó):
   - **Trường hợp sử dụng License Offline:** Nếu tệp tin `user-config.json` đã chứa khóa bản quyền ngoại tuyến hợp lệ (khóa `offlineLicense` khớp định dạng ký số `ED.<payload>.<signature>` do CoreSystem cấp phát), hệ thống sẽ **tự động bỏ qua** bước kiểm tra và di chuyển thẳng vào giao diện thiết lập build.
   - **Trường hợp chưa có bản quyền:** Giao diện **License Verify** sẽ tự động hiển thị → Quản trị viên nhập đầy đủ **3 thông tin xác thực** do CoreSystem cung cấp (`Business ID`, `Installation Code`, và `API Key`) → Chọn **Verify License** → Hệ thống tự động truy cập máy chủ để xác thực bản quyền → Chọn **Save & Continue** để tiếp tục. Các thông tin này sẽ được lưu trữ cục bộ trong `user-config.json` để tự động điền (autoload) cho các lần build tiếp theo.
   - **Hủy bỏ tiến trình:** Chọn **Cancel** tại bước này để dừng toàn bộ tiến trình build.
3. Thiết lập các thông số đóng gói trên hộp thoại Build Options:
   - **Tích chọn Driver (Driver Toggles):** Cung cấp 6 tùy chọn bật/tắt driver (Dell, HP, Intel Ethernet, Intel Wireless, Lenovo, và **Others**) — **mặc định cấu hình ở trạng thái Bật (ON)**. Quản trị viên chỉ cần tích chọn các hãng phần cứng mục tiêu của doanh nghiệp. Việc tắt bớt gói driver chỉ đơn thuần là loại bỏ gói đó khỏi file ISO đầu ra và không gây lỗi tiến trình build.
     - **Tùy chọn Others (Driver hãng khác):** Dành cho các thiết bị phần cứng không thuộc 5 nhóm trên. Quản trị viên chỉ cần giải nén driver và đặt tệp tin chứa file cài đặt `*.inf` vào thư mục `.cache\downloads\others\` (mỗi thư mục con tương ứng với 1 gói driver), công cụ sẽ tự động tích hợp trực tiếp vào ISO.

:::note
**Lưu ý kỹ thuật về gói driver khác (Others):** Các gói driver tích hợp sẵn của Dell, HP, Intel, Lenovo kết hợp cùng bộ driver tiêu chuẩn trong WinRE đã **đáp ứng hầu hết (khoảng 99%)** cấu hình máy tính văn phòng của các doanh nghiệp hiện nay. Tùy chọn Others chỉ cần thiết cho các dòng máy đặc thù ít phổ biến (như Acer, Asus, hoặc các dòng máy nội địa của Nhật Bản, Hàn Quốc, Trung Quốc,...). Khi cấu hình gói Others, quản trị viên **bắt buộc phải sử dụng driver thiết kế dành riêng cho môi trường WinPE 10/11** do hãng cung cấp (tránh sử dụng driver của hệ điều hành Windows thương mại thông thường) để tránh xung đột hệ thống.
:::

   - **CA2023:** Tạo thêm file ISO hỗ trợ chuẩn bảo mật Secure Boot CA2023 (`bootmedia_ca2023.iso`) — **mặc định cấu hình ở trạng thái Tắt (OFF)**.
4. Nhấn **OK — Start Build** để bắt đầu đóng gói → Giám sát tiến độ và nhật ký xử lý qua cửa sổ Console Log:
   - **Thời gian build lần đầu:** Dao động trong khoảng **22–25 phút** (do hệ thống khởi tạo cấu trúc và cache).
   - **Thời gian build các lần tiếp theo:** Rút ngắn còn khoảng **12 phút**.
5. **Tệp tin đầu ra (Output):** Xuất file `bootmedia.iso` (và file `bootmedia_ca2023.iso` nếu tùy chọn CA2023 được kích hoạt). Quản trị viên có thể chọn nút **📁 Output Folder** để mở nhanh thư mục chứa file ISO hoàn thành, hoặc chọn **💾 Save Log** để xuất tệp nhật ký tiến trình.

:::caution
**Ghi file ISO lên thiết bị USB:** Sử dụng công cụ **Rufus** để ghi (burn) file ISO hoàn thành ra USB boot. Trong trường hợp cần **sao chép trực tiếp tệp tin cài đặt `.esd` (hoặc bất kỳ tệp tin nào có dung lượng lớn hơn 4GB) vào USB**, thiết bị USB **bắt buộc phải định dạng hệ thống file NTFS** (do định dạng mặc định FAT32 không hỗ trợ lưu trữ tệp tin đơn lẻ vượt quá 4GB). Quản trị viên nên lựa chọn định dạng NTFS trực tiếp trong cấu hình Rufus trước khi ghi, hoặc thực hiện format lại phân vùng USB sang NTFS trước khi chép tệp tin ESD.
:::

## 4. Cấu trúc thư mục USB sau khi đóng gói hoàn chỉnh

```
[USB]:
├── bootmgr, bootmgr.efi
├── Boot\  EFI\  en-us\  sources\     ← Phân vùng khởi động WinPE (EasyDeploy.exe tích hợp trong boot.wim)
├── EASYDEPLOY\
│   ├── user-config.json               ← Thiết lập thông tin bản quyền và cấu hình khách hàng
│   ├── Profiles\                      ← Danh mục profiles tùy biến (mặc định tích hợp 1.Tweaks và 2.TweaksApp)
│   └── OS\                            ← (Tùy chọn) Thư mục lưu trữ nguồn cài đặt OS offline/hybrid
└── Softwares\                         ← Danh mục các phần mềm và công cụ cứu hộ Portable
```

## 5. Hướng dẫn tùy biến nhanh

| Bạn muốn | Thao tác thực hiện |
|----------|--------|
| Thay đổi hình nền WinPE | Đặt file ảnh mong muốn và đặt tên là `wallpaper.jpg` hoặc `winpe.jpg` trong thư mục `.cache\wallpaper\` |
| Tùy biến Profile sau cài đặt | Chỉnh sửa cấu hình hoặc script trong thư mục `usb\EASYDEPLOY\Profiles\` |
| Bổ sung công cụ cứu hộ | Sao chép phần mềm Portable cần thiết vào thư mục `usb\Softwares\` |
| Bổ sung driver hãng khác (Others) | Giải nén gói driver chứa tệp tin cấu hình `*.inf` vào thư mục `.cache\downloads\others\` (mỗi thư mục con tương ứng với 1 gói driver) — khuyến nghị sử dụng driver chuẩn WinPE 10/11 của hãng sản xuất |
| Lựa chọn gói driver đóng gói | Sử dụng các nút bật/tắt (toggle) tương ứng trên giao diện thiết lập build |

## 6. Cơ chế xác thực bản quyền trong BootBuilder

BootBuilder hỗ trợ hai phương thức xác thực bản quyền trước khi thực hiện đóng gói (cả hai phương thức đều do CoreSystem cấp phép):

| Phương thức | Cơ chế hoạt động |
|--------|----------------|
| **Xác thực trực tuyến (Online)** | Khai báo 3 tham số `Business ID`, `Installation Code`, và `API Key` trên giao diện License Verify → Hệ thống kết nối máy chủ để xác thực → Thông tin tự động lưu vào `user-config.json` để autoload cho các phiên làm việc sau. |
| **Xác thực ngoại tuyến (Offline)** | Cấu hình trực tiếp mã bản quyền ngoại tuyến (khóa `offlineLicense` định dạng `ED.<payload>.<signature>`) vào file `user-config.json` → BootBuilder tự động nhận diện tính hợp lệ của license và bỏ qua bước verify trực tuyến. |

:::tip
- Lưu ý: Quản trị viên chỉ cấu hình áp dụng **một trong hai** phương thức xác thực trên — tham khảo chi tiết tại [Bắt đầu với EASYDEPLOY](/easydeploy/msp/getting-started/#2-thiết-lập-cấu-hình-user-configjson).
- Phương thức trực tuyến sử dụng chung bộ 3 thông số xác thực tương tự như trên các USB deploy thông thường; phương thức ngoại tuyến được cấp phát riêng biệt cho các dự án ngắn hạn hoặc môi trường bảo mật cao (liên hệ CoreSystem để được cấp khóa).
:::

## 7. Khuyến nghị vận hành an toàn

- **Cấu hình nguồn điện:** Vui lòng tạm thời **tắt chế độ ngủ tự động (Sleep Mode)** của máy trạm trong quá trình build (đặc biệt là lần chạy đầu kéo dài khoảng 22–25 phút) để tránh gián đoạn tiến trình.
- **Tránh xung đột tài nguyên:** Không thực hiện chạy **đồng thời 2 tiến trình build** trên cùng một thư mục lưu trữ `.cache`.
- **Xử lý sự cố mất nguồn:** Tuyệt đối hạn chế việc tắt máy hoặc ngắt nguồn giữa chừng khi đang build. Trong trường hợp tiến trình bị ngắt đột ngột, khởi chạy lại công cụ, hệ thống sẽ tự động dọn dẹp các tệp tin tạm và tiếp tục xây dựng bình thường.

## 8. Các bước tiếp theo sau khi hoàn thành build

Sau khi xuất file ISO thành công: Thực hiện ghi file ISO ra USB qua Rufus → Tiến hành thiết lập tệp tin `user-config.json` cho từng khách hàng cụ thể (tham khảo [Bắt đầu với EASYDEPLOY](/easydeploy/msp/getting-started/) hoặc hướng dẫn cấu hình tại [Quick Start](/easydeploy/getting-started/quick-start/#2-thiết-lập-cấu-hình-user-configjson)) → Bàn giao USB triển khai cho kỹ thuật viên hoặc khách hàng.

:::tip
Lưu ý: Thiết bị USB được xây dựng tùy biến thương hiệu có quy trình vận hành và sử dụng (khởi động WinPE, chọn luồng cài đặt, khắc phục sự cố) hoàn toàn đồng nhất với các bản USB tiêu chuẩn do CoreSystem phát hành — chi tiết xem tại [Quick Start](/easydeploy/getting-started/quick-start/).
:::
