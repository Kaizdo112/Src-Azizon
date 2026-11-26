local C = SpawnConfig
local cam = nil
local options = {}

local function setCamTo(coords)
    if not cam then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        RenderScriptCams(true, false, 0, true, true)
    end
    SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)
    SetCamCoord(cam, coords.x, coords.y - 60.0, coords.z + C.CamHeight)
    PointCamAtCoord(cam, coords.x, coords.y, coords.z)
end

local function destroyCam()
    if cam then
        RenderScriptCams(false, true, 1200, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
    ClearFocus()
end

local function findOption(id)
    for _, o in ipairs(options) do
        if o.id == id then return o end
    end
end

AddEventHandler('stakev:spawn:open', function(data)
    local isNew = data and data.isNew
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, false)

    ESX.TriggerServerCallback('stakev_spawn:getOptions', function(list)
        options = list
        if options[1] then setCamTo(options[1].coords) end
        DoScreenFadeIn(600)
        SetNuiFocus(true, true)
        local ui = {}
        for i, o in ipairs(options) do
            ui[i] = { id = o.id, label = o.label, desc = o.desc, icon = o.icon }
        end
        SendNUIMessage({ action = 'open', options = ui, isNew = isNew })
    end, isNew)
end)

RegisterNUICallback('preview', function(data, cb)
    local o = findOption(data.id)
    if o then setCamTo(o.coords) end
    cb(1)
end)

RegisterNUICallback('choose', function(data, cb)
    ESX.TriggerServerCallback('stakev_spawn:choose', function(coords)
        cb({ ok = coords ~= false })
        if not coords then return end

        SetNuiFocus(false, false)
        SendNUIMessage({ action = 'close' })
        DoScreenFadeOut(500)
        Wait(500)

        local ped = PlayerPedId()
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
        SetEntityHeading(ped, coords.w)
        local timeout = GetGameTimer() + 5000
        while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < timeout do Wait(0) end

        destroyCam()
        SetEntityVisible(ped, true, false)
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        SetPlayerControl(PlayerId(), true, 0)
        Wait(300)
        DoScreenFadeIn(800)
        TriggerEvent('stakev:spawn:done', data.id)
    end, data.id)
end)
