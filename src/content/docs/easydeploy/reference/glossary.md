---
title: 'Bảng thuật ngữ (Glossary)'
---

Bảng giải thích các thuật ngữ thường gặp trong hệ thống EASYDEPLOY. Mục đích giúp bạn
đọc tài liệu nhanh và nhất quán. Thuật ngữ chuyên môn giữ nguyên bản tiếng Anh, kèm
giải thích tiếng Việt.

| Thuật ngữ | Giải thích |
|---|---|
| **EASYDEPLOY** | Bộ công cụ triển khai (deploy) Windows chạy trong môi trường WinPE, do CoreSystem phát triển. |
| **WinPE** | Môi trường Windows dùng để khởi động (boot) trước khi cài hệ điều hành. Khi bạn boot USB, WinPE được nạp và EASYDEPLOY tự chạy. |
| **USB boot media** | USB chứa môi trường WinPE + EASYDEPLOY + cấu hình, dùng để khởi động máy và triển khai. |
| **License / Offline License** | Bản quyền sử dụng, đóng gói trong file **`*.lic`** do CoreSystem cấp. Xác thực ngay tại máy, không cần internet. |
| **Gói dịch vụ (Tier)** | Phân loại bản quyền: **Trial** (dùng thử 30 ngày), **MSP Standard**, **MSP Advanced**. Quyết định tính năng được phép dùng. |
| **Trial** | Bản dùng thử 30 ngày — đầy đủ tính năng including Express (F3). Dành cho đối tác MSP muốn trải nghiệm trước khi mua. |
| **USB-SN** | Serial Number (số sê-ri) vật lý của USB — mã định danh duy nhất của mỗi thiết bị USB. |
| **Bind USB-SN** | Cơ chế **gắn bản quyền vào đúng USB**: license chỉ hoạt động trên USB đã được gắn — sao chép sang USB khác sẽ không dùng được. |
| **Clone Protection** | Bảo vệ chống sao chép: ngăn việc copy license/USB sang thiết bị khác dùng trái phép (nhờ Bind USB-SN). |
| **Re-key** | Cấp lại bản quyền khi USB mất/hỏng — liên hệ CoreSystem, thời hạn được giữ nguyên. |
| **Profile** | Bộ cấu hình tùy biến sau khi cài, gồm `unattend.xml` và `post-setup.ps1`. Giúp tự động hóa OOBE, cài app, tinh chỉnh hệ thống. |
| **OS Catalog (Catalog)** | Danh mục các bản Windows (build/edition/ngôn ngữ) hợp lệ để triển khai. EASYDEPLOY tải danh sách này và cho phép bạn chọn. |
| **ESD** | Định dạng file cài đặt Windows (`.esd`) — nguồn để EASYDEPLOY cài đặt hệ điều hành. |
| **OSCatalog (esd.coresystem.vn)** | Nền tảng catalog mặc định của CoreSystem — nơi EASYDEPLOY tải danh sách OS và nguồn ESD. |
| **Cloud catalog** | Catalog được tải từ internet (theo `catalog.url`). Khi không có mạng, hệ thống dùng **catalog nhúng** sẵn có. |
| **Catalog nhúng** | Danh sách OS được đóng gói sẵn trong chương trình — dùng khi không truy cập được catalog cloud. |
| **BYOC** (*) | Bring Your Own Catalog — **tự host catalog của riêng bạn** (trên cloud hoặc trong LAN). Hệ thống được thiết kế để dùng được; **(*)** yêu cầu kỹ năng quản trị hạ tầng phù hợp. Nằm ngoài phạm vi hỗ trợ của EASYDEPLOY. |
| **BYOB** (*) | Bring Your Own Backend — **tự host endpoint thu thập dữ liệu triển khai** (gói `Reference-Backend`), dành cho gói **MSP Advanced**. **(*)** yêu cầu kỹ năng quản trị hạ tầng phù hợp. Nằm ngoài phạm vi hỗ trợ của EASYDEPLOY. |
| **Reference-Backend** | Gói phần mềm + tài liệu để MSP Advanced tự host endpoint BYOB (Cloudflare Worker + D1 / Self-hosted Node + SQLite). |
| **Telemetry** | Thông tin kỹ thuật ghi nhận sau mỗi lần triển khai (hardware, OS, USB...). MSP Standard ghi **CSV trên USB**; Advanced gửi về **endpoint của bạn** (BYOB). CoreSystem không nhận dữ liệu. |
| **Express Deploy (F3)** | Chế độ triển khai tự động tối đa bằng một phím **F3** — đọc sẵn cấu hình, một xác nhận là chạy. |
| **Vanilla / Business** | Hai luồng triển khai chính: **Vanilla** (cài Windows gốc, không profile) và **Business** (có tích hợp profile doanh nghiệp). |
| **Rescue Tools** | Bộ công cụ cứu hộ tích hợp trong WinPE (BitLocker, WiFi, Diskpart, Explorer, ...) qua các phím F1–F10. |
| **Grace period** | Khoảng thời gian gia hạn ân hạn sau khi bản quyền hết hạn (14 ngày đối với bản trả phí). |
| **OOBE** | Out-of-Box Experience — màn hình thiết lập lần đầu của Windows sau khi cài xong. |
| **Zero Touch** | Boot USB → tự chạy **Express (F3)** không cần nhấn phím — bật `zeroTouch: true` trong `user-config.json`. Chỉ **MSP Advanced**, MSP tự chịu trách nhiệm; chỉ dùng trong môi trường có kiểm soát, không khuyến khích bật đại trà. |
| **Mã hóa Profile** | Bảo vệ profile (`unattend.xml` + `post-setup.ps1`) với preshared-key — cấu hình `profileEncryption` trong `system-config.json`, mã hóa bằng `encrypt-profile.ps1`. Chỉ **MSP Advanced**, công cụ giữ lại profile gốc để tái tùy biến. |
| **Passphrase** | Preshared-key cho mã hóa profile. Có thể tự đặt (`-Passphrase`) hoặc để tool tự sinh (`-Generate`, 32 bytes base64). |

> **(*)**: Các tính năng đánh dấu yêu cầu **kỹ năng quản trị hạ tầng phù hợp** (Linux/web
> server, mạng nội bộ) — phù hợp với đội ngũ MSP có năng lực, và **nằm ngoài phạm vi hỗ
> trợ của EASYDEPLOY**.