local profile = nil

-- Vị trí xuất hiện do stakev_spawn xử lý
RegisterNetEvent('stakev:core:profile', function(data)
    profile = data
end)

RegisterNetEvent('stakev:core:teleport', function(coords)
    local ped = PlayerPedId()
    DoScreenFadeOut(300)
    Wait(300)
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
    Wait(300)
    DoScreenFadeIn(300)
end)

exports('GetProfile', function()
    return profile
end)

-- Tắt NPC cảnh sát truy nã mặc định của GTA để RP thuần
CreateThread(function()
    for i = 1, 15 do EnableDispatchService(i, false) end
    while true do
        Wait(1000)
        local pid = PlayerId()
        if GetPlayerWantedLevel(pid) > 0 then
            ClearPlayerWantedLevel(pid)
        end
        SetMaxWantedLevel(0)
    end
end)
