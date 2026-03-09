local VORPcore = exports.vorp_core:GetCore()

local function IsPlayerVIP(source)
    local id = GetPlayerIdentifier(source, 0)
    for _, v in ipairs(Config.VIPPlayers) do if id == v then return true end end
    return false
end

local function IsPlayerAdmin(source)
    local id = GetPlayerIdentifier(source, 0)
    for _, v in ipairs(Config.AdminPlayers) do if id == v then return true end end
    return false
end

-- Reward Heartbeat
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for _, source in ipairs(GetPlayers()) do
            local User = VORPcore.getUser(source)
            if User then
                local charId = User.getUsedCharacter.charIdentifier
                exports.ghmattimysql:execute('SELECT last_daily, invest_amount, invest_remaining FROM characters WHERE charidentifier = @id', {['@id'] = charId}, function(res)
                    if res[1] then
                        -- Investment Heartbeat
                        if res[1].invest_remaining > 0 then
                            local newTime = res[1].invest_remaining - 1
                            if newTime <= 0 then
                                User.getUsedCharacter.addCurrency(0, res[1].invest_amount * 2)
                                exports.ghmattimysql:execute('UPDATE characters SET invest_amount = 0, invest_remaining = 0 WHERE charidentifier = @id', {['@id'] = charId})
                            else
                                exports.ghmattimysql:execute('UPDATE characters SET invest_remaining = @t WHERE charidentifier = @id', {['@t'] = newTime, ['@id'] = charId})
                            end
                        end
                        -- Update Overlay
                        local rem = 86400 - (os.time() - res[1].last_daily)
                        if rem <= 0 then TriggerClientEvent('my_mod:updateOverlay', source, "~g~Ready!")
                        else TriggerClientEvent('my_mod:updateOverlay', source, string.format("~o~%dh %dm", math.floor(rem/3600), math.floor((rem%3600)/60))) end
                    end
                end)
            end
        end
    end
end)

RegisterServerEvent('my_mod:claimDaily')
AddEventHandler('my_mod:claimDaily', function()
    local src = source
    local char = VORPcore.getUser(src).getUsedCharacter
    local isVIP = IsPlayerVIP(src)
    exports.ghmattimysql:execute('SELECT last_daily, daily_streak FROM characters WHERE charidentifier = @id', {['@id'] = char.charIdentifier}, function(res)
        if (os.time() - res[1].last_daily) >= 86400 then
            local streak = (os.time() - res[1].last_daily > 172800) and 1 or (res[1].daily_streak + 1)
            local pool = isVIP and Config.VIPDailyRewards or Config.DailyRewards
            local roll, cur = math.random(1, 100), 0
            for _, v in ipairs(pool) do
                cur = cur + v.chance
                if roll <= cur then
                    if v.cash then char.addCurrency(0, v.cash) else exports.vorp_inventory:addItem(src, v.item, v.amount) end
                    break
                end
            end
            local sCfg = isVIP and Config.VIPStreakReward or Config.StreakReward
            if streak == sCfg.days then
                char.addCurrency(0, sCfg.cash)
                exports.vorp_inventory:addItem(src, sCfg.item, sCfg.amount)
                streak = 0
            end
            exports.ghmattimysql:execute('UPDATE characters SET last_daily = @now, daily_streak = @s WHERE charidentifier = @id', {['@now'] = os.time(), ['@s'] = streak, ['@id'] = char.charIdentifier})
        end
    end)
end)