---
title: 'Các gói dịch vụ và Phân quyền (License Tiers)'
---

EASYDEPLOY cung cấp các gói dịch vụ (License Tiers) cho đối tác MSP. Bản quyền được
đóng gói trong file **`*.lic`** (chữ ký ECDSA, bind USB-SN, kèm trường `Tier`) do CoreSystem
cấp — client tự xác thực ngay tại máy.

| Tier | Đối tượng | Thời hạn | Express (F3) | Whitebox | Telemetry |
|------|-----------|:--------:|:---:|:---:|------|
| **Trial** | MSP dùng thử | **30 ngày** | ✅ | — | CSV trên USB |
| **MSP Standard** | Nhà cung cấp dịch vụ | Theo hợp đồng | ✅ | ✅ | CSV trên USB |
| **MSP Advanced** | MSP lớn, tự chủ dữ liệu | Theo hợp đồng | ✅ | ✅ | **BYOB** |

:::note
Tính năng của từng gói được quyết định bởi thông tin gói trong license đã ký số — chỉ
hoạt động với license gói đó, không thể đổi gói bằng cách sửa file hay cấu hình.
:::

## 0. Gói Trial — Dùng thử 30 ngày

Trial là cánh cửa để bạn trải nghiệm toàn bộ sức mạnh EASYDEPLOY trước khi quyết định đầu tư.

- **Đối tượng:** Đối tác MSP muốn dùng thử trước khi quyết định mua.
- **License:** `Tier=trial` — **30 ngày**, bind 1 USB-SN, **không gia hạn tự động**.
- **Express (F3):** ✅ **Có đầy đủ** — trải nghiệm deploy hàng loạt bằng F3.
- **Whitebox:** Không — dùng USB/ISO tiêu chuẩn do CoreSystem phát hành.
- **OSCatalog:** Dùng ISO/Catalog chung do CoreSystem phát hành.
- **Telemetry:** CSV trên USB.

### Quy trình kích hoạt Trial

```
Truy cập coresystem.vn → click Trial → nhập email chính xác để nhận link tải file iso
        │
        ▼
Ghi ra USB bằng Rufus (NTFS nếu ESD > 4GB)
        │
        ▼
Boot USB vào WinPE
        │
        ▼
Bấm luồng cài bất kỳ → Request License Trial
        │
        ▼
Hệ thống tự động cung cấp license và lưu vào [USB:]\EASYDEPLOY
        │
        ▼
SẴN SÀNG SỬ DỤNG — 30 ngày không giới hạn tính năng
```

:::tip
Trial cho phép trải nghiệm đầy đủ tính năng: Express (F3), Business (2), tất cả rescue tools, profiles. Sau 30 ngày, liên hệ CoreSystem để upgrade lên gói phù hợp.
:::

## 1. Gói MSP Standard

Gói Standard dành cho MSP muốn bắt đầu quản trị khách hàng với quyền tùy biến USB/ISO và tự chủ nguồn catalog.

- **Đối tượng:** Nhà cung cấp dịch vụ quản trị (MSP).
- **Whitebox:** ✅ Được phép tự dựng USB/ISO tùy biến thương hiệu bằng **BootBuilder**
  (xem [BootBuilder](/easydeploy/msp/bootbuilder/)).
- **OSCatalog:** Được quyền **tự chủ nguồn catalog** (bật `cloudCatalog:true` + trỏ
  `catalog.url` về host của bạn). **Gói thiết kế kỹ thuật (technical design package)**
  sẽ được CoreSystem bổ sung kèm hướng dẫn triển khai.
- **Telemetry:** **CSV trên USB** — không gửi lên máy chủ (dữ liệu nằm tại USB của bạn).

## 2. Gói MSP Advanced

MSP Advanced bổ sung khả năng tự chủ dữ liệu hoàn toàn, phù hợp MSP lớn muốn kiểm soát toàn bộ hạ tầng telemetry.

- Thừa hưởng toàn bộ quyền lợi MSP Standard, đồng thời **bổ sung BYOB telemetry**, **Zero Touch** (Boot USB → done) và **Mã hóa Profile**:

| Quyền lợi | Mô tả |
|-----------|-------|
| **BYOB Telemetry** | Dữ liệu triển khai (hardware, OS, USB, machine_id, IP public) gửi về **endpoint do bạn tự cấu hình** trong `system-config.json` (block `telemetry`: `enabled` + `endpoint` + `apiKey`). |
| **Reference-Backend + tài liệu production-ready** | Nhận gói `Reference-Backend` (Cloudflare Worker + D1 / Self-hosted Node + SQLite, install script + docker-compose + hardening) và tài liệu thiết kế production-ready để tự vận hành. |
| **Tự chủ dữ liệu** | Dữ liệu nằm hoàn toàn trong hạ tầng của bạn; xuất/thống kê/dashboard tuỳ ý (tham khảo `Dashboard-ref-stack`). |
| **OSCatalog tự chủ** | Như MSP Standard: được quyền tự host nguồn catalog, kèm **gói thiết kế kỹ thuật** do CoreSystem bổ sung. |
| **Mã hóa Profile** | Bảo vệ toàn bộ profile (`unattend.xml` + `post-setup.ps1`) với preshared-key. Cấu hình `profileEncryption` trong `system-config.json` và mã hóa bằng `encrypt-profile.ps1` — xem [Profiles](/easydeploy/profiles/profiles/). |

:::note
**Nguồn OS Catalog:** Gói Trial dùng Catalog chung, gói MSP Standard/Advanced được quyền
tự chủ nguồn catalog (BYOC). Nếu chưa muốn tự host, mọi gói đều dùng `https://esd.coresystem.vn`.
:::

## Nguyên tắc ghi nhận USB-SN — bảo vệ tài sản của MSP

USB boot là tài sản triển khai của đối tác MSP, mỗi USB mang bản quyền riêng và chính là "công cụ" tạo ra doanh thu. EASYDEPLOY ghi nhận USB-SN theo nguyên tắc sau:

- **Mỗi USB = một thẻ triển khai.** License được bind vào USB-SN cụ thể, nên một USB
  chỉ triển khai được khi chính nó được sử dụng — giúp bạn biết chính xác USB nào đang
  hoạt động, triển khai cho thiết bị nào.
- **Chống sao chép (clone).** Nếu USB bị copy sang thiết bị khác, license sẽ không hoạt
  động (USB-SN không khớp) — hạn chế tình trạng bản quyền bị dùng trái phép làm ảnh
  hưởng doanh thu của bạn.
- **Theo dõi thất thoát.** Với dữ liệu USB-SN ghi lại trong từng phiên (CSV trên USB
  hoặc endpoint BYOB), bạn dễ dàng đối soát: USB nào chưa hoạt động, USB nào có dấu
  hiệu mất/thất lạc — từ đó kịp thời liên hệ CoreSystem để khóa/cấp lại, tránh ảnh
  hưởng đến doanh thu và uy tín dịch vụ.
- **Tôn trọng quyền riêng tư.** Dữ liệu USB-SN chỉ nằm tại USB của bạn (CSV) hoặc
  endpoint do bạn cấu hình — **CoreSystem không nhận và không lưu trữ** dữ liệu này
  (xem [Telemetry](/easydeploy/reference/telemetry/)).

:::note
**Chất lượng USB ảnh hưởng đến ghi nhận bản quyền:** bản quyền được gắn với số sê-ri
(SN) của USB. Một số USB giá rẻ có thể không có SN chuẩn hoặc trùng SN giữa các ổ —
khi đó license có thể không ghi nhận đúng. Với công việc triển khai, bạn nên dùng USB có
thương hiệu, chip firmware ổn định, tốc độ cao — vừa nhận diện chính xác, vừa rút ngắn
thời gian cài đặt.
:::

:::tip
Lưu trữ an toàn USB boot và chỉ giao cho nhân viên được uỷ quyền.
:::

## Tính năng nâng cao — giới thiệu sơ qua

Các tính năng tự chủ giúp MSP làm chủ hạ tầng khi doanh nghiệp phát triển.

- **Chống sao chép USB (Clone Protection)** — có sẵn ở mọi gói, không cần cấu hình: bản
  quyền được gắn với đúng USB (bind USB-SN), nên việc sao chép USB hay license sang thiết
  bị khác sẽ không hoạt động. Đây là lớp bảo vệ tài sản của bạn (xem mục USB-SN ở trên).
- **Tự chủ nguồn OS Catalog (BYOC) (*)** — bạn tự host danh mục OS và nguồn file cài đặt
  theo ý mình (trên cloud hoặc trong LAN), giảm phụ thuộc internet khi triển khai hàng
  loạt. Phù hợp với đội ngũ có khả năng vận hành web server. Xem gói công cụ OSCatalog
  dành cho MSP + [Bảng thuật ngữ](/easydeploy/reference/glossary/).
- **Tự chủ dữ liệu triển khai (BYOB) (*)** — dành cho **MSP Advanced**: dữ liệu telemetry
  được gửi về **endpoint do bạn tự host** (gói `Reference-Backend`), thay vì nằm trên
  USB. Bạn toàn quyền dữ liệu của mình. Yêu cầu khả năng triển khai + vận hành hạ tầng.

> Nếu bạn chưa cần các tính năng tự chủ này, mọi thứ vẫn hoạt động đầy đủ với nguồn
> mặc định của CoreSystem — đây là các lựa chọn mở rộng khi doanh nghiệp phát triển.

## Bảng so sánh quyền lợi

| Quyền hạn / Tính năng | Trial | MSP Standard | MSP Advanced |
|-------|:---:|:------------:|:------------:|
| Thời hạn | 30 ngày | Theo hợp đồng | Theo hợp đồng |
| Sử dụng USB/ISO tiêu chuẩn | ✅ | ✅ | ✅ |
| Tùy biến Profiles (không giới hạn) | ✅ | ✅ | ✅ |
| **Express Deploy (F3)** | ✅ | ✅ | ✅ |
| Xây dựng USB/ISO tùy biến (Whitebox) | — | ✅ | ✅ |
| **Telemetry CSV trên USB** | ✅ | ✅ | ✅ |
| **Telemetry BYOB** (endpoint tự host) | — | — | ✅ |
| **OSCatalog tự host** | — | ✅ | ✅ |
| **Zero Touch** (Boot USB → done) | — | — | ✅ |
| **Mã hóa Profile** | — | — | ✅ |
| Reference-Backend + tài liệu | — | — | ✅ |


## Quy trình thay đổi gói dịch vụ hoặc gia hạn bản quyền

Để nâng cấp gói, gia hạn thời gian sử dụng hoặc cấp lại license (re-key khi USB hỏng/mất),
liên hệ trực tiếp với CoreSystem. Các thao tác cấp phép được quản lý tập trung phía
CoreSystem để đảm bảo mọi bản quyền đều hợp lệ và an toàn.
