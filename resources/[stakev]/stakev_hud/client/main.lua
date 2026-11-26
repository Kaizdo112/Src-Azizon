local status = { hunger = 100, thirst = 100 }
local visible = true

local function getAccount(name)
    for _, acc in ipairs(ESX.PlayerData.accounts or {}) do
        if acc.name == name then return acc.money end
    end
    return 0
end

-- esx_status (nếu có) bắn sự kiện này mỗi lần cập nhật
AddEventHandler('esx_status:onTick', function(data)
    for _, s in ipairs(data) do
        if s.name == 'hunger' or s.name == 'thirst' then
            status[s.name] = math.floor(s.percent)
        end
    end
end)

RegisterNetEvent('esx:playerLoaded', function()
    SendNUIMessage({ action = 'show', server = 'StakeV', id = GetPlayerServerId(PlayerId()) })
end)

RegisterCommand('hud', function()
    visible = not visible
    SendNUIMessage({ action = visible and 'show' or 'hide' })
end, false)

-- Ẩn HUD gốc của GTA (tiền, tên khu vực, tên xe...)
CreateThread(function()
    while true do
        Wait(0)
        for _, c in ipairs({ 1, 2, 3, 4, 6, 7, 8, 9, 13 }) do
            HideHudComponentThisFrame(c)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(200)
        if visible and ESX.IsPlayerLoaded() then
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            local inVeh = veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped

            local coords = GetEntityCoords(ped)
            local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
            local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))

            SendNUIMessage({
                action = 'update',
                health = math.max(0, GetEntityHealth(ped) - 100),
                armor = GetPedArmour(ped),
                hunger = status.hunger,
                thirst = status.thirst,
                cash = getAccount('money'),
                bank = getAccount('bank'),
                job = ESX.PlayerData.job and (ESX.PlayerData.job.label .. ' - ' .. ESX.PlayerData.job.grade_label) or '',
                street = street,
                zone = zone,
                time = ('%02d:%02d'):format(GetClockHours(), GetClockMinutes()),
                vehicle = inVeh and {
                    speed = math.floor(GetEntitySpeed(veh) * 3.6),
                    fuel = math.floor(GetVehicleFuelLevel(veh)),
                    gear = GetVehicleCurrentGear(veh),
                    rpm = GetVehicleCurrentRpm(veh),
                    engine = GetIsVehicleEngineRunning(veh),
                } or false,
            })
        end
    end
end)

-- Khi restart resource lúc đang trong game
CreateThread(function()
    while not ESX.IsPlayerLoaded() do Wait(500) end
    SendNUIMessage({ action = 'show', server = 'StakeV', id = GetPlayerServerId(PlayerId()) })
end)
