# Lộ trình tính năng StakeV

Lối chơi lấy cảm hứng từ các server RP kiểu Majestic: nghề nghiệp, tổ chức, nhà, doanh nghiệp, xe, điện thoại, battle pass, HUD hiện đại. **Toàn bộ code tự viết** trên ESX Legacy; chỉ dùng ý tưởng, không lấy code hay asset của server khác.

Quy ước: resource tự viết đặt trong `resources/[stakev]/` với tiền tố `stakev_`. Resource ESX chính thức và thư viện (oxmysql, ox_lib, ox_inventory...) tải về, không commit.

## Giai đoạn 1: Nền móng (PR này + vài PR tiếp)
| Hạng mục | Cách làm | Trạng thái |
|---|---|---|
| server.cfg, cấu trúc thư mục | tự viết | ✅ PR này |
| Lõi `stakev_core` (hồ sơ, log, quyền admin) | tự viết | ✅ PR này |
| HUD `stakev_hud` (máu, giáp, đói, khát, tiền, xe) | tự viết, NUI | ✅ PR này |
| Database `stakev.sql` | tự viết | ✅ PR này |
| Tạo nhân vật (họ tên, ngày sinh, giới tính, ngoại hình) | `esx_identity` + skin UI tự viết | ⏳ |
| Màn hình chọn spawn (nhà, tổ chức, điểm cuối) | `stakev_spawn` | ⏳ |
| Túi đồ | `ox_inventory` (bản mở) | ⏳ |
| Thông báo, menu, progress bar | `ox_lib` + giao diện StakeV | ⏳ |

## Giai đoạn 2: Xã hội và tài sản
- **Fraction nhà nước** (job ESX): LSPD, Sheriff, EMS, Chính phủ, Quân đội, Báo chí. Còng, khám xét, phạt, tù, hồi sinh, hoá đơn.
- **Tổ chức tự lập**: băng đảng / mafia / gia đình, quỹ chung, cấp bậc, chiếm lãnh thổ.
- **Nhà**: mua/bán, khoá, kho đồ, garage, thuê phòng, thuế.
- **Xe**: showroom, garage, chìa khoá, xăng, tạm giữ xe, biển số.
- **Điện thoại**: danh bạ, tin nhắn, ngân hàng, gọi taxi/cảnh sát/EMS.

## Giai đoạn 3: Kinh tế
- **Nghề tự do**: tài xế xe tải, thợ mỏ, câu cá, xe buýt, giao hàng, thợ máy, taxi, thợ săn.
- **Doanh nghiệp**: cây xăng, cửa hàng 24/7, shop quần áo, barber, tattoo, ammu-nation, showroom xe; chủ nhập hàng và đặt giá.
- **Ngân hàng**: chuyển khoản, ATM, thẻ, lãi suất.
- **Hoạt động phi pháp**: cướp cửa hàng/ngân hàng, trồng và chế biến hàng cấm, buôn vũ khí.

## Giai đoạn 4: Giữ chân người chơi
- Cấp độ + EXP, battle pass theo mùa, nhiệm vụ hằng ngày.
- VIP / donate coin, cửa hàng donate.
- Sự kiện (đua xe, săn kho báu), casino.

## Giai đoạn 5: Hệ sinh thái
- Panel admin web, liên kết Discord.
- Launcher StakeV và website (mảng riêng của dự án).
- Anticheat server-side: kiểm tra event, tốc độ/teleport, tiền bất thường (dựa trên `stakev_logs`).
