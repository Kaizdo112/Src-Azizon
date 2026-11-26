# StakeV Roleplay – Server FiveM

Server GTA V roleplay **StakeV**, xây trên **ESX Legacy**. Lối chơi kiểu Majestic RP (nghề nghiệp, tổ chức, nhà, doanh nghiệp, battle pass...), code tự viết.

Lộ trình chi tiết: [docs/ROADMAP.md](docs/ROADMAP.md)

## Cấu trúc
```
server.cfg.example        # cấu hình mẫu, copy thành server.cfg
sql/stakev.sql            # bảng riêng của StakeV
resources/
  [esx]/                  # ESX Legacy (tải về, không commit)
  [standalone]/           # oxmysql, ox_lib... (tải về, không commit)
  [stakev]/               # resource tự viết
    stakev_core/          # hồ sơ người chơi, log, lệnh admin
    stakev_hud/           # HUD giao diện GTA V Modern Premium
    stakev_identity/      # tạo nhân vật (thay esx_identity)
    stakev_spawn/         # chọn điểm xuất hiện
docs/                     # tài liệu
```

## Cài đặt nhanh
1. Cài FiveM server artifacts (hoặc txAdmin) và MariaDB/MySQL.
2. Tạo database `stakev` (utf8mb4).
3. Tải ESX Legacy vào `resources/[esx]/` và oxmysql, ox_lib vào `resources/[standalone]/` (xem README trong từng thư mục).
4. Import SQL của ESX, sau đó `sql/stakev.sql`.
5. `cp server.cfg.example server.cfg`, điền license key và chuỗi kết nối DB.
6. Chạy server: `FXServer +exec server.cfg`.

## Lệnh admin (ACE `stakev.admin`)
- `/sv_tp x y z` – dịch chuyển
- `/sv_givemoney <id> <money|bank|black_money> <số tiền>`
- `/hud` – bật/tắt HUD (mọi người chơi)

![HUD StakeV](docs/img/hud-preview.png)
