---
title: 'Quy trình xây dựng Profile mới'
---

Tài liệu này cung cấp hướng dẫn từng bước (Step-by-step) để khởi tạo một Profile tùy biến cho cấu hình thiết bị mới hoặc khách hàng mới, đi kèm quy trình kiểm thử và xác thực an toàn.

## 1. Khởi tạo cấu trúc thư mục Profile

Trên thiết bị USB, tiến hành tạo thư mục mới nằm dưới đường dẫn `EASYDEPLOY\Profiles\`. Khuyến nghị áp dụng quy ước đánh số thứ tự ở đầu tên thư mục để danh sách hiển thị trên giao diện được sắp xếp khoa học:

```
[USB]:\EASYDEPLOY\Profiles\
├── 1.Tweaks          ← Profile có sẵn (chỉ tinh chỉnh hệ thống)
├── 2.TweaksApp       ← Profile có sẵn (tinh chỉnh + tự động cài ứng dụng)
└── 3.AcmeBank        ← Profile tùy biến mới của bạn
    ├── unattend.xml
    └── post-setup.ps1
```

:::danger
Profile **bắt buộc phải chứa đầy đủ bộ đôi tệp tin** `unattend.xml` và `post-setup.ps1`. Mặc dù cơ chế tích hợp (inject) có thể tự động sao chép và đổi tên các file khác, nhưng trình quét tự động của EASYDEPLOY chỉ nhận diện và hiển thị profile trong danh sách lựa chọn khi thư mục có **ít nhất một** trong hai tệp tin viết đúng tên tiêu chuẩn trên. Do đó, việc đặt chính xác tên tệp tin theo quy chuẩn là phương án vận hành an toàn nhất.
:::

## 2. Xây dựng tệp cấu hình `unattend.xml`

Phương thức nhanh nhất: Sử dụng công cụ trực tuyến [schneegans.de/windows/unattend-generator](https://schneegans.de/windows/unattend-generator/) để cấu hình các tham số theo tiêu chuẩn của doanh nghiệp (ví dụ: thông tin tài khoản, autologon, timezone, gỡ bỏ ứng dụng mặc định,...), tải tệp tin về máy trạm và thực hiện các bước sau:

1. Khởi chạy tệp tin bằng một trình soạn thảo mã nguồn (Code Editor).
2. Kiểm tra và đảm bảo phân hệ `FirstLogonCommands` thực thi gọi chính xác đường dẫn `C:\CoreSystem\Post-setup.ps1` (chi tiết tham khảo tại [unattend.xml](/easydeploy/profiles/unattend-xml/#23-cấu-hình-lệnh-thực-thi-trong-lần-đăng-nhập-đầu-tiên-firstlogoncommands)).
3. Thực hiện thay đổi hoặc mã hóa mật khẩu trong trường `PlainText` nếu tệp tin cấu hình này được phân phối hoặc chia sẻ giữa nhiều kỹ thuật viên.

:::tip
Mẹo: Quản trị viên nên sử dụng trực tiếp tệp tin `unattend.xml` có sẵn trong profile `1.Tweaks` làm mẫu cơ sở (baseline) để tùy biến, thay vì khởi tạo file mới từ đầu.
:::

## 3. Xây dựng kịch bản lệnh `post-setup.ps1`

Quản trị viên tiến hành mở rộng và phát triển kịch bản dựa trên file mẫu có sẵn (tham khảo hướng dẫn chi tiết tại [Post-setup.ps1](/easydeploy/profiles/post-setup-ps1/)):

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

Quản trị viên chỉ cần **sao chép thư mục profile mới trực tiếp vào USB** dưới đường dẫn `EASYDEPLOY\Profiles\` — tác vụ này hoàn toàn không yêu cầu biên dịch (build) lại tệp tin thực thi hệ thống.

## 5. Quy trình kiểm thử và Xác thực an toàn

Khuyến nghị thực hiện quy trình kiểm thử nghiêm ngặt sau đây trước khi áp dụng profile rộng rãi trên môi trường thực tế (production):

1. **Kiểm tra lỗi cú pháp script:** Chạy lệnh kiểm tra trong PowerShell:
   `[ScriptBlock]::Create((Get-Content .\post-setup.ps1 -Raw))` — nếu hệ thống không trả về cảnh báo lỗi thì cấu trúc cú pháp của script hoàn toàn hợp lệ.
2. **Kiểm thử trên môi trường máy ảo (Virtual Machine - VM):**
   - Khởi động máy ảo từ USB boot vào WinPE → Chọn chế độ triển khai **Business** (Phím **2**) → Lựa chọn profile mới vừa tạo → Nhấn **Deploy**.
   - Giám sát nhật ký hoạt động `[EASYDEPLOY][STEP x/11]` cho tới khi kết thúc tiến trình cài đặt và thiết bị khởi động lại.
   - Sau khi chuyển sang màn hình OOBE: Xác thực tính năng tự động tạo tài khoản, kiểm tra tính năng tự động đăng nhập, đảm bảo script `Post-setup.ps1` thực thi hoàn chỉnh và giao diện Desktop hiển thị đúng quy chuẩn thiết lập.
3. **Kiểm tra tính bền vững (Idempotent):** Thực hiện cài đặt lại thiết bị lần thứ hai bằng chính kịch bản trên để đảm bảo script hoạt động ổn định và không phát sinh lỗi khi chạy lại trên môi trường đã cấu hình sẵn.
4. **Thử nghiệm trên thiết bị vật lý thực tế:** Triển khai thử nghiệm 1 chu kỳ hoàn chỉnh trên một máy trạm vật lý trước khi áp dụng đại trà.

:::danger
Lưu ý: Khi thực hiện triển khai trên máy ảo, hệ thống sẽ tự động lọc và loại trừ các ổ đĩa ảo hoặc thiết bị USB boot khỏi danh sách ổ đĩa đích (deployable disks) để bảo vệ dữ liệu. Quản trị viên cần chọn chính xác ổ đĩa ảo tương ứng làm mục tiêu cài đặt. Toàn bộ dữ liệu hiện có trên ổ đĩa đích **sẽ bị xóa sạch hoàn toàn** trong quá trình chia lại phân vùng (partitioning).
:::

## 6. Bàn giao cấu hình triển khai

Sau khi Profile hoàn thành kiểm thử và đạt yêu cầu vận hành, quản trị viên tiến hành bàn giao cho đội ngũ kỹ thuật viên các tài nguyên sau:

- Thư mục chứa cấu hình profile (bao gồm tệp tin `unattend.xml` và kịch bản `post-setup.ps1`).
- Tệp tin cấu hình thiết lập `user-config.json` (đối với luồng Express: cập nhật thông số khóa `deploy.profile` trỏ sang tên thư mục profile mới).
- Tài liệu kỹ thuật đi kèm: Liệt kê danh sách ứng dụng yêu cầu kết nối Internet khi cài đặt, mật khẩu quản trị mặc định (nếu có), và ước lượng tổng thời gian thực thi của kịch bản.

## Danh mục kiểm tra (Checklist) xây dựng Profile

- [ ] Thư mục profile được đặt đúng vị trí dưới đường dẫn `EASYDEPLOY\Profiles\` trên USB (tên thư mục được đánh số thứ tự khoa học).
- [ ] Tệp tin `unattend.xml` chứa khai báo phân hệ FirstLogonCommands trỏ chính xác đến đường dẫn `C:\CoreSystem\Post-setup.ps1`.
- [ ] Kịch bản `post-setup.ps1` được tích hợp sẵn hàm kiểm tra và chờ kết nối Internet trước khi gọi các tác vụ tải file từ mạng.
- [ ] Đảm bảo không lưu trữ trực tiếp các thông tin nhạy cảm (như mật khẩu, API key,...) dưới dạng rõ (clear text) trong tệp tin.
- [ ] Kiểm chứng script có tính idempotent (thực thi lại nhiều lần không phát sinh xung đột hoặc lỗi hệ thống).
- [ ] Đã hoàn thành kiểm thử thành công: tối thiểu 2 chu kỳ trên máy ảo (VM) và 1 chu kỳ trên thiết bị vật lý thực tế.
- [ ] Tệp cấu hình `user-config.json` (phục vụ luồng Express) đã được khai báo chính xác tên thư mục profile mới.

:::danger
**Về Profile mặc định của hệ thống:** Bản cấu hình dự phòng mặc định (tự động áp dụng khi thiết bị USB trống không chứa profile) đáp ứng đầy đủ tiêu chuẩn vận hành thực tế tương đương gói `1.Tweaks` — do **CoreSystem** trực tiếp quản lý và cập nhật. Nếu doanh nghiệp có nhu cầu tùy biến bản cấu hình mặc định này, vui lòng gửi yêu cầu hỗ trợ tới CoreSystem. Đối với các profile tùy biến riêng của doanh nghiệp, bạn chỉ cần khởi tạo thư mục và sao chép trực tiếp vào USB theo hướng dẫn ở trên — **hoàn toàn không cần biên dịch (build) lại file thực thi .exe**.
:::
