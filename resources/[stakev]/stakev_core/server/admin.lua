-- Lệnh admin cơ bản. Quyền theo ACE "stakev.admin" (xem server.cfg)

local function isAdmin(source)
    return source == 0 or IsPlayerAceAllowed(source, 'stakev.admin')
end

RegisterCommand('sv_tp', function(source, args)
    if not isAdmin(source) then return end
    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    if not (x and y and z) then return end
    TriggerClientEvent('stakev:core:teleport', source, vector3(x, y, z))
    StakeV.Log('admin', source, ('Teleport tới %.1f %.1f %.1f'):format(x, y, z))
end, false)

RegisterCommand('sv_givemoney', function(source, args)
    if not isAdmin(source) then return end
    local target, account, amount = tonumber(args[1]), args[2] or 'money', tonumber(args[3])
    local xTarget = target and ESX.GetPlayerFromId(target)
    if not (xTarget and amount) then return end
    xTarget.addAccountMoney(account, amount)
    StakeV.Log('admin', source, ('Cho %s vào tài khoản %s của #%d'):format(StakeV.FormatMoney(amount), account, target))
end, false)
