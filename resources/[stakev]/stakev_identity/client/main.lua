local C = IdentityConfig
local pending = nil

local function freeze(state)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, state)
    SetEntityInvincible(ped, state)
    SetPlayerControl(PlayerId(), not state, 0)
end

local function openSkinMenu(sex)
    TriggerEvent('skinchanger:loadDefaultModel', sex == 'm', function()
        TriggerEvent('esx_skin:openSaveableMenu', function()
            TriggerEvent('stakev:spawn:open', { isNew = true })
        end, function()
            -- Không cho bỏ qua bước ngoại hình
            openSkinMenu(sex)
        end)
    end)
end

local function openCreator()
    local p = C.CreatorCoords
    local ped = PlayerPedId()
    SetEntityCoords(ped, p.x, p.y, p.z, false, false, false, false)
    SetEntityHeading(ped, p.w)
    freeze(true)
    DoScreenFadeIn(500)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', limits = C })
end

AddEventHandler('esx:playerLoaded', function()
    DoScreenFadeOut(0)
    freeze(true)
    ESX.TriggerServerCallback('stakev_identity:needsIdentity', function(needs)
        if needs then
            openCreator()
        else
            TriggerEvent('stakev:spawn:open', { isNew = false })
        end
    end)
end)

RegisterNUICallback('submit', function(data, cb)
    ESX.TriggerServerCallback('stakev_identity:register', function(ok, err)
        cb({ ok = ok, error = err })
        if ok then
            SetNuiFocus(false, false)
            SendNUIMessage({ action = 'close' })
            freeze(false)
            openSkinMenu(data.sex)
        end
    end, data)
end)
