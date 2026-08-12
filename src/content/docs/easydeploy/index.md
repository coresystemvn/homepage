---
title: 'EASYDEPLOY — Hướng dẫn sử dụng'
description: 'Tài liệu triển khai Windows và công cụ cứu hộ trên môi trường WinPE cho doanh nghiệp SMB/FDI và đối tác MSP.'
---

![EasyDeploy](/easydeploy/hero.webp)

:::note
Tài liệu này hướng dẫn chi tiết dành cho **đội ngũ IT Helpdesk, SysAdmin và các MSP** trong việc sử dụng bộ công cụ EASYDEPLOY chạy trên môi trường WinPE để triển khai (deploy) hệ điều hành Windows và thực hiện các tác vụ cứu hộ hệ thống.
**Xác định phân khúc người dùng:** Doanh nghiệp SMB/FDI (gói Free) sử dụng USB được cấu hình sẵn; các đối tác MSP (Standard/Advanced) được quyền tự xây dựng USB tùy biến (Whitebox) và truy cập Dashboard quản lý — chi tiết tham khảo [License Tiers](/easydeploy/msp/license-tiers/).
:::

**EASYDEPLOY** là giải pháp Windows Deployment hiện đại hoạt động trên môi trường **WinPE**, được phát triển bởi CoreSystem. Sau khi khởi động (boot) thiết bị từ USB vào WinPE, hệ thống sẽ tự động khởi chạy `easydeploy.exe`. Người dùng chỉ cần lựa chọn luồng triển khai mong muốn, công cụ sẽ tự động thực hiện quy trình cài đặt Windows khép kín (gồm 11 bước), đồng thời tích hợp sẵn các công cụ cứu hộ cơ bản để xử lý nhanh các sự cố hệ điều hành.

:::note
**Không cần tự xây dựng (build) bộ công cụ:** CoreSystem cung cấp sẵn các gói cài đặt thông qua liên kết tải về trực tiếp từ Cloud, bao gồm **`EasyDeploy.zip`** (chứa `easydeploy.exe` và `system-config.json`) và **`BootBuilder`** (chứa `EasyDeploy.BootBuilder.exe` và `links.md`). Bạn chỉ cần sử dụng BootBuilder để tạo file ISO, sau đó ghi (burn) ra USB bằng công cụ Rufus (khuyến nghị định dạng file system NTFS nếu file ESD lớn hơn 4GB). Xem chi tiết tại [Quick Start](/easydeploy/getting-started/quick-start/).
:::

## Bắt đầu nhanh

| Mục | Mô tả |
|-----|-------|
| [Quick Start](/easydeploy/getting-started/quick-start/) | Sử dụng USB WinPE sẵn có để boot và cài đặt Windows trong vòng 5 phút |
| [Các chế độ triển khai](/easydeploy/getting-started/deploy-modes/) | Vanilla / Business / Express (F3) — Hướng dẫn chọn chế độ cài đặt phù hợp |
| [Bộ công cụ Rescue](/easydeploy/getting-started/rescue-tools/) | Các giải pháp cứu hộ dữ liệu, sao lưu và chẩn đoán phần cứng |

## MSP & Quản lý (dành cho MSP Advanced)

| Mục | Mô tả |
|-----|-------|
| [MSP Overview](/easydeploy/msp/overview/) | Giới thiệu Web Dashboard, đăng nhập qua Cloudflare Access và phân quyền Admin/MSP/MBB |
| [License Tiers](/easydeploy/msp/license-tiers/) | Chi tiết các gói Free / MSP Standard / MSP Advanced và đặc quyền Whitebox |
| [Dashboard](/easydeploy/msp/dashboard/) | Hướng dẫn sử dụng các phân hệ: Overview, Tenants, Activations, Licenses, API Keys, USB, Alerts |
| [USB Management](/easydeploy/msp/usb-management/) | Quản lý vòng đời USB: Grace window, confirm/retire/restore, và cảnh báo clone burst |
| [Bắt đầu cho khách hàng](/easydeploy/msp/getting-started/) | Hướng dẫn điền thông tin vào `user-config.json` để triển khai thiết bị đầu tiên |
| [BootBuilder (Whitebox)](/easydeploy/msp/bootbuilder/) | Hướng dẫn tự dựng USB/ISO tùy biến thương hiệu dành cho đối tác MSP |

## Chuyên sâu — Tùy biến Profiles

| Mục | Mô tả |
|-----|-------|
| [Profiles Overview](/easydeploy/profiles/profiles/) | Khái niệm Profile, vị trí lưu trữ và cơ chế inject vào hệ điều hành Windows |
| [unattend.xml](/easydeploy/profiles/unattend-xml/) | Cấu hình tự động hóa Windows Setup / OOBE (tạo tài khoản, autologon, script chạy đầu tiên) |
| [Post-setup.ps1](/easydeploy/profiles/post-setup-ps1/) | Script chạy trong lần đăng nhập đầu tiên để tinh chỉnh hệ thống và cài đặt ứng dụng |
| [Tạo Profile mới](/easydeploy/profiles/creating-new-profile/) | Quy trình thiết lập và kiểm thử một Profile chuẩn cho thiết bị mới |

## Tham khảo

| Mục | Mô tả |
|-----|-------|
| [File cấu hình](/easydeploy/reference/configuration/) | Chi tiết các file cấu hình `system-config.json`, `user-config.json` và catalog `data.json` |
| [Phím tắt](/easydeploy/reference/keyboard-shortcuts/) | Danh mục phím tắt trên màn hình chính của WinPE |
| [Chế độ Offline](/easydeploy/reference/offline-mode/) | Quản lý license offline và cấu hình nguồn cài đặt ESD offline/hybrid |
| [Xử lý sự cố](/easydeploy/reference/troubleshooting/) | Tổng hợp lỗi thường gặp và các bước khắc phục |
| [Dữ liệu hệ thống ghi nhận (Telemetry)](/easydeploy/reference/telemetry/) | Chính sách ghi nhận Telemetry — cam kết không thu thập dữ liệu cá nhân hay license key |

## Tổng quan kiến trúc (tóm tắt)

```
Boot (BIOS/UEFI) → USB WinPE → easydeploy.exe (trong sources\boot.wim)
                                    │
        ┌───────────────────────────┼──────────────────────────────┐
        ▼                           ▼                              ▼
  Cài Windows                 Công cụ rescue                  (optional) Cloud
  11 bước engine              F1 BitLocker · F2 WiFi ·        Auth + license
  (100% tự động)              F4 Notepad · F5 Diskpart ·      Catalog data.json
                              F6 PowerShell · F7 Backup ·     Báo cáo OS params
                              F8 Explorer · F9 HWInfo ·
                              F10 Browser
```

- **Engine `EASYDEPLOY CLI`**: Bộ xử lý trung tâm hỗ trợ tự động hóa hoàn toàn quy trình cài đặt Windows chuẩn doanh nghiệp từ Cloud của Microsoft, đồng thời hỗ trợ linh hoạt các chế độ Hybrid và Offline.
  
- **Nguồn OS (Hệ điều hành)**: Hệ thống ưu tiên quét và sử dụng tệp tin `.esd` được đặt sẵn trên USB (`EASYDEPLOY\OS\` - phục vụ chế độ Offline hoặc Hybrid). Nếu không tìm thấy file cục bộ, engine sẽ tự động tải từ Catalog về qua internet (xác minh tính toàn vẹn bằng mã hash SHA-256). Danh sách và link tải các tệp tin ESD được cung cấp tại <https://esd.coresystem.vn>.
- **Profile (Cấu hình tùy biến sau cài đặt)**: Gồm bộ đôi tệp tin `unattend.xml` và `Post-setup.ps1` đặt trong thư mục `EASYDEPLOY\Profiles\<Tên_Profile>\`. Trong trường hợp không cấu hình profile cụ thể, hệ thống sẽ tự động áp dụng **Profile mặc định** (đáp ứng tiêu chuẩn vận hành thực tế - tương đương profile `1.Tweaks`). Chi tiết xem tại [Profiles Overview](/easydeploy/profiles/profiles/).
- **Công cụ cứu hộ**: Các phần mềm dạng Portable nằm tại thư mục `Softwares\` trên USB, được đóng gói sẵn thông qua công cụ EasyDeploy-BootBuilder.

## Liên hệ hỗ trợ

- Website chính thức: <https://www.coresystem.vn>
- MSP Dashboard: <https://msp.coresystem.vn> (Dành cho gói MSP Advanced)
- Kho tải file ESD (offline/hybrid): <https://esd.coresystem.vn>
- Bản quyền (License/Auth): Vui lòng liên hệ CoreSystem để đăng ký và nhận khóa API Key (dành cho chế độ Online) hoặc tệp tin License Offline.
