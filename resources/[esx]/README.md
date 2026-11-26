# ESX Legacy

Thư mục này chứa ESX Legacy, **không commit vào repo** (tải về khi cài server).

```bash
cd resources/[esx]
git clone --depth 1 https://github.com/esx-framework/esx_core.git tmp
mv tmp/[core] ./ && rm -rf tmp
# StakeV tự làm phần tạo nhân vật và chọn spawn, nên bỏ 2 resource này:
rm -rf "[core]/esx_identity" "[core]/esx_multicharacter"
```

`skinchanger` và `esx_skin` (có trong `[core]`) vẫn cần, `stakev_identity` dùng chúng cho bước chọn ngoại hình.

Sau đó import `resources/[esx]/[core]/es_extended/legacy.sql` (hoặc file SQL đi kèm bản ESX bạn tải) vào database `stakev`, rồi import `sql/stakev.sql` của repo này.
