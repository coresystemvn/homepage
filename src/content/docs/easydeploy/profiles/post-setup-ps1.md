---
title: 'Tùy biến script Post-setup.ps1'
---

Tệp tin `Post-setup.ps1` là một kịch bản lệnh PowerShell tự động thực thi trong **lần đăng nhập đầu tiên vào Desktop** sau khi hệ điều hành Windows hoàn tất tiến trình thiết lập. EASYDEPLOY sẽ sao chép tệp tin này vào thư mục `C:\CoreSystem\Post-setup.ps1` trên phân vùng hệ thống, và trình Windows Setup sẽ gọi thực thi script này thông qua phân hệ `FirstLogonCommands` được khai báo trong `unattend.xml`. Đây là môi trường lý tưởng để quản trị viên cấu hình các thiết lập tinh chỉnh (tweaks) sau cài đặt: tùy biến hệ thống, cài đặt ứng dụng tự động, cấu hình hình nền, hoặc dọn dẹp tài nguyên tạm thời.

:::note
Tệp tin trên USB có thể đặt tên là `Post-setup.ps1` hoặc `post-setup.ps1` (hệ thống không phân biệt chữ in hoa/in thường). Tuy nhiên, khi được sao chép vào thư mục `C:\CoreSystem\` trên máy trạm, tệp tin sẽ luôn được chuẩn hóa tên thành `Post-setup.ps1`.

Tệp tin `post-setup.ps1` là một thành phần bắt buộc của Profile — vui lòng lưu ý **luôn duy trì đồng bộ cặp tệp tin cùng với `unattend.xml`** (mỗi profile hợp lệ bắt buộc phải có đầy đủ 2 tệp tin này, chi tiết xem tại [Profiles Overview](/easydeploy/profiles/profiles/)).
:::

## 1. Vòng đời hoạt động của Script

```
Windows khởi động lần đầu sau cài đặt
    │
    ▼
Tự động đăng nhập Desktop (AutoLogon) (nếu được cấu hình)
    │
    ▼
FirstLogonCommands gọi PowerShell thực thi lệnh:
      if (Test-Path C:\CoreSystem\Post-setup.ps1) { Unblock-File …; & … }
    │
    ▼
Script bắt đầu thực thi (dưới quyền hạn của tài khoản đang đăng nhập — thông thường là Administrator)
    │
    ▼
Script hoàn tất xử lý và tự động khởi động lại thiết bị (Reboot) nếu có yêu cầu cấu hình
```

## 2. Cấu trúc script khuyến nghị (Theo mẫu tiêu chuẩn)

Profile mẫu tích hợp sẵn (`1.Tweaks`) được thiết kế với cấu trúc logic tối ưu, rất phù hợp để làm khuôn mẫu tham khảo:

```powershell
# 0. Định nghĩa tiêu đề hiển thị và cấu hình biến thời gian chờ (Timeout)
Write-Host "=== [CoreSystem] POST-SETUP ===" -ForegroundColor Cyan
$GlobalTimeoutSec = 300

# 1. Khai báo hàm kiểm tra kết nối Internet (Thử lại tối đa 6 lần, chu kỳ 5 giây)
function Wait-ForInternet { … }

# 2. Thực thi kiểm tra mạng — các tác vụ yêu cầu internet chỉ chạy khi có kết nối
$HasInternet = Wait-ForInternet

# 3. [Bước X/7] Đồng bộ tệp tin/tài nguyên từ Cloud (ví dụ: Notes.txt,...)
# 4. [Bước X/7] Tải về và thiết lập hình nền (Wallpaper)
# 5. [Bước X/7] Tự động cài đặt ứng dụng (qua WinGet hoặc file cài msi/exe)
# 6. [Bước X/7] Dọn dẹp tài nguyên hệ thống (xóa nhật ký Event Logs, dọn Panther/CoreSystem sau khi reboot)
# 7. [Bước X/7] Khôi phục chính sách thực thi script ExecutionPolicy về RemoteSigned
```

:::tip
Việc đánh số thứ tự tuần tự các bước dạng `[1/7] ... [7/7]` kết hợp lệnh `Write-Host` hiển thị màu sắc trực quan sẽ giúp kỹ thuật viên dễ dàng giám sát tiến độ thực thi của script. Mẫu chuẩn sử dụng quy ước màu sắc: `Green` (Thành công/OK), `Yellow` (Cảnh báo/Warning), và `Red` (Lỗi/Error).
:::

## 3. Một số đoạn script mẫu hữu ích (Code Blocks)

### 3.1. Vòng lặp kiểm tra kết nối Internet (Bắt buộc nếu script cần tải tài nguyên từ mạng)

```powershell
function Wait-ForInternet {
    $retry = 0
    while ($retry -lt 6) {
        if (Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet) { return $true }
        Start-Sleep -Seconds 5
        $retry++
    }
    return $false
}
$HasInternet = Wait-ForInternet
```

### 3.2. Tải về và cấu hình hình nền (Wallpaper) từ đường dẫn URL

```powershell
$Url = "https://coresystem.vn/osd/wallpaper.jpg"
$Dest = "C:\Windows\Web\Wallpaper\CoreSystem\wallpaper.jpg"
if ($HasInternet) {
    New-Item -ItemType Directory -Path (Split-Path $Dest) -Force | Out-Null
    Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing -TimeoutSec $GlobalTimeoutSec
    # Áp dụng thay đổi hình nền bằng P/Invoke gọi hàm SystemParametersInfo từ thư viện user32.dll
}
```

### 3.3. Tự động cài đặt ứng dụng qua Windows Package Manager (WinGet - có sẵn trên Windows 11)

```powershell
$apps = @("7zip.7zip", "Google.Chrome", "Microsoft.PowerToys")
foreach ($app in $apps) {
    if ($HasInternet) {
        winget install --id $app --accept-package-agreements --accept-source-agreements --silent
    }
}
```

:::note
**Lưu ý kỹ thuật:** Trong một số trường hợp, công cụ WinGet có thể chưa hoàn thành khởi tạo dịch vụ ngay sau khi đăng nhập Desktop. Profile mẫu `2.TweaksApp` đã tích hợp sẵn một đoạn lệnh để kích hoạt nguồn WinGet trước (`winget source list`). Quản trị viên nên tham khảo cấu trúc này trước khi vận hành.
:::

### 3.4. Dọn dẹp nhật ký hệ thống và tự động xóa dữ liệu tạm thời

```powershell
Get-EventLog -LogName * -ErrorAction SilentlyContinue |
    ForEach-Object { Clear-EventLog -LogName $_.Log -ErrorAction SilentlyContinue }

# Cấu hình xóa sạch thư mục Panther & CoreSystem trong phiên khởi động tiếp theo (giữ thiết bị "sạch" hoàn toàn)
$RunOnce = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnce -Name "CleanupPanther"   -Value "cmd.exe /c rmdir /s /q C:\Windows\System32\Panther" -Force
Set-ItemProperty $RunOnce -Name "CleanupCoreSystem" -Value "cmd.exe /c rmdir /s /q C:\CoreSystem"             -Force
```

### 3.5. Khôi phục chính sách thực thi script (ExecutionPolicy)

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
```

## 4. Nguyên tắc bảo mật (Security Guidelines)

:::danger
Do script được thực thi dưới **quyền hạn tối cao Administrator** và có toàn quyền truy cập mạng, quản trị viên cần tuân thủ nghiêm ngặt các nguyên tắc bảo mật sau:

- **Bảo mật thông tin:** Tuyệt đối **không lưu trữ trực tiếp** mật khẩu tài khoản Administrator, API Key hoặc các thông tin nhạy cảm khác dưới dạng văn bản rõ (clear text) trong script.
- **Kiểm soát nguồn tải:** Chỉ thực hiện tải các tệp tin từ những nguồn máy chủ (URL) đáng tin cậy. Khuyến nghị thực hiện xác minh mã băm (hash validation) tệp tin sau khi tải về.
- **Bỏ chặn thực thi:** Theo cơ chế bảo mật mặc định của Windows, script tải từ internet sẽ bị chặn thực thi. Hãy đảm bảo giữ nguyên lệnh gọi `Unblock-File` trong cấu hình `unattend.xml` để mở khóa script trước khi chạy.
- **An toàn chính sách (Policy):** Luôn đảm bảo script thực hiện khôi phục chính sách `ExecutionPolicy` về trạng thái an toàn `RemoteSigned` ở cuối tiến trình để bảo vệ hệ thống sau khi cài đặt.
- **Kiểm soát nhật ký cài đặt:** Mặc định, tệp tin `Post-setup.ps1` và các tài nguyên tạm thời trong `C:\CoreSystem` sẽ tự động bị xóa sạch sau khi thiết bị reboot lần cuối (qua lệnh cấu hình tại khóa RunOnce). Nếu quản trị viên muốn giữ lại thư mục này để phục vụ mục đích kiểm tra lỗi hoặc gỡ lỗi, vui lòng loại bỏ lệnh xóa trong cấu hình Cleanup ở trên.
:::

## 5. Khuyến nghị vận hành và triển khai

- **Tùy biến nhanh chóng:** Mọi thay đổi nội dung tệp tin `Post-setup.ps1` trong thư mục profile trên USB **không yêu cầu phải biên dịch (build) lại tệp tin thực thi**. EASYDEPLOY sẽ tự động quét và đọc trực tiếp từ đường dẫn `EASYDEPLOY\Profiles\<TênProfile>\`. Quản trị viên chỉ cần ghi đè file trên USB và thực hiện boot lại để kiểm tra kết quả.
- **Phân định trách nhiệm cấu hình:** Việc thay đổi cấu trúc của **Profile mặc định** (profile dự phòng của hệ thống khi USB trống) thuộc thẩm quyền xử lý của **CoreSystem**. Đối tác IT/MSP chỉ nên chủ động khởi tạo và tùy biến các cấu hình profile riêng biệt lưu trữ trực tiếp trên thiết bị USB của mình (tham khảo chi tiết tại [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/)).
