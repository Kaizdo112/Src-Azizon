-- Ghi log hành động vào DB (và Discord nếu có webhook)
function StakeV.Log(category, playerId, message)
    local identifier = nil
    if playerId then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        identifier = xPlayer and xPlayer.identifier or nil
    end

    MySQL.insert('INSERT INTO stakev_logs (category, identifier, message) VALUES (?, ?, ?)',
        { category, identifier, message })

    if Config.LogWebhook ~= '' then
        PerformHttpRequest(Config.LogWebhook, function() end, 'POST', json.encode({
            username = Config.ServerName .. ' Logs',
            embeds = { {
                title = category,
                description = message,
                footer = { text = identifier or 'server' },
                color = 0x7c5cff,
            } },
        }), { ['Content-Type'] = 'application/json' })
    end
end

exports('Log', StakeV.Log)
