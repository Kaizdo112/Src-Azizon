-- ESX Legacy đã nạp sẵn biến ESX qua @es_extended/imports.lua

-- Bảng thông tin StakeV riêng cho mỗi nhân vật (mở rộng ngoài bảng users của ESX)
local profiles = {}

local function loadProfile(identifier)
    local row = MySQL.single.await('SELECT * FROM stakev_profiles WHERE identifier = ?', { identifier })
    if not row then
        MySQL.insert.await('INSERT INTO stakev_profiles (identifier) VALUES (?)', { identifier })
        row = MySQL.single.await('SELECT * FROM stakev_profiles WHERE identifier = ?', { identifier })
    end
    return row
end

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer, isNew)
    local profile = loadProfile(xPlayer.identifier)
    profiles[playerId] = profile

    MySQL.update('UPDATE stakev_profiles SET last_login = NOW() WHERE identifier = ?', { xPlayer.identifier })
    StakeV.Log('join', playerId, ('%s vào server (mới: %s)'):format(xPlayer.getName(), tostring(isNew)))

    TriggerClientEvent('stakev:core:profile', playerId, profile, isNew)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
    local profile = profiles[playerId]
    if profile then
        StakeV.Log('leave', playerId, ('Rời server: %s'):format(reason or '?'))
    end
    profiles[playerId] = nil
end)

-- API cho resource khác: exports.stakev_core:GetProfile(source)
exports('GetProfile', function(playerId)
    return profiles[playerId]
end)

-- Cộng giờ chơi mỗi phút cho người đang online
CreateThread(function()
    while true do
        Wait(60 * 1000)
        for playerId, profile in pairs(profiles) do
            profile.playtime_minutes = (profile.playtime_minutes or 0) + 1
        end
    end
end)

-- Ghi giờ chơi xuống DB định kỳ
CreateThread(function()
    while true do
        Wait(Config.SaveIntervalMinutes * 60 * 1000)
        for _, profile in pairs(profiles) do
            MySQL.update('UPDATE stakev_profiles SET playtime_minutes = ? WHERE identifier = ?',
                { profile.playtime_minutes, profile.identifier })
        end
    end
end)
