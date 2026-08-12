---
title: 'Tùy biến file cấu hình unattend.xml'
---

Tệp tin `unattend.xml` đóng vai trò là **tệp tin trả lời tự động (Answer File)** tiêu chuẩn của Windows Setup. EASYDEPLOY sẽ sao chép tệp tin này vào thư mục `C:\Windows\Panther\unattend.xml` trên phân vùng hệ điều hành đích sau khi giải nén. Do đó, các thiết lập cấu hình sẽ có hiệu lực **ngay trong lần khởi động đầu tiên** của thiết bị (trong giai đoạn cấu hình hệ thống ban đầu của Windows Setup, không phải giai đoạn cài đặt offline trên WinPE).

:::tip
Để đơn giản hóa việc khởi tạo cấu hình, quản trị viên có thể sử dụng công cụ sinh tự động [schneegans.de/windows/unattend-generator](https://schneegans.de/windows/unattend-generator/), sau đó tiến hành chỉnh sửa thủ công theo hướng dẫn bên dưới. Các profile mẫu đi kèm hệ thống cũng được thiết lập dựa trên công cụ này.
:::

## 1. Cấu trúc XML cơ bản

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <!-- Giai đoạn 1 (Pass 1): Cấu hình trước khi Windows hoàn tất cài đặt -->
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-International-Core-WinPE" …>
            <!-- Ngôn ngữ hệ thống, bàn phím, và múi giờ -->
        </component>
    </settings>

    <!-- Giai đoạn 2 (Pass 2): Specialize (Khởi tạo định danh thiết bị) -->
    <settings pass="specialize">
        <component name="Microsoft-Windows-Deployment" …>
            <RunSynchronous>
                <!-- Thực thi các lệnh đồng bộ trước khi vào màn hình OOBE -->
            </RunSynchronous>
        </component>
    </settings>

    <!-- Giai đoạn 3 (Pass 3): OobeSystem (Thiết lập màn hình OOBE ban đầu) -->
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
EASYDEPLOY chỉ đảm nhận vai trò sao chép tệp trả lời tự động vào thư mục `Panther` trên ổ đĩa trạm — các giai đoạn cấu hình (passes) khai báo trong file sẽ được xử lý hoàn toàn theo cơ chế chuẩn của Windows Setup. Không áp dụng bất kỳ giới hạn kỹ thuật đặc thù nào khác ngoài các quy chuẩn của Microsoft.

Tệp tin `unattend.xml` thuộc cấu trúc của Profile — vui lòng lưu ý **luôn duy trì đồng bộ cặp tệp tin cùng với `post-setup.ps1`** (mỗi profile hợp lệ bắt buộc phải có đầy đủ 2 tệp tin này, chi tiết xem tại [Profiles Overview](/easydeploy/profiles/profiles/)).
:::

## 2. Các phân hệ cấu hình phổ biến

### 2.1. Thiết lập tài khoản quản trị mặc định (`oobeSystem → UserAccounts`)

Tự động khởi tạo tài khoản người dùng cục bộ (Local Account) và phân quyền vào nhóm Administrator:

```xml
<UserAccounts>
    <LocalAccounts>
        <LocalAccount wcm:action="add">
            <Name>ProUser</Name>
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

### 2.2. Cấu hình tự động đăng nhập (AutoLogon)

Cơ chế này cho phép script `Post-setup.ps1` tự động thực thi sau cài đặt mà không yêu cầu kỹ thuật viên nhập thông tin đăng nhập thủ công:

```xml
<AutoLogon>
    <Enabled>true</Enabled>
    <Username>ProUser</Username>
    <LogonCount>1</LogonCount>
    <Password>
        <Value>to-strong-password</Value>
        <PlainText>true</PlainText>
    </Password>
</AutoLogon>
```

### 2.3. Cấu hình lệnh thực thi trong lần đăng nhập đầu tiên (FirstLogonCommands)

Đây là phân hệ để EASYDEPLOY liên kết và gọi kịch bản `Post-setup.ps1`. Đoạn cấu hình mẫu tiêu chuẩn (chạy script PowerShell và thực hiện lệnh `Unblock-File` để bỏ chặn script):

```xml
<FirstLogonCommands>
    <SynchronousCommand wcm:action="add">
        <Order>1</Order>
        <Description>Run CoreSystem post-setup</Description>
        <CommandLine>powershell.exe -ExecutionPolicy Bypass -Command "if (Test-Path 'C:\CoreSystem\Post-setup.ps1') { Unblock-File -Path 'C:\CoreSystem\Post-setup.ps1' -ErrorAction SilentlyContinue; & 'C:\CoreSystem\Post-setup.ps1' }"</CommandLine>
    </SynchronousCommand>
</FirstLogonCommands>
```

:::danger
Vui lòng giữ chính xác đường dẫn tệp tin mục tiêu là `C:\CoreSystem\Post-setup.ps1` — đây là đường dẫn cố định mà EASYDEPLOY sẽ sao chép script vào. Nếu thay đổi đường dẫn này không trùng khớp, script cài đặt sẽ không thể khởi chạy.
:::

### 2.4. Cấu hình các lệnh chạy đồng bộ trong giai đoạn Specialize (RunSynchronous)

Thực thi các dòng lệnh trước khi giao diện OOBE hiển thị — phù hợp cho việc tối ưu hóa hệ thống (như ghi đè registry, gỡ bỏ ứng dụng mặc định,...):

```xml
<RunSynchronous>
    <RunSynchronousCommand wcm:action="add">
        <Order>1</Order>
        <Path>reg add HKLM\SOFTWARE\Policies\Microsoft\Windows /v DisableAppSuggestions /t REG_DWORD /d 1 /f</Path>
    </RunSynchronousCommand>
</RunSynchronous>
```

## 3. Các tham số tùy biến hệ thống thường gặp

| Hạng mục tùy biến | Giai đoạn áp dụng (Pass) | Ghi chú kỹ thuật |
|-----|------|---------|
| Múi giờ & Ngôn ngữ | `windowsPE` | Ví dụ: múi giờ `SE Asia Standard Time`, ngôn ngữ hiển thị `en-us` |
| Tự động hóa màn hình OOBE | `oobeSystem → OOBE` | Cấu hình ẩn trang điều khoản `HideEULAPage`, đặt bảo mật `ProtectYourPC: 3`, bỏ qua OOBE cá nhân `SkipMachineOOBE`,... |
| Gỡ bỏ ứng dụng UWP mặc định | `specialize` / `oobeSystem` | Thực thi lệnh `Remove-AppxPackage` theo tên package |
| Bật đường dẫn dài & Xóa thư mục Windows.old | `specialize` | Kích hoạt registry `EnableLongPaths` và dọn dẹp thư mục backup cũ |
| Tắt mã hóa thiết bị tự động (BitLocker) | `oobeSystem` | Thiết lập `PreventDeviceEncryption: true` nhằm ngăn chặn cơ chế tự động mã hóa ổ đĩa |
| Cấu hình giao diện Explorer & Taskbar | `oobeSystem → Shell-Setup` | Khôi phục menu chuột phải cổ điển, căn lề trái thanh Taskbar,... |

## 4. Quy trình kiểm tra và xác thực

- **Xác thực cấu trúc dữ liệu:** Kiểm tra tính hợp lệ về cú pháp XML bằng Notepad hoặc các trình soạn thảo code chuyên dụng.
- **Xác thực phân hệ (Components):** Đảm bảo viết chính xác tên các giai đoạn (Pass) và thành phần (Component). Bất kỳ sai sót nào về định danh sẽ khiến hệ điều hành bỏ qua cấu hình đó mà không thông báo lỗi.
- **Thử nghiệm vận hành:** Luôn thực hiện cài đặt thử nghiệm kịch bản trên máy ảo trước khi đóng gói triển khai diện rộng (tham khảo [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/)).

## 5. Một số lưu ý quan trọng

:::danger
Thiết lập `<PlainText>true</PlainText>` sẽ ghi mật khẩu dưới dạng văn bản rõ (clear text) trong tệp tin XML. Mặc dù các tệp tin này lưu trữ trên USB và chỉ có kỹ thuật viên IT tiếp cận trong quá trình triển khai, quản trị viên vẫn nên lên kế hoạch yêu cầu người dùng thay đổi mật khẩu sau khi bàn giao thiết bị để đảm bảo tính an toàn tối đa.
:::

:::tip
Mọi thao tác chỉnh sửa tệp tin `unattend.xml` trong thư mục profile trên USB **không yêu cầu phải biên dịch (build) lại ứng dụng**. EASYDEPLOY sẽ đọc trực tiếp dữ liệu từ đường dẫn `EASYDEPLOY\Profiles\<TênProfile>\` khi khởi chạy. Bạn chỉ cần lưu đè file và thực hiện boot lại để áp dụng cấu hình mới.

Trong trường hợp muốn thay đổi cấu trúc của **Profile mặc định** (profile dự phòng của hệ thống khi USB trống), vui lòng **liên hệ và yêu cầu CoreSystem hỗ trợ**. Việc đóng gói và tích hợp profile mặc định vào file thực thi thuộc trách nhiệm của CoreSystem; đối tác IT/MSP chỉ quản lý và tùy biến các profile riêng biệt lưu trữ trực tiếp trên thiết bị USB (tham khảo thêm [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/)).
:::
