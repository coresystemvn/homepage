---
title: 'Tùy biến file cấu hình unattend.xml'
---

Tệp tin `unattend.xml` là **Answer File** tiêu chuẩn của Windows Setup. EASYDEPLOY sao chép tệp này vào `C:\Windows\Panther\unattend.xml` trên phân vùng hệ điều hành đích. Các thiết lập có hiệu lực **ngay lần khởi động đầu tiên** (giai đoạn cấu hình hệ thống, không phải offline trên WinPE).

:::tip
Để đơn giản hóa, bạn có thể dùng công cụ sinh tự động [schneegans.de/windows/unattend-generator](https://schneegans.de/windows/unattend-generator/). Sau đó chỉnh sửa thủ công theo hướng dẫn bên dưới. Profile mẫu cũng được tạo dựa trên công cụ này.
:::

## 1. Cấu trúc XML cơ bản

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <!-- Giai đoạn 1 (Pass 1): windowsPE — Cấu hình trước khi Windows hoàn tất cài đặt -->
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" …>
            <!-- Ngôn ngữ hệ thống, bàn phím, và múi giờ -->
        </component>
    </settings>

    <!-- Giai đoạn 2 (Pass 2): Specialize — Khởi tạo định danh thiết bị -->
    <settings pass="specialize">
        <component name="Microsoft-Windows-Deployment" …>
            <RunSynchronous>
                <!-- Các lệnh đồng bộ trước khi vào OOBE -->
            </RunSynchronous>
        </component>
    </settings>

    <!-- Giai đoạn 3 (Pass 3): oobeSystem — Thiết lập màn hình OOBE ban đầu -->
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" …>
            <UserAccounts>…</UserAccounts>
            <AutoLogon>…</AutoLogon>
            <OOBE>…</OOBE>
            <FirstLogonCommands>…</FirstLogonCommands>
        </component>
    </settings>
</unattend>
```

:::note
EASYDEPLOY chỉ sao chép tệp trả lời tự động vào thư mục `Panther`. Các giai đoạn cấu hình được xử lý theo cơ chế chuẩn của Windows Setup.

`unattend.xml` thuộc cấu trúc Profile. Bạn luôn duy trì đồng bộ cặp tệp tin cùng với `post-setup.ps1`.
:::

## 2. Các phân hệ cấu hình phổ biến

### 2.1. Thiết lập tài khoản quản trị mặc định (`oobeSystem → UserAccounts`)

Tự động khởi tạo tài khoản người dùng cục bộ và phân quyền nhóm Administrator:

```xml
<UserAccounts>
    <LocalAccounts>
        <LocalAccount wcm:action="add">
            <Name>ITAdmin</Name>
            <DisplayName>Administrator</DisplayName>
            <Group>Administrators</Group>
            <Password>
                <Value>to-strong-password</Value>
                <PlainText>true</PlainText>
            </Password>
        </LocalAccount>
    </LocalAccounts>
</UserAccounts>
```

### 2.2. Cấu hình tự động đăng nhập

Cho phép script `Post-setup.ps1` tự động chạy sau cài đặt mà không cần nhập thông tin đăng nhập:

```xml
<AutoLogon>
    <Enabled>true</Enabled>
    <Username>ITAdmin</Username>
    <LogonCount>1</LogonCount>
    <Password>
        <Value>to-strong-password</Value>
        <PlainText>true</PlainText>
    </Password>
</AutoLogon>
```

### 2.3. Lệnh thực thi trong lần đăng nhập đầu tiên

Phân hệ để EASYDEPLOY gọi `Post-setup.ps1`. Cấu hình mẫu chạy script PowerShell và bỏ chặn script:

```xml
<FirstLogonCommands>
    <SynchronousCommand wcm:action="add">
        <Order>1</Order>
        <Description>Run CoreSystem post-setup</Description>
        <CommandLine>powershell.exe -ExecutionPolicy Bypass -Command "if (Test-Path 'C:\CoreSystem\Post-setup.ps1') { Unblock-File -Path 'C:\CoreSystem\Post-setup.ps1' -ErrorAction SilentlyContinue; & 'C:\CoreSystem\Post-setup.ps1' }"</CommandLine>
    </SynchronousCommand>
</FirstLogonCommands>
```

:::caution
Giữ chính xác đường dẫn `C:\CoreSystem\Post-setup.ps1`. Đây là đường dẫn cố định mà EASYDEPLOY sao chép script vào. Nếu thay đổi, script sẽ không thể khởi chạy.
:::

### 2.4. Lệnh chạy đồng bộ trong giai đoạn Specialize

Thực thi lệnh trước khi OOBE hiển thị. Phù hợp tối ưu hóa hệ thống (ghi đè registry, gỡ bỏ ứng dụng mặc định...):

```xml
<RunSynchronous>
    <RunSynchronousCommand wcm:action="add">
        <Order>1</Order>
        <Path>reg add HKLM\SOFTWARE\Policies\Microsoft\Windows /v DisableAppSuggestions /t REG_DWORD /d 1 /f</Path>
    </RunSynchronousCommand>
</RunSynchronous>
```

## 3. Các tham số tùy biến hệ thống thường gặp

| Hạng mục tùy biến | Giai đoạn | Ghi chú |
|-----|------|---------|
| Múi giờ & Ngôn ngữ | `windowsPE` | Ví dụ: múi giờ `SE Asia Standard Time`, ngôn ngữ hiển thị `en-us` |
| Tự động hóa OOBE | `oobeSystem → OOBE` | ẩn EULA `HideEULAPage`, bảo mật `ProtectYourPC: 3`, bỏ qua OOBE `SkipMachineOOBE`... |
| Gỡ bỏ ứng dụng UWP | `specialize` / `oobeSystem` | Lệnh `Remove-AppxPackage` theo tên package |
| Bật đường dẫn dài & Xóa Windows.old | `specialize` | Registry `EnableLongPaths` và dọn thư mục backup cũ |
| Tắt BitLocker tự động | `oobeSystem` | `PreventDeviceEncryption: true` — ngăn mã hóa ổ đĩa tự động |
| Explorer & Taskbar | `oobeSystem → Shell-Setup` | Khôi phục menu chuột phải cổ điển, căn lề trái Taskbar... |

## 4. Quy trình kiểm tra và xác thực

- **Cấu trúc dữ liệu:** Kiểm tra cú pháp XML bằng Notepad hoặc trình soạn thảo code chuyên dụng.
- **Phân hệ:** Viết chính xác tên Pass và Component. Sai sót định danh sẽ khiến hệ điều hành bỏ qua cấu hình mà không báo lỗi.
- **Thử nghiệm:** Cài đặt thử trên máy ảo trước khi triển khai diện rộng (tham khảo [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/)).

## 5. Một số lưu ý quan trọng

:::danger
`<PlainText>true</PlainText>` ghi mật khẩu dưới dạng rõ trong XML. File chỉ lưu trên USB và tiếp cận bởi IT. Bạn nên yêu cầu người dùng thay đổi mật khẩu sau khi bàn giao thiết bị.
:::

:::tip
Mọi thao tác chỉnh sửa `unattend.xml` trên USB không cần build lại ứng dụng. EASYDEPLOY đọc trực tiếp từ `EASYDEPLOY\Profiles\<TênProfile>\`. Lưu đè file rồi boot lại là áp dụng cấu hình mới.

Nếu muốn thay đổi Profile mặc định, liên hệ CoreSystem. Đối tác IT/MSP chỉ quản lý các profile riêng trên USB.
:::