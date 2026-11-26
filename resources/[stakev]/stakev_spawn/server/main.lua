local C = SpawnConfig
local pointsById = {}
for _, p in ipairs(C.Points) do pointsById[p.id] = p end

local function lastPosition(identifier)
    local row = MySQL.single.await('SELECT position FROM users WHERE identifier = ?', { identifier })
    local pos = row and row.position and json.decode(row.position)
    if pos and pos.x and pos.y and pos.z then
        return vector4(pos.x, pos.y, pos.z, pos.heading or 0.0)
    end
end

local function ownedHouses(identifier)
    local ok, rows = pcall(MySQL.query.await, 'SELECT id, label, entrance FROM stakev_houses WHERE owner = ?', { identifier })
    if not ok or not rows then return {} end
    local list = {}
    for _, h in ipairs(rows) do
        local e = json.decode(h.entrance)
        if e then
            list[#list + 1] = { id = 'house:' .. h.id, label = h.label, desc = 'Nhà của bạn', icon = '⌂',
                coords = vector4(e.x, e.y, e.z, e.h or 0.0) }
        end
    end
    return list
end

-- Danh sách điểm người chơi được chọn (server quyết định, client chỉ hiển thị)
local function buildOptions(source, isNew)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return {} end
    local options = {}

    if not isNew then
        local last = lastPosition(xPlayer.identifier)
        if last then
            options[#options + 1] = { id = 'last', label = 'Vị trí cuối', desc = 'Nơi bạn thoát game lần trước', icon = '⟲', coords = last }
        end
        for _, h in ipairs(ownedHouses(xPlayer.identifier)) do options[#options + 1] = h end
    end

    for _, p in ipairs(C.Points) do
        if not isNew or C.NewPlayerPoints[p.id] then options[#options + 1] = p end
    end
    return options
end

local sessions = {}

ESX.RegisterServerCallback('stakev_spawn:getOptions', function(source, cb, isNew)
    local options = buildOptions(source, isNew == true)
    local allowed = {}
    for _, o in ipairs(options) do allowed[o.id] = o.coords end
    sessions[source] = allowed
    cb(options)
end)

ESX.RegisterServerCallback('stakev_spawn:choose', function(source, cb, id)
    local allowed = sessions[source]
    local coords = allowed and allowed[id]
    if not coords then return cb(false) end
    sessions[source] = nil
    exports.stakev_core:Log('spawn', source, ('Xuất hiện tại %s'):format(id))
    cb(coords)
end)

AddEventHandler('playerDropped', function() sessions[source] = nil end)
