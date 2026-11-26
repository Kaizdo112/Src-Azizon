StakeV = StakeV or {}

function StakeV.Debug(...)
    if Config.Debug then
        print(('[^5StakeV^7] %s'):format(table.concat({ ... }, ' ')))
    end
end

function StakeV.FormatMoney(amount)
    local s = tostring(math.floor(amount or 0))
    local formatted = s:reverse():gsub('(%d%d%d)', '%1.'):reverse()
    return (formatted:gsub('^%.', '')) .. ' $'
end
