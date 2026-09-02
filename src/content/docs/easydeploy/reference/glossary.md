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
| **License / Offline License** | Bản quyền sử dụng, đóng gói trong file **`*.lic`** do CoreSystem cấp. Xác thực ngay tại máy, không cần internet. Áp dụng cho **MSP Advanced**; **Free** không cần license. |
| **Gói dịch vụ (Tier)** | Phân loại: **Free** (perpetual, 2 profiles, Cloud catalog) và **MSP Advanced** (annual, USB-SN batch, unlimited). |
| **Free** | Gói miễn phí vĩnh viễn — không cần license, 2 profiles (`1.Tweaks`/`2.TweaksApp`), Cloud catalog kèm fallback embedded. Đủ cho Solo-IT, Micro-MSP. |
| **MSP Advanced** | Gói annual theo lô USB-SN — unlimited profiles, Self-catalog, đầy đủ tính năng nâng cao. Hết hạn fallback về Free. |
| **USB-SN** | Serial Number (số sê-ri) vật lý của USB — mã định danh duy nhất của mỗi thiết bị USB. |
| **Bind USB-SN** | Cơ chế **gắn bản quyền vào đúng USB** (chỉ Advanced): license chỉ hoạt động trên USB đã được gắn. |
| **Clone Protection** | Bảo vệ chống sao chép: ngăn việc copy license/USB sang thiết bị khác dùng trái phép (nhờ Bind USB-SN). |
| **Re-key** | Cấp lại bản quyền khi USB mất/hỏng — liên hệ CoreSystem. |
| **Portable Apps (`Softwares\`)** | Ứng dụng cứu hộ do bạn tự cung cấp — **không đi kèm bộ phát hành**. Bổ sung qua BootBuilder (kỳ build) hoặc copy thủ công + `user-config.json`. Cấu hình mặc định tham chiếu 4 công cụ mẫu: MultiDrive, HWiNFO64, Explorer++, Pale Moon. Main window chỉ dành 4 nút quick-launch (footer tự điều chỉnh nhãn/phím theo cấu hình); số tool không giới hạn — gọi thêm qua F6 (PowerShell)/F8 (Explorer)/cmd. |
| **Profile** | Bộ cấu hình tùy biến sau khi cài, gồm `unattend.xml` và `post-setup.ps1`. Free có 2 profile mặc định; Advanced unlimited. |
| **OS Catalog (Catalog)** | Danh mục các bản Windows (build/edition/ngôn ngữ) hợp lệ để triển khai. |
| **ESD** | Định dạng file cài đặt Windows (`.esd`) — nguồn để EASYDEPLOY cài đặt hệ điều hành. |
| **OSCatalog (esd.coresystem.vn)** | Nền tảng catalog mặc định của CoreSystem — Free dùng cloud catalog (kèm fallback embedded); Advanced có thể Self-catalog. |
| **Cloud catalog** | Catalog được tải từ internet (theo `catalog.url`). Khi không có mạng, hệ thống dùng **catalog nhúng** sẵn có. |
| **Catalog nhúng** | Danh sách OS được đóng gói sẵn trong chương trình — dùng khi không truy cập được catalog cloud. |
| **Express Deploy (F3)** | Chế độ triển khai tự động bằng một phím **F3** — đọc sẵn cấu hình, một xác nhận là chạy. Có ở cả Free và Advanced. |
| **Vanilla / Business / Express / ZeroTouch** | Bốn phương pháp cài đặt do EasyDeploy điều phối: **Vanilla** (cài Windows gốc), **Business** (tích hợp profile doanh nghiệp), **Express** (F3 — tự động theo cấu hình), **ZeroTouch** (Advanced — boot USB là tự chạy). |
| **ZeroTouch** | Chế độ tự động hoàn toàn (chỉ **MSP Advanced**): Boot USB → tự chạy Express không cần bấm phím. Dành cho môi trường kiểm soát. |
| **BYOC** | *Bring Your Own Catalog* — MSP Advanced tự host catalog & ESD (kể cả trong LAN), chủ động nguồn cài đặt. |
| **BYOB** | *Bring Your Own Backend* — MSP Advanced tự host endpoint telemetry. CoreSystem cung cấp bộ **Reference-Backend** thiết kế sẵn để kết nối. |
| **Reference-Backend** | Gói thiết kế hạ tầng bổ trợ (Cloudflare Worker + D1 / Node + SQLite, kèm tài liệu production-ready) — cung cấp kèm `.lic` Advanced. Vận hành do MSP tự chủ; tính năng được kích hoạt qua license enforce ngay trong EasyDeploy. |
| **Rescue Tools** | Bộ công cụ cứu hộ tích hợp trong WinPE (BitLocker, WiFi, Diskpart, Explorer, ...) qua các phím tắt — F1, F2 và F4–F12 (F3 dành cho Express Deploy). |
| **Grace period** | Khoảng thời gian gia hạn ân hạn sau khi bản quyền hết hạn (14 ngày đối với Advanced). |
| **OOBE** | Out-of-Box Experience — màn hình thiết lập lần đầu của Windows sau khi cài xong. |
