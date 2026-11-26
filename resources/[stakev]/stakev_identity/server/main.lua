local C = IdentityConfig

-- Chữ cái (kể cả tiếng Việt có dấu), không số / ký hiệu, viết hoa chữ đầu
local function validName(name)
    if type(name) ~= 'string' then return false end
    local len = utf8.len(name)
    if not len or len < C.NameMin or len > C.NameMax then return false end
    if name:find('[%d%s%p]') then return false end
    return true
end

local function validDob(dob)
    if type(dob) ~= 'string' then return false end
    local y, m, d = dob:match('^(%d%d%d%d)%-(%d%d)%-(%d%d)$')
    y, m, d = tonumber(y), tonumber(m), tonumber(d)
    if not (y and m and d) or m < 1 or m > 12 or d < 1 or d > 31 then return false end
    local now = os.date('*t')
    local age = now.year - y - ((now.month < m or (now.month == m and now.day < d)) and 1 or 0)
    return age >= C.AgeMin and age <= C.AgeMax
end

local function hasIdentity(identifier)
    local row = MySQL.single.await('SELECT firstname FROM users WHERE identifier = ?', { identifier })
    return row and row.firstname and row.firstname ~= ''
end

ESX.RegisterServerCallback('stakev_identity:needsIdentity', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer and not hasIdentity(xPlayer.identifier))
end)

ESX.RegisterServerCallback('stakev_identity:register', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or type(data) ~= 'table' then return cb(false, 'Dữ liệu không hợp lệ') end
    if hasIdentity(xPlayer.identifier) then return cb(false, 'Nhân vật đã được tạo') end

    if not validName(data.firstname) or not validName(data.lastname) then
        return cb(false, ('Họ và tên phải %d-%d chữ cái, không có số hay ký hiệu'):format(C.NameMin, C.NameMax))
    end
    if not validDob(data.dateofbirth) then
        return cb(false, ('Tuổi nhân vật phải từ %d đến %d'):format(C.AgeMin, C.AgeMax))
    end
    if data.sex ~= 'm' and data.sex ~= 'f' then return cb(false, 'Chưa chọn giới tính') end
    local height = tonumber(data.height)
    if not height or height < C.HeightMin or height > C.HeightMax then
        return cb(false, ('Chiều cao từ %d đến %d cm'):format(C.HeightMin, C.HeightMax))
    end

    MySQL.update.await(
        'UPDATE users SET firstname = ?, lastname = ?, dateofbirth = ?, sex = ?, height = ? WHERE identifier = ?',
        { data.firstname, data.lastname, data.dateofbirth, data.sex, math.floor(height), xPlayer.identifier })

    xPlayer.setName(('%s %s'):format(data.firstname, data.lastname))
    xPlayer.set('firstName', data.firstname)
    xPlayer.set('lastName', data.lastname)
    xPlayer.set('dateofbirth', data.dateofbirth)
    xPlayer.set('sex', data.sex)
    xPlayer.set('height', math.floor(height))

    exports.stakev_core:Log('identity', source, ('Tạo nhân vật %s %s'):format(data.firstname, data.lastname))
    cb(true)
end)
