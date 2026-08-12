---
title: 'Profiles — Tổng quan hệ thống'
---

Profile là tập hợp các tệp tin cấu hình tùy biến sau cài đặt (post-installation) được EASYDEPLOY tích hợp (inject) vào hệ điều hành Windows trong tiến trình triển khai. Mỗi Profile bắt buộc phải bao gồm **2 tệp tin**:

```
EASYDEPLOY\Profiles\<TênProfile>\
├── unattend.xml        ← Tệp tin trả lời tự động (Answer File) của Windows Setup
└── post-setup.ps1      ← Script PowerShell tự động chạy trong lần đăng nhập đầu tiên
```

:::danger
Mỗi Profile **bắt buộc phải có đủ 2 tệp tin**: 1 file định dạng `*.xml` và 1 file script `*.ps1`. Tại bước tích hợp (**inject**), EASYDEPLOY sẽ tự động sao chép tệp tin `*.xml` thành `unattend.xml` và tệp tin `*.ps1` thành `Post-setup.ps1` trên phân vùng cài đặt (tên của các tệp tin nguồn trong thư mục profile có thể đặt tùy ý). Tuy nhiên, **quản trị viên khuyến nghị đặt chính xác tên tệp tin chuẩn là `unattend.xml` và `post-setup.ps1`** — do cơ chế quét phát hiện profile của luồng Business/Express chỉ nhận diện thư mục khi có **ít nhất một** trong hai tên tệp tin tiêu chuẩn này; nếu cả hai file đều đặt tên khác, profile sẽ bị bỏ qua và không hiển thị trong danh sách lựa chọn.
:::

## 1. Vòng đời hoạt động của Profile

```
deploy (chế độ Business / Express)
    │
    │  Engine hoàn thành cài đặt Windows (Bước 11/11, mã thoát exit 0)
    ▼
Dịch vụ NextStepService: Sao chép tệp cấu hình vào Windows Image đã cài đặt
    │  ├─ unattend.xml      → C:\Windows\Panther\unattend.xml
    │  └─ post-setup.ps1    → C:\CoreSystem\Post-setup.ps1
    ▼
Thực thi wpeutil reboot  →  Windows khởi động lần đầu, trình Setup đọc file unattend.xml (xử lý các giai đoạn windowsPE, specialize, và oobeSystem)
    ▼
Màn hình OOBE: Tự động khởi tạo tài khoản theo file XML, cấu hình Autologon và thực thi các lệnh FirstLogonCommands
    ▼
Lần đăng nhập đầu tiên vào Desktop: Tự động khởi chạy script C:\CoreSystem\Post-setup.ps1 (áp dụng tweaks, cấu hình hệ thống, cài đặt ứng dụng, thiết lập wallpaper,...)
```

## 2. Cơ chế tìm kiếm và quét Profile

EASYDEPLOY tự động quét thư mục `EASYDEPLOY\Profiles` theo thứ tự ưu tiên sau:

1. **Tất cả các phân vùng ổ đĩa** (ưu tiên kiểm tra thiết bị USB boot trước tiên) — `[ký_tự_ổ]:\EASYDEPLOY\Profiles\*`
2. Thư mục nằm cùng cấp với tệp tin `easydeploy.exe` — `.\EASYDEPLOY\Profiles\*`
3. Phân vùng tạm thời WinPE — `X:\SetupFiles\`

:::danger
**Cơ chế dự phòng (Fallback) sang Profile mặc định:** Đối với cả hai luồng **Business (2)** và **Express (F3)**, nếu hệ thống **không tìm thấy bất kỳ thư mục profile nào** trên USB, EASYDEPLOY sẽ tự động áp dụng **profile mặc định tích hợp sẵn trong hệ thống** (tương đương với profile `1.Tweaks`). Do đó, thiết bị sau khi cài đặt vẫn đảm bảo cấu hình tối ưu theo tiêu chuẩn vận hành doanh nghiệp mà không bắt buộc quản trị viên phải thiết lập profile từ trước.
:::

## 3. Các Profile tiêu chuẩn tích hợp sẵn

Trong tiến trình xây dựng ISO/USB, công cụ **EasyDeploy-BootBuilder** sẽ tự động đóng gói sẵn hai profile mẫu tại thư mục `EASYDEPLOY\Profiles\`:

| Profile | Nội dung chi tiết |
|---------|----------|
| **`1.Tweaks`** | Tập hợp các tinh chỉnh hệ thống cơ bản: áp dụng wallpaper doanh nghiệp, dọn dẹp file rác, cấu hình Power Plan ở mức High Performance. |
| **`2.TweaksApp`** | Thừa hưởng toàn bộ tinh chỉnh của profile 1, đồng thời tự động cài đặt các ứng dụng chỉ định thông qua Windows Package Manager (WinGet). |

Đây là các cấu hình **tiêu chuẩn, đã được tối ưu hóa cho môi trường thực tế (production-ready)** và có thể đưa vào vận hành ngay lập tức, đồng thời đóng vai trò làm khuôn mẫu để quản trị viên tham khảo và tùy biến theo nhu cầu riêng của doanh nghiệp (xem hướng dẫn tại [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/)).

## 4. Sự khác biệt sử dụng Profile giữa các chế độ cài đặt

| Chế độ triển khai | Cơ chế áp dụng Profile |
|--------|---------|
| Vanilla (phím 1) | ❌ Không áp dụng — Cài đặt hệ điều hành Windows nguyên bản |
| Business (phím 2) | ✅ Hỗ trợ tùy chọn — Kỹ thuật viên lựa chọn profile mong muốn trên giao diện OSConfigurator |
| Express (F3) | ✅ Tự động áp dụng — Hệ thống tự động trỏ tới profile khai báo tại khóa `deploy.profile` trong file `user-config.json` |

## 5. Tài liệu hướng dẫn chuyên sâu

| Tài liệu hướng dẫn | Mục tiêu tìm hiểu |
|-------|----------|
| [unattend.xml](/easydeploy/profiles/unattend-xml/) | Hướng dẫn tùy biến quy trình thiết lập Windows Setup và màn hình OOBE (cấu hình tài khoản, autologon, khai báo lệnh chạy đầu tiên) |
| [Post-setup.ps1](/easydeploy/profiles/post-setup-ps1/) | Hướng dẫn tùy biến môi trường Windows sau khi đăng nhập Desktop (tinh chỉnh hệ thống, tự động cài ứng dụng, thiết lập hình nền) |
| [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/) | Quy trình chuẩn hóa để khởi tạo và kiểm thử một Profile mới dành cho cấu hình thiết bị mới |

## 6. Lưu ý an toàn thông tin (Security Guidelines)

:::danger
Cả hai tệp tin `unattend.xml` và `Post-setup.ps1` đều được thực thi dưới **quyền hạn quản trị cao nhất (System/Administrator)** trên máy trạm. Quản trị viên chỉ nên nhúng các dòng lệnh, đoạn script đáng tin cậy đã qua kiểm thử nghiêm ngặt — **tuyệt đối tránh lưu trữ trực tiếp các thông tin nhạy cảm** (như mật khẩu tài khoản Administrator, khóa bảo mật API Key,...) dưới dạng văn bản rõ (clear text) trong file. Tham khảo thêm hướng dẫn bảo mật tại [Post-setup.ps1](/easydeploy/profiles/post-setup-ps1/#lưu-ý-bảo-mật).
:::
