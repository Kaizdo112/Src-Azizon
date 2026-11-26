# ESX Legacy

Thư mục này chứa ESX Legacy, **không commit vào repo** (tải về khi cài server).

```bash
cd resources/[esx]
git clone --depth 1 https://github.com/esx-framework/esx_core.git tmp
mv tmp/[core] ./ && rm -rf tmp
```

Sau đó import `resources/[esx]/[core]/es_extended/legacy.sql` (hoặc file SQL đi kèm bản ESX bạn tải) vào database `stakev`, rồi import `sql/stakev.sql` của repo này.
