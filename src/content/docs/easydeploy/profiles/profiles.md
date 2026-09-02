---
title: 'Profiles — Tổng quan hệ thống'
---

Profile là tập hợp tệp tin cấu hình sau cài đặt (post-installation). EASYDEPLOY inject chúng vào Windows trong quá trình triển khai. Mỗi Profile **gồm 2 tệp tin**:

```
EASYDEPLOY\Profiles\<TênProfile>\
├── unattend.xml        ← Tệp tin trả lời tự động (Answer File) của Windows Setup
└── post-setup.ps1      ← Script PowerShell chạy trong lần đăng nhập đầu tiên
```

:::caution
Mỗi Profile cần đủ 2 file để hoạt động đầy đủ: 1 `*.xml` và 1 `*.ps1`. EASYDEPLOY tự đổi tên khi sao chép, nhưng bạn nên đặt đúng tên chuẩn — trình quét hiển thị profile khi thư mục có **ít nhất một** file đúng tên; thiếu một trong hai file, hiệu ứng profile sẽ không đầy đủ.
:::

:::note
**Free & workflow kho profile:** ở chế độ Free, engine chỉ đọc `1.Tweaks` và `2.TweaksApp` — mọi folder khác trong `EASYDEPLOY\Profiles\` sẽ bị bỏ qua, không xuất hiện trong OSConfigurator. Cách dùng thực tế: giữ kho profile của bạn ở máy trạm, khi cần thì **ghi đè nội dung vào một trong hai folder gốc** (giữ đúng tên) rồi deploy. BootBuilder không license cũng chỉ đóng gói đúng 2 profile này vào ISO; Advanced thì không giới hạn số profile lúc build.

Việc dừng Post-setup ở baseline Tweaks là có chủ đích — phần sau cài đặt là sân khấu để MSP chứng minh năng lực chuyên môn với khách hàng (AD-DS/GPO, EntraID/Intune, PSADT/Chocolatey/Winget, MDM...).
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
