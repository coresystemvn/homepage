---
title: 'Tùy biến script Post-setup.ps1'
---

Tệp tin `Post-setup.ps1` là script PowerShell tự động chạy trong **lần đăng nhập đầu tiên vào Desktop** sau khi Windows hoàn tất thiết lập. EASYDEPLOY sao chép script vào `C:\CoreSystem\Post-setup.ps1` trên phân vùng hệ thống. Windows Setup gọi script qua `FirstLogonCommands` trong `unattend.xml`.

Đây là môi trường lý tưởng để bạn cấu hình tweaks sau cài đặt: tùy biến hệ thống, cài ứng dụng tự động, thiết lập hình nền, dọn dẹp tạm thời.

:::note
Tệp tin trên USB có thể đặt tên là `Post-setup.ps1` hoặc `post-setup.ps1` (hệ thống không phân biệt chữ hoa/thường). Khi sao chép vào `C:\CoreSystem\`, tệp tin sẽ luôn được chuẩn hóa tên thành `Post-setup.ps1`.

Tệp tin `post-setup.ps1` là thành phần bắt buộc của Profile. Bạn phải luôn duy trì đồng bộ cặp tệp tin cùng với `unattend.xml`.
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
Script bắt đầu chạy (dưới quyền Administrator)
    │
    ▼
Script hoàn tất và khởi động lại thiết bị (Reboot) nếu có yêu cầu
```

## 2. Cấu trúc script khuyến nghị (Theo mẫu tiêu chuẩn)

Profile mẫu tích hợp sẵn (`1.Tweaks`) được thiết kế với cấu trúc logic tối ưu. Bạn có thể dùng làm khuôn mẫu tham khảo:

```powershell
# 0. Định nghĩa tiêu đề hiển thị và cấu hình biến thời gian chờ (Timeout)
Write-Host "=== [CoreSystem] POST-SETUP ===" -ForegroundColor Cyan
$GlobalTimeoutSec = 300

# 1. Khai báo hàm kiểm tra kết nối Internet (Thử lại tối đa 6 lần, chu kỳ 5 giây)
function Wait-ForInternet { … }

# 2. Kiểm tra mạng — các tác vụ yêu cầu internet chỉ chạy khi có kết nối
$HasInternet = Wait-ForInternet

# 3. [Bước X/7] Đồng bộ tệp tin/tài nguyên từ Cloud (ví dụ: Notes.txt,...)
# 4. [Bước X/7] Tải về và thiết lập hình nền (Wallpaper)
# 5. [Bước X/7] Tự động cài đặt ứng dụng (qua WinGet hoặc file cài msi/exe)
# 6. [Bước X/7] Dọn dẹp tài nguyên hệ thống (xóa nhật ký Event Logs, dọn Panther/CoreSystem sau reboot)
# 7. [Bước X/7] Khôi phục ExecutionPolicy về RemoteSigned
```

:::tip
Đánh số `[1/7] ... [7/7]` kết hợp `Write-Host` màu sắc giúp bạn giám sát tiến độ dễ dàng. Quy ước: `Green` (OK), `Yellow` (Warning), `Red` (Error).
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
WinGet có thể chưa khởi tạo dịch vụ ngay sau đăng nhập. Profile `2.TweaksApp` đã tích hợp lệnh kích hoạt nguồn WinGet trước.
:::

### 3.4. Dọn dẹp nhật ký hệ thống và tự động xóa dữ liệu tạm thời

```powershell
Get-EventLog -LogName * -ErrorAction SilentlyContinue |
    ForEach-Object { Clear-EventLog -LogName $_.Log -ErrorAction SilentlyContinue }

# Xóa sạch thư mục Panther & CoreSystem trong phiên khởi động tiếp theo
$RunOnce = "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
Set-ItemProperty $RunOnce -Name "CleanupPanther"   -Value "cmd.exe /c rmdir /s /q C:\Windows\System32\Panther" -Force
Set-ItemProperty $RunOnce -Name "CleanupCoreSystem" -Value "cmd.exe /c rmdir /s /q C:\CoreSystem"             -Force
```

### 3.5. Khôi phục chính sách thực thi script

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
```

## 4. Nguyên tắc bảo mật (Security Guidelines)

:::danger
Script chạy dưới quyền Administrator và có toàn quyền truy cập mạng. Bạn cần tuân thủ nghiêm ngặt:

- Không lưu trữ mật khẩu, API Key dưới dạng rõ trong script.
- Chỉ tải file từ nguồn URL đáng tin cậy. Nên xác minh hash sau khi tải.
- Giữ nguyên lệnh `Unblock-File` trong `unattend.xml` để mở khóa script trước khi chạy.
- Luôn khôi phục `ExecutionPolicy` về `RemoteSigned` ở cuối script.
:::

## 5. Khuyến nghị vận hành và triển khai

- **Tùy biến nhanh:** Mọi thay đổi `Post-setup.ps1` trên USB **không cần build lại ứng dụng**. EASYDEPLOY đọc trực tiếp từ `EASYDEPLOY\Profiles\<TênProfile>\`. Bạn ghi đè file rồi boot lại để kiểm tra.
- **Profile mặc định:** Thay đổi profile mặc định (khi USB trống) thuộc **CoreSystem**. Đối tác IT/MSP chỉ quản lý profile riêng trên USB (xem [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/)).