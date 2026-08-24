---
title: 'Quy trình xây dựng Profile mới'
---

Tài liệu này hướng dẫn từng bước khởi tạo Profile tùy biến cho thiết bị mới hoặc khách hàng mới, kèm quy trình kiểm thử và xác thực.

## 1. Khởi tạo cấu trúc thư mục Profile

Tạo thư mục mới trong `EASYDEPLOY\Profiles\` trên USB. Khuyến nghị đánh số đầu tên để danh sách sắp xếp khoa học:

```
[USB]:\EASYDEPLOY\Profiles\
├── 1.Tweaks          ← Profile có sẵn (chỉ tinh chỉnh hệ thống)
├── 2.TweaksApp       ← Profile có sẵn (tinh chỉnh + tự động cài ứng dụng)
└── 3.AcmeBank        ← Profile tùy biến mới của bạn
    ├── unattend.xml
    └── post-setup.ps1
```

:::caution
Profile bắt buộc chứa đủ 2 file `unattend.xml` và `post-setup.ps1`. EASYDEPLOY chỉ nhận diện profile khi thư mục có ít nhất một trong hai file đặt đúng tên tiêu chuẩn.
:::

## 2. Xây dựng tệp cấu hình `unattend.xml`

Cách nhanh nhất: Dùng [schneegans.de/windows/unattend-generator](https://schneegans.de/windows/unattend-generator/) để cấu hình tham số, tải về rồi:

1. Khởi chạy tệp tin bằng một trình soạn thảo mã nguồn.
2. Kiểm tra `FirstLogonCommands` gọi chính xác `C:\CoreSystem\Post-setup.ps1` (chi tiết tại [unattend.xml](/easydeploy/profiles/unattend-xml/#23-cấu-hình-lệnh-thực-thi-trong-lần-đăng-nhập-đầu-tiên-firstlogoncommands)).
3. Mã hóa mật khẩu trong trường `PlainText` nếu file được chia sẻ giữa nhiều kỹ thuật viên.

:::tip
Nên dùng `unattend.xml` trong profile `1.Tweaks` làm mẫu cơ sở để tùy biến, thay vì tạo mới từ đầu.
:::

## 3. Xây dựng kịch bản lệnh `post-setup.ps1`

Mở rộng kịch bản dựa trên file mẫu (xem hướng dẫn chi tiết tại [Post-setup.ps1](/easydeploy/profiles/post-setup-ps1/)):

```powershell
Write-Host "=== [CoreSystem] POST-SETUP: AcmeBank ===" -ForegroundColor Cyan
$GlobalTimeoutSec = 300
function Wait-ForInternet { … }            # Sử dụng hàm mẫu kiểm tra mạng
$HasInternet = Wait-ForInternet

# [Bước 1/5] Tự động cài đặt các ứng dụng tiêu chuẩn của AcmeBank
# [Bước 2/5] Áp dụng các cấu hình registry và local policy đặc thù
# [Bước 3/5] Tải hình nền doanh nghiệp và tạo file thông tin hỗ trợ Notes.txt
# [Bước 4/5] Dọn dẹp hệ thống (xóa log, cấu hình RunOnce dọn dẹp thư mục tạm)
# [Bước 5/5] Khôi phục chính sách bảo mật thực thi script ExecutionPolicy
Restart-Computer   # Tự động reboot thiết bị sau khi hoàn tất thiết lập
```

## 4. Triển khai tệp tin lên thiết bị USB

Chỉ cần **sao chép thư mục profile mới vào USB** tại `EASYDEPLOY\Profiles\` — không cần build lại file thực thi.

:::tip
Với **MSP Advanced** có nhu cầu bảo vệ profile (chứa nhiều tham số nhạy cảm), bạn có thể cân nhắc mã hóa trước khi bàn giao. Công cụ sẽ giữ lại bộ profile gốc để bạn tiếp tục tùy biến khi cần:

```powershell
.\encrypt-profile.ps1 -ProfilePath ".\EASYDEPLOY\Profiles\3.AcmeBank" -Passphrase "msp-secret-key"
.\encrypt-profile.ps1 -ProfilePath ".\EASYDEPLOY\Profiles\3.AcmeBank" -Generate
```

Sau đó gán key vào `system-config.json` (`profileEncryption.enabled` + `passphrase`) và build lại bằng BootBuilder — xem [Profiles — Tổng quan](/easydeploy/profiles/profiles/#7-mã-hóa-profile-chỉ-msp-advanced).
:::

## 5. Quy trình kiểm thử và Xác thực an toàn

Khuyến nghị quy trình kiểm thử sau trước khi áp dụng production:

1. **Kiểm tra lỗi cú pháp script:** Chạy lệnh kiểm tra trong PowerShell:
   `[ScriptBlock]::Create((Get-Content .\post-setup.ps1 -Raw))` — nếu hệ thống không trả về cảnh báo lỗi thì cấu trúc cú pháp của script hoàn toàn hợp lệ.
2. **Kiểm thử trên môi trường máy ảo:**
   - Khởi động máy ảo từ USB boot vào WinPE → Chọn chế độ triển khai **Business** (Phím **2**) → Lựa chọn profile mới vừa tạo → Nhấn **Deploy**.
   - Giám sát nhật ký hoạt động `[EASYDEPLOY][STEP x/11]` cho tới khi kết thúc tiến trình cài đặt và thiết bị khởi động lại.
   - Sau khi chuyển sang màn hình OOBE: Xác thực tính năng tự động tạo tài khoản, kiểm tra tính năng tự động đăng nhập, kiểm tra rằng script `Post-setup.ps1` thực thi hoàn chỉnh và giao diện Desktop hiển thị đúng quy chuẩn thiết lập.
3. **Kiểm tra tính bền vững:** Cài đặt lại thiết bị lần thứ hai bằng chính kịch bản trên để kiểm tra rằng script hoạt động ổn định và không phát sinh lỗi khi chạy lại trên môi trường đã cấu hình sẵn.
4. **Thử nghiệm trên thiết bị vật lý thực tế:** Triển khai thử nghiệm 1 chu kỳ hoàn chỉnh trên một máy trạm vật lý trước khi áp dụng đại trà.

:::danger
Khi triển khai trên máy ảo, hệ thống tự lọc loại trừ ổ ảo và USB boot khỏi danh sách đích để bảo vệ dữ liệu. Bạn cần chọn chính xác ổ ảo làm mục tiêu. Dữ liệu trên ổ đích **sẽ bị xóa sạch** trong quá trình partitioning.
:::

## 6. Bàn giao cấu hình triển khai

Sau khi Profile kiểm thử đạt yêu cầu, bàn giao các tài nguyên sau:

- Thư mục chứa cấu hình profile (bao gồm tệp tin `unattend.xml` và kịch bản `post-setup.ps1`).
- Tệp tin cấu hình thiết lập `user-config.json` (đối với luồng Express: cập nhật thông số khóa `deploy.profile` trỏ sang tên thư mục profile mới).
- Tài liệu kỹ thuật đi kèm: Liệt kê danh sách ứng dụng yêu cầu kết nối Internet khi cài đặt, mật khẩu quản trị mặc định (nếu có), và ước lượng tổng thời gian thực thi của kịch bản.

## Danh mục kiểm tra (Checklist) xây dựng Profile

- [ ] Thư mục profile được đặt đúng vị trí dưới đường dẫn `EASYDEPLOY\Profiles\` trên USB (tên thư mục được đánh số thứ tự khoa học).
- [ ] Tệp tin `unattend.xml` chứa khai báo phân hệ FirstLogonCommands trỏ chính xác đến đường dẫn `C:\CoreSystem\Post-setup.ps1`.
- [ ] Kịch bản `post-setup.ps1` được tích hợp sẵn hàm kiểm tra và chờ kết nối Internet trước khi gọi các tác vụ tải file từ mạng.
- [ ] Không lưu trữ trực tiếp các thông tin nhạy cảm (như mật khẩu, API key,...) dưới dạng rõ trong tệp tin — với MSP Advanced có thể cân nhắc mã hóa profile bằng `encrypt-profile.ps1`.
- [ ] Kiểm chứng script có tính idempotent (chạy lại nhiều lần không phát sinh xung đột hoặc lỗi hệ thống).
- [ ] Đã hoàn thành kiểm thử thành công: tối thiểu 2 chu kỳ trên máy ảo (VM) và 1 chu kỳ trên thiết bị vật lý thực tế.
- [ ] Tệp cấu hình `user-config.json` (phục vụ luồng Express) đã được khai báo chính xác tên thư mục profile mới.

:::caution
**Profile mặc định:** Bản dự phòng đáp ứng tiêu chuẩn vận hành tương đương `1.Tweaks` — do CoreSystem quản lý. Nếu cần tùy biến, liên hệ CoreSystem. Với profile riêng, bạn chỉ cần tạo thư mục và sao chép vào USB.
:::