SpawnConfig = {}

-- Điểm công cộng. newOnly = chỉ nhân vật mới thấy.
SpawnConfig.Points = {
    { id = 'airport', label = 'Sân bay Los Santos', desc = 'Điểm đến cho người mới', icon = '✈', coords = vector4(-1037.74, -2738.04, 20.17, 330.0) },
    { id = 'legion',  label = 'Quảng trường Legion', desc = 'Trung tâm thành phố',    icon = '🏙', coords = vector4(195.17, -933.77, 30.69, 145.0) },
    { id = 'pillbox', label = 'Bệnh viện Pillbox',   desc = 'Gần EMS và ngân hàng',   icon = '✚', coords = vector4(298.67, -584.48, 43.26, 70.0) },
    { id = 'sandy',   label = 'Sandy Shores',        desc = 'Vùng sa mạc Blaine',     icon = '🌵', coords = vector4(1836.36, 3672.84, 34.28, 210.0) },
    { id = 'paleto',  label = 'Paleto Bay',          desc = 'Thị trấn phía bắc',      icon = '🌲', coords = vector4(-160.31, 6312.33, 31.39, 315.0) },
}

-- Nhân vật mới chỉ được xuất hiện ở các điểm này
SpawnConfig.NewPlayerPoints = { airport = true }

-- Độ cao camera khi xem trước
SpawnConfig.CamHeight = 220.0
