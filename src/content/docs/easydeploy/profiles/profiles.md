---
title: 'Profiles — Tổng quan hệ thống'
---

Profile là tập hợp tệp tin cấu hình sau cài đặt (post-installation). EASYDEPLOY inject chúng vào Windows trong quá trình triển khai. Mỗi Profile **bắt buộc có 2 tệp tin**:

```
EASYDEPLOY\Profiles\<TênProfile>\
├── unattend.xml        ← Tệp tin trả lời tự động (Answer File) của Windows Setup
└── post-setup.ps1      ← Script PowerShell chạy trong lần đăng nhập đầu tiên
```

:::caution
Mỗi Profile cần đủ 2 file: 1 `*.xml` và 1 `*.ps1`. EASYDEPLOY tự đổi tên khi sao chép, nhưng bạn nên đặt đúng tên chuẩn — trình quét chỉ nhận diện khi thư mục có ít nhất một file đúng tên.
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
Thực thi wpeutil reboot  →  Windows khởi động lần đầu, trình Setup đọc file unattend.xml (xử lý windowsPE, specialize, oobeSystem)
    ▼
Màn hình OOBE: Tự động khởi tạo tài khoản theo file XML, cấu hình Autologon và chạy FirstLogonCommands
    ▼
Desktop lần đầu: Tự động chạy C:\CoreSystem\Post-setup.ps1 (tweaks, cài ứng dụng, thiết lập wallpaper,...)
```

## 2. Cơ chế tìm kiếm và quét Profile

EASYDEPLOY tự động quét thư mục `EASYDEPLOY\Profiles` theo thứ tự ưu tiên:

1. **Tất cả phân vùng ổ đĩa** (ưu tiên USB boot trước) — `[ký_tự_ổ]:\EASYDEPLOY\Profiles\*`
2. Thư mục cùng cấp `easydeploy.exe` — `.\EASYDEPLOY\Profiles\*`
3. Phân vùng tạm WinPE — `X:\SetupFiles\`

:::caution
Fallback sang Profile mặc định: Nếu USB không có profile, hệ thống dùng profile mặc định (tương đương `1.Tweaks`).
:::

## 3. Các Profile tiêu chuẩn tích hợp sẵn

Khi xây dựng ISO/USB, **EasyDeploy-BootBuilder** tự động đóng gói hai profile mẫu tại `EASYDEPLOY\Profiles\`:

| Profile | Nội dung chi tiết |
|---------|----------|
| **`1.Tweaks`** | Tinh chỉnh hệ thống cơ bản: wallpaper doanh nghiệp, dọn file rác, Power Plan High Performance. |
| **`2.TweaksApp`** | Kế thừa profile 1, thêm tự động cài ứng dụng qua Windows Package Manager (WinGet). |

Đây là cấu hình **production-ready**, dùng ngay được và làm khuôn mẫu để bạn tùy biến theo nhu cầu (xem [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/)).

:::note
**Profile không giới hạn số lượng.** Bạn có tạo bao nhiêu profile tùy ý trong `EASYDEPLOY\Profiles\` — mỗi thư mục con là 1 profile riêng. Hai profile trên chỉ là mẫu nền để bạn tham khảo và tùy biến thêm.
:::

## 4. Sự khác biệt sử dụng Profile giữa các chế độ cài đặt

| Chế độ triển khai | Cơ chế áp dụng Profile |
|--------|---------|
| Vanilla (phím 1) | — Không áp dụng — Cài đặt Windows nguyên bản |
| Business (phím 2) | ✅ Hỗ trợ tùy chọn — Bạn chọn profile trên giao diện OSConfigurator |
| Express (F3) | ✅ Tự động áp dụng — Hệ thống trỏ tới profile tại khóa `deploy.profile` trong `user-config.json` |

## 5. Tài liệu hướng dẫn chuyên sâu

| Tài liệu hướng dẫn | Mục tiêu tìm hiểu |
|-------|----------|
| [unattend.xml](/easydeploy/profiles/unattend-xml/) | Tùy biến quy trình Windows Setup và OOBE (tài khoản, autologon, lệnh chạy đầu tiên) |
| [Post-setup.ps1](/easydeploy/profiles/post-setup-ps1/) | Tùy biến môi trường Windows sau Desktop (tweaks, cài ứng dụng, hình nền) |
| [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/) | Quy trình khởi tạo và kiểm thử Profile mới |

## 6. Lưu ý an toàn thông tin (Security Guidelines)

:::danger
`unattend.xml` và `Post-setup.ps1` chạy dưới quyền System/Administrator. Chỉ nhúng script đáng tin cậy đã qua kiểm thử. Không lưu trữ mật khẩu, API Key dạng rõ.
:::

## 7. Mã hóa Profile (chỉ MSP Advanced)

Khi profile chứa nhiều bí mật cài đặt (mật khẩu, tham số cấu hình, API key…), bạn có thể cân nhắc mã hóa để tăng cường bảo vệ — bên cạnh lớp bảo vệ sẵn có là `license bind USB-SN`.

Luồng tham khảo, khá nhẹ nhàng:

1. Tạo profile mới từ template của CoreSystem, hoàn tất thử nghiệm như thường lệ.
2. Dùng công cụ `encrypt-profile.ps1` để mã hóa thư mục profile với preshared-key. Công cụ sẽ giữ lại bộ profile gốc để bạn tiếp tục tùy biến khi cần.
   ```powershell
   .\encrypt-profile.ps1 -ProfilePath ".\EASYDEPLOY\Profiles\1.Tweaks" -Passphrase "msp-secret-key"
   .\encrypt-profile.ps1 -ProfilePath ".\EASYDEPLOY\Profiles\1.Tweaks" -Generate
   ```
   Với `-Generate`, công cụ tự sinh passphrase ngẫu nhiên 32 bytes (base64) nếu bạn chưa có sẵn key.
3. Gán key vào `system-config.json` (mặc định `off`) để đưa vào WinPE khi build bằng BootBuilder:
   ```jsonc
   "profileEncryption": { "enabled": true, "passphrase": "••••••••" }
   ```
4. EasyDeploy sẽ tự điều phối, giải mã và inject vào OS mới như thường lệ (Bước 11/11).

:::note
Tính năng này dành cho **MSP Advanced** và hoạt động như một lớp bảo vệ bổ sung — việc bảo quản USB vật lý và quản lý passphrase vẫn là trách nhiệm của doanh nghiệp. Bạn có thể chủ động cân nhắc mức độ áp dụng phù hợp với môi trường của mình.
:::