---
title: 'Quản lý thiết bị USB (USB Management)'
---

Phân hệ Quản lý thiết bị USB cho phép quản trị viên theo dõi và điều phối toàn bộ vòng đời của các thiết bị USB triển khai thông qua Dashboard: từ quản lý USB mới (grace window), phê duyệt (confirm/allowlist), thu hồi (retire), khôi phục (restore) cho đến xử lý các cảnh báo bảo mật sao chép (clone alert). Tính năng này khả dụng riêng cho gói dịch vụ **MSP Advanced**.

## 1. Định nghĩa USB như tài sản doanh nghiệp

Đối với đối tác MSP, thiết bị USB tích hợp giải pháp EASYDEPLOY là **tài sản số quan trọng cần được bảo mật và quản lý nghiêm ngặt**, bởi vì mỗi USB đều chứa các cấu hình hệ thống (Profiles) cùng thông tin bản quyền (License) riêng của MSP đó. Việc thất thoát thiết bị USB sẽ dẫn đến các rủi ro sau:

| Rủi ro | Hệ quả |
|--------|--------|
| **Thất thoát thiết bị (Mất USB)** | Hệ thống vẫn tiếp tục ghi nhận và trừ số lượng cài đặt (slots) khi USB đó được sử dụng trên máy trạm, dẫn đến hao hụt license mà không phát sinh doanh thu thực tế. |
| **Rò rỉ cấu hình (Profiles bị lộ)** | Làm lộ các kịch bản thiết lập hệ thống tối ưu và các script tự động hóa — gây mất lợi thế cạnh tranh thương mại hoặc có nguy cơ bị khai thác thông tin nhạy cảm. |
| **Sao chép trái phép (USB bị clone)** | Các bản sao chép vô hạn có thể sử dụng chung thông tin license và profile của bạn trên các hệ thống khác mà bạn không thể kiểm soát hay thu phí. |

:::note
Do đó, **mỗi thiết bị USB triển khai cần được quản lý chặt chẽ tương tự như các tài sản vật lý có giá trị**: cần ghi nhận kỹ thuật viên phụ trách, theo dõi lịch sử phát hành và kiểm soát tức thời khi phát hiện các thiết bị lạ truy cập hệ thống.
:::

:::note
**Triết lý vận hành của hệ thống:** CoreSystem **không thiết lập cơ chế khóa cứng (block cứng)** nhằm đảm bảo tính linh hoạt tối đa cho quy trình vận hành riêng biệt của từng doanh nghiệp (ví dụ như việc kỹ thuật viên tự mua thêm hoặc thay thế USB mới khi làm việc). Hệ thống đóng vai trò **giám sát và hỗ trợ ra quyết định**: cung cấp thông tin trực quan về các USB đang hoạt động, gửi cảnh báo tức thời khi phát hiện hành vi bất thường, và giao quyền quyết định Phê duyệt (Confirm) hoặc Thu hồi (Retire) cho bạn. Quyết định cuối cùng luôn thuộc về quản trị viên của doanh nghiệp.
:::

:::note
**Cơ chế phát hiện sao chép (Clone Detection):** Khi thực hiện sao chép (copy) dữ liệu từ USB gốc sang một USB khác, mã định danh phần cứng duy nhất (Hardware Serial Number) của USB gốc **không thể bị sao chép theo**. Thiết bị USB được clone sẽ luôn mang một mã Serial Number vật lý hoàn toàn khác. Do đó, **sự xuất hiện của một Serial Number mới hoạt động trên cùng cấu hình chính là dấu hiệu nghi ngờ sao chép**. Thông qua cơ chế đồng bộ telemetry luôn bật, hệ thống sẽ tự động ghi nhận mã Serial Number của thiết bị USB được sử dụng trong mỗi phiên triển khai.
:::

## 2. Các trạng thái của thiết bị USB

| Trạng thái | Mô tả |
|-----------|-------|
| `new` (Mới) | Mã Serial Number lần đầu xuất hiện trên hệ thống và chưa được phê duyệt. Thiết bị được phép triển khai tự do trong thời gian ân hạn (Grace Window). |
| `confirmed` (Đã phê duyệt) | Thiết bị đã được quản trị viên xác nhận và đưa vào danh sách trắng vĩnh viễn (Allowlist) — không giới hạn thời gian sử dụng. |
| `retired` (Đã thu hồi) | Thiết bị USB được đánh dấu hỏng hoặc ngừng sử dụng — hệ thống sẽ loại trừ thiết bị này khỏi các thuật toán kiểm tra clone burst hoặc tính toán thời gian ân hạn để tránh cảnh báo giả. |

## 3. Thời gian ân hạn (Grace Window) cho thiết bị mới

Mỗi thiết bị USB ở trạng thái `new` được quyền triển khai cài đặt tự do trong vòng **đúng 7 ngày** kể từ phiên hoạt động đầu tiên. Sau thời gian này, nếu USB chưa được quản trị viên Phê duyệt (Confirm), hệ thống sẽ **ngăn chặn** mọi phiên cài đặt tiếp theo và hiển thị thông báo lỗi trực quan:

> **"USB not approved. Contact your MSP to confirm this USB drive."**

:::note
**Thời gian ân hạn 7 ngày là cấu hình mặc định** được thiết lập trực tiếp trên hệ thống backend của CoreSystem. Quản trị viên không thể tự thay đổi thông số này qua giao diện Dashboard. 
:::

```
Phát hiện USB mới (new) → Kích hoạt 7 ngày ân hạn (Grace Window)
                                  │
                                  ▼ (Hết hạn 7 ngày, chưa Confirm)
Ngăn chặn triển khai (Block) → Yêu cầu Phê duyệt (Confirm) hoặc Thu hồi (Retire)
```

## 4. Quy trình quản lý vòng đời USB

| Bước | Thao tác quản trị | Kết quả kỹ thuật |
|------|----------|---------|
| Kết nối USB mới để triển khai | Hệ thống tự động quét và ghi nhận Serial Number vật lý → Gán trạng thái và hiển thị badge **NEW** | Kích hoạt thời gian ân hạn 7 ngày dùng tự do. |
| Phê duyệt thiết bị hợp lệ | Quản trị viên nhấn **Confirm** | Thiết bị chuyển sang trạng thái `confirmed` vĩnh viễn, loại bỏ hoàn toàn các rào cản ngăn chặn. |
| Thiết bị hỏng hoặc ngừng sử dụng | Quản trị viên nhấn **Retire** | Thiết bị chuyển sang trạng thái `retired` — hệ thống loại trừ khỏi các thuật toán giám sát nhằm tránh phát sinh cảnh báo giả. |
| Tái sử dụng thiết bị đã thu hồi | Hệ thống tự động nhận diện khi thiết bị hoạt động trở lại | Thiết bị tự động chuyển về trạng thái `new` + khôi phục thời gian ân hạn + kích hoạt cảnh báo `usb_retired_reused`. |

:::danger
**Hệ thống không thiết kế tính năng Xóa (Delete) thiết bị USB.** Hai thao tác **Retire** (Thu hồi) và **Confirm** (Phê duyệt) đã bao quát toàn bộ các kịch bản vận hành thực tế. Thiết bị ở trạng thái `retired` sẽ không được tính toán trong các cơ chế phát hiện clone burst hoặc thời gian ân hạn nhằm loại bỏ hoàn toàn các cảnh báo giả.
:::

## 5. Cơ chế phát hiện sao chép hàng loạt (Clone Burst Alert)

Hệ thống tự động theo dõi số lượng Serial Number mới phát sinh vượt ngoài baseline đăng ký của doanh nghiệp trong một khoảng thời gian nhất định (cơ chế chỉ đếm số lượng Serial Number khác nhau, việc một USB hợp lệ cài đặt cho nhiều thiết bị khác nhau là hành vi bình thường và không kích hoạt cảnh báo).

| Điều kiện giám sát (trong chu kỳ 24h) | Kết quả xử lý |
|-----------------------|---------|
| Phát hiện < 3 Serial mới | Giao diện hiển thị trạng thái "unconfirmed" (chưa phê duyệt) trên trang quản lý USB (không gửi thông báo qua email). |
| Phát hiện từ 3 Serial mới trở lên (mỗi USB cài đặt ≥ 2 máy) | Kích hoạt cảnh báo `usb_burst` ở mức độ **Warning** + Gửi email thông báo cho quản trị viên. |
| Phát hiện từ 8 Serial mới trở lên | Kích hoạt cảnh báo `usb_burst` ở mức độ nguy hiểm **Critical** — Hiển thị băng rôn đỏ cảnh báo (Red Banner) trên Dashboard + Gửi email khẩn cấp cho quản trị viên. |

:::note
**Các ngưỡng thông số kỹ thuật trên** (chu kỳ giám sát 24 giờ, ngưỡng số lượng 3 hoặc 8 USB mới, và tần suất cài đặt tối thiểu 2 máy/USB) **là cấu hình mặc định** trên backend của CoreSystem. Quản trị viên không thể tự tùy chỉnh qua Dashboard. 

*Lưu ý về thiết kế:* Quy trình triển khai thực tế số lượng lớn (mass deployment lên tới 50 máy/ngày) thông thường cũng chỉ sử dụng từ 3 đến 5 thiết bị USB boot đã được phê duyệt (đã có baseline), do đó sẽ không phát sinh cảnh báo. Các Serial Number mới chỉ xuất hiện khi doanh nghiệp trang bị thêm USB mới (tần suất thấp 1-2 thiết bị → chỉ hiển thị badge) hoặc khi xảy ra sự cố sao chép trái phép (tần suất cao từ 3 thiết bị trở lên → kích hoạt cảnh báo).
:::

## 6. Kịch bản và Quy trình xử lý

### Kịch bản 1: Phê duyệt thiết bị USB mới mua/trang bị thêm
1. Truy cập phân hệ **USB Devices** hoặc **Alerts** → Phát hiện thiết bị có nhãn **NEW** hoặc nằm trong cảnh báo `usb_burst`.
2. Quản trị viên xác minh thiết bị vật lý do kỹ thuật viên thuộc đơn vị mình sử dụng → Nhấn **Confirm** để đưa vào danh sách trắng vĩnh viễn (Allowlist).
3. Từ giao diện cảnh báo, có thể sử dụng tính năng **Confirm Serial** để phê duyệt nhanh.

### Kịch bản 2: Thiết bị USB bị chặn hoạt động do hết thời gian ân hạn
1. Kỹ thuật viên báo lỗi thiết bị hiển thị thông báo "USB not approved" → Quản trị viên truy cập **USB Devices** và tìm kiếm theo mã Serial Number tương ứng.
2. Chọn **Confirm** để phê duyệt nếu xác định USB an toàn và tiếp tục sử dụng; hoặc chọn **Retire** để thu hồi nếu thiết bị đã bị hỏng hoặc thất thoát.

### Kịch bản 3: Tái sử dụng thiết bị USB đã bị thu hồi trước đó
1. Khi cắm và triển khai bằng một USB đã nằm ở trạng thái `retired`, hệ thống sẽ tự động phát hiện.
2. Hệ thống tự động chuyển trạng thái USB về `new`, khôi phục thời gian ân hạn mới và tạo cảnh báo `usb_retired_reused` ở mức độ **Warning**.
3. Quản trị viên tiến hành kiểm tra: Nhấn **Confirm** nếu muốn tái kích hoạt thiết bị để sử dụng tiếp, hoặc nhấn **Retire** để đưa thiết bị trở lại trạng thái thu hồi.

### Kịch bản 4: Nghi ngờ thiết bị USB bị sao chép trái phép hoặc thất thoát dữ liệu
1. Truy cập phân hệ **USB Devices** hoặc **Alerts** → Phát hiện cảnh báo `usb_burst` đạt hoặc vượt ngưỡng cho phép.
2. Tuyệt đối không thực hiện Phê duyệt (Confirm) đối với các mã Serial Number lạ không rõ nguồn gốc. Nếu xác định có hiện tượng thất thoát tài nguyên hoặc rò rỉ dữ liệu, MSP nên reset API key trong dashboard để đảm bảo an toàn.

## 7. Một số lưu ý quan trọng

- **Tránh trùng lặp cảnh báo:** Hệ thống sẽ không tạo thêm các cảnh báo trùng lặp nếu cảnh báo `usb_burst` hoặc `usb_retired_reused` trước đó của tenant vẫn đang ở trạng thái mở (Open).
- **Địa chỉ nhận thông báo:** Mọi cảnh báo bảo mật và báo cáo hoạt động sẽ được gửi trực tiếp đến địa chỉ email đăng ký chính thức của doanh nghiệp trên hệ thống CoreSystem.
